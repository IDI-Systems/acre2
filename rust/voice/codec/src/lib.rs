//! Opus encoding/decoding, a jitter buffer, and loss concealment for game voice.
//!
//! Audio is always 48 kHz mono `f32` in `[-1, 1]`. Frames are [`FRAME_MS`] long by default.
//!
//! - [`VoiceEncoder`]: one per local transmission source (the microphone).
//! - [`VoiceStream`]: one per remote transmission; feed it datagrams as they arrive with
//!   [`VoiceStream::push`], and pull exactly one frame per frame period with
//!   [`VoiceStream::next_frame`]. It reorders, waits out jitter, recovers single lost frames from
//!   Opus in-band FEC and conceals the rest.

mod jitter;

use bytes::Bytes;
pub use jitter::{JitterBuffer, JitterConfig, JitterStats, Slot};
use opusic_c::{
    Application, Bandwidth, Bitrate, Channels, Decoder, Encoder, InbandFec, SampleRate, Signal,
};

pub const SAMPLE_RATE: u32 = 48_000;
/// Default frame duration.
pub const FRAME_MS: u32 = 20;
/// Samples in a default frame.
pub const FRAME_SAMPLES: usize = (SAMPLE_RATE / 1000 * FRAME_MS) as usize;
/// Largest Opus packet we produce.
pub const MAX_PACKET: usize = 1275;
/// Largest frame Opus can decode (120 ms), for decode buffers.
const MAX_DECODE_SAMPLES: usize = SAMPLE_RATE as usize / 1000 * 120;

#[derive(Debug, thiserror::Error)]
pub enum CodecError {
    #[error("opus: {0:?}")]
    Opus(opusic_c::ErrorCode),
    #[error("frame must be {expected} samples, got {got}")]
    FrameSize { expected: usize, got: usize },
    #[error("unsupported frame duration {0} ms (use 10, 20, 40 or 60)")]
    FrameDuration(u32),
}

impl From<opusic_c::ErrorCode> for CodecError {
    fn from(e: opusic_c::ErrorCode) -> Self {
        Self::Opus(e)
    }
}

/// Encoder settings. The defaults suit game chat: speech-tuned, 24 kbps VBR, FEC for 10% loss,
/// DTX so silence costs almost nothing.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct EncoderConfig {
    pub bitrate: u32,
    pub frame_ms: u32,
    pub fec: bool,
    /// Percentage of packet loss to optimise FEC for.
    pub expected_loss: u8,
    pub dtx: bool,
    /// 0–10; higher is better quality and more CPU.
    pub complexity: u8,
}

impl Default for EncoderConfig {
    fn default() -> Self {
        Self {
            bitrate: 24_000,
            frame_ms: FRAME_MS,
            fec: true,
            expected_loss: 10,
            dtx: true,
            complexity: 8,
        }
    }
}

impl EncoderConfig {
    #[must_use]
    pub fn frame_samples(&self) -> usize {
        (SAMPLE_RATE / 1000 * self.frame_ms) as usize
    }
}

/// Opus voice encoder.
pub struct VoiceEncoder {
    encoder: Encoder,
    frame_samples: usize,
    buf: Vec<u8>,
}

impl std::fmt::Debug for VoiceEncoder {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("VoiceEncoder")
            .field("frame_samples", &self.frame_samples)
            .finish_non_exhaustive()
    }
}

impl VoiceEncoder {
    pub fn new(config: EncoderConfig) -> Result<Self, CodecError> {
        if ![10, 20, 40, 60].contains(&config.frame_ms) {
            return Err(CodecError::FrameDuration(config.frame_ms));
        }
        let mut encoder = Encoder::new(Channels::Mono, SampleRate::Hz48000, Application::Voip)?;
        encoder.set_signal(Signal::Voice)?;
        encoder.set_bitrate(Bitrate::Value(config.bitrate))?;
        encoder.set_vbr(true)?;
        encoder.set_complexity(config.complexity.min(10))?;
        encoder.set_inband_fec(if config.fec {
            InbandFec::Mode1
        } else {
            InbandFec::Off
        })?;
        encoder.set_packet_loss(config.expected_loss.min(100))?;
        encoder.set_dtx(config.dtx)?;
        // 12 kHz of audio bandwidth is plenty for speech, and staying out of fullband keeps
        // Opus in its speech modes (SILK/hybrid), which are the ones that carry in-band FEC.
        encoder.set_max_bandwidth(Bandwidth::Superwide)?;
        Ok(Self {
            encoder,
            frame_samples: config.frame_samples(),
            buf: vec![0; MAX_PACKET],
        })
    }

    #[must_use]
    pub fn frame_samples(&self) -> usize {
        self.frame_samples
    }

    /// Encodes one frame. With DTX on, silent frames come out as 1–2 byte packets; they should
    /// still be sent (they keep the decoder's comfort noise going).
    pub fn encode(&mut self, frame: &[f32]) -> Result<Bytes, CodecError> {
        if frame.len() != self.frame_samples {
            return Err(CodecError::FrameSize {
                expected: self.frame_samples,
                got: frame.len(),
            });
        }
        let n = self.encoder.encode_float_to_slice(frame, &mut self.buf)?;
        Ok(Bytes::copy_from_slice(&self.buf[..n]))
    }

    /// Re-tunes FEC for the loss listeners are seeing.
    pub fn set_expected_loss(&mut self, percent: u8) -> Result<(), CodecError> {
        Ok(self.encoder.set_packet_loss(percent.min(100))?)
    }

    pub fn set_bitrate(&mut self, bitrate: u32) -> Result<(), CodecError> {
        Ok(self.encoder.set_bitrate(Bitrate::Value(bitrate))?)
    }

    /// Call at the start of a new talk spurt.
    pub fn reset(&mut self) -> Result<(), CodecError> {
        Ok(self.encoder.reset()?)
    }
}

/// Opus voice decoder with loss concealment.
pub struct VoiceDecoder {
    decoder: Decoder,
    frame_samples: usize,
    scratch: Vec<f32>,
}

impl std::fmt::Debug for VoiceDecoder {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("VoiceDecoder")
            .field("frame_samples", &self.frame_samples)
            .finish_non_exhaustive()
    }
}

impl VoiceDecoder {
    pub fn new(frame_samples: usize) -> Result<Self, CodecError> {
        Ok(Self {
            decoder: Decoder::new(Channels::Mono, SampleRate::Hz48000)?,
            frame_samples,
            scratch: vec![0.0; MAX_DECODE_SAMPLES],
        })
    }

    /// Decodes a packet into `out` (exactly one frame).
    pub fn decode(&mut self, packet: &[u8], out: &mut [f32]) -> Result<(), CodecError> {
        self.run(packet, false, out)
    }

    /// Recovers the frame *before* `next_packet` from its in-band FEC data (or conceals it if
    /// there is none).
    pub fn decode_fec(&mut self, next_packet: &[u8], out: &mut [f32]) -> Result<(), CodecError> {
        self.run(next_packet, true, out)
    }

    /// Packet loss concealment for a missing frame.
    pub fn conceal(&mut self, out: &mut [f32]) -> Result<(), CodecError> {
        self.run(&[], false, out)
    }

    pub fn reset(&mut self) -> Result<(), CodecError> {
        Ok(self.decoder.reset()?)
    }

    fn run(&mut self, packet: &[u8], fec: bool, out: &mut [f32]) -> Result<(), CodecError> {
        if out.len() != self.frame_samples {
            return Err(CodecError::FrameSize {
                expected: self.frame_samples,
                got: out.len(),
            });
        }
        // PLC and FEC must be asked for exactly one frame; normal decodes take what the packet
        // holds (a sender with a different frame size still decodes, truncated or padded).
        let want = if packet.is_empty() || fec {
            self.frame_samples
        } else {
            self.scratch.len()
        };
        let n = self
            .decoder
            .decode_float_to_slice(packet, &mut self.scratch[..want], fec)?;
        let n = n.min(out.len());
        out[..n].copy_from_slice(&self.scratch[..n]);
        out[n..].fill(0.0);
        Ok(())
    }
}

/// What [`VoiceStream::next_frame`] produced.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum FrameKind {
    /// Decoded from the frame's own packet.
    Audio,
    /// Recovered from the next packet's FEC data.
    Recovered,
    /// Made up by loss concealment.
    Concealed,
    /// Nothing is playing (buffering, or the talk spurt ended). `out` is zeroed.
    Silence,
}

/// One remote transmission: jitter buffer + decoder.
#[derive(Debug)]
pub struct VoiceStream {
    jitter: JitterBuffer,
    decoder: VoiceDecoder,
}

impl VoiceStream {
    pub fn new(config: JitterConfig) -> Result<Self, CodecError> {
        Ok(Self {
            decoder: VoiceDecoder::new(config.frame_samples())?,
            jitter: JitterBuffer::new(config),
        })
    }

    /// Adds a received packet. `now_ms` is a monotonic clock in milliseconds.
    pub fn push(&mut self, seq: u16, end_of_spurt: bool, payload: Bytes, now_ms: u64) {
        self.jitter.push(seq, end_of_spurt, payload, now_ms);
    }

    /// Produces the next frame into `out`. Call once per frame period.
    pub fn next_frame(&mut self, out: &mut [f32]) -> Result<FrameKind, CodecError> {
        match self.jitter.pop() {
            Slot::Packet(p) => {
                self.decoder.decode(&p, out)?;
                Ok(FrameKind::Audio)
            }
            Slot::Lost { next: Some(next) } => {
                self.decoder.decode_fec(&next, out)?;
                Ok(FrameKind::Recovered)
            }
            Slot::Lost { next: None } => {
                self.decoder.conceal(out)?;
                Ok(FrameKind::Concealed)
            }
            Slot::Idle => {
                out.fill(0.0);
                Ok(FrameKind::Silence)
            }
        }
    }

    /// Whether audio is playing (as opposed to buffering or idle).
    #[must_use]
    pub fn is_playing(&self) -> bool {
        self.jitter.is_playing()
    }

    #[must_use]
    pub fn stats(&self) -> JitterStats {
        self.jitter.stats()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn sine(freq: f32, start: usize, len: usize) -> Vec<f32> {
        (start..start + len)
            .map(|i| {
                0.5 * (2.0 * std::f32::consts::PI * freq * i as f32 / SAMPLE_RATE as f32).sin()
            })
            .collect()
    }

    fn rms(x: &[f32]) -> f32 {
        (x.iter().map(|v| v * v).sum::<f32>() / x.len() as f32).sqrt()
    }

    #[test]
    fn roundtrip_preserves_energy() {
        let mut enc = VoiceEncoder::new(EncoderConfig::default()).unwrap();
        let mut dec = VoiceDecoder::new(FRAME_SAMPLES).unwrap();
        let mut out = vec![0.0; FRAME_SAMPLES];
        let mut last_rms = 0.0;
        for i in 0..20 {
            let frame = sine(440.0, i * FRAME_SAMPLES, FRAME_SAMPLES);
            let packet = enc.encode(&frame).unwrap();
            assert!(packet.len() < 200, "packet {} bytes", packet.len());
            dec.decode(&packet, &mut out).unwrap();
            last_rms = rms(&out);
        }
        let expected = rms(&sine(440.0, 0, FRAME_SAMPLES));
        assert!(
            (last_rms - expected).abs() < expected * 0.3,
            "{last_rms} vs {expected}"
        );
    }

    #[test]
    fn dtx_makes_silence_cheap() {
        let mut enc = VoiceEncoder::new(EncoderConfig::default()).unwrap();
        let silence = vec![0.0; FRAME_SAMPLES];
        let sizes: Vec<usize> = (0..30)
            .map(|_| enc.encode(&silence).unwrap().len())
            .collect();
        assert!(sizes[20..].iter().all(|&s| s <= 3), "{sizes:?}");
    }

    #[test]
    fn rejects_wrong_frame_size() {
        let mut enc = VoiceEncoder::new(EncoderConfig::default()).unwrap();
        assert!(matches!(
            enc.encode(&[0.0; 100]),
            Err(CodecError::FrameSize { .. })
        ));
        assert!(matches!(
            VoiceEncoder::new(EncoderConfig {
                frame_ms: 15,
                ..EncoderConfig::default()
            }),
            Err(CodecError::FrameDuration(15))
        ));
    }

    #[test]
    fn concealment_and_fec_produce_audio() {
        let mut enc = VoiceEncoder::new(EncoderConfig::default()).unwrap();
        let mut dec = VoiceDecoder::new(FRAME_SAMPLES).unwrap();
        let mut out = vec![0.0; FRAME_SAMPLES];
        let packets: Vec<Bytes> = (0..12)
            .map(|i| {
                enc.encode(&sine(300.0, i * FRAME_SAMPLES, FRAME_SAMPLES))
                    .unwrap()
            })
            .collect();
        for p in &packets[..10] {
            dec.decode(p, &mut out).unwrap();
        }
        // Frame 10 lost: recover it from frame 11's FEC.
        dec.decode_fec(&packets[11], &mut out).unwrap();
        assert!(rms(&out) > 0.1, "fec rms {}", rms(&out));
        dec.decode(&packets[11], &mut out).unwrap();
        dec.conceal(&mut out).unwrap();
        assert!(rms(&out) > 0.05, "plc rms {}", rms(&out));
    }

    #[test]
    fn stream_plays_through_loss() {
        let mut enc = VoiceEncoder::new(EncoderConfig::default()).unwrap();
        let mut stream = VoiceStream::new(JitterConfig::default()).unwrap();
        let mut out = vec![0.0; FRAME_SAMPLES];
        let mut kinds = Vec::new();
        for i in 0..40u16 {
            let p = enc
                .encode(&sine(300.0, i as usize * FRAME_SAMPLES, FRAME_SAMPLES))
                .unwrap();
            if i != 15 {
                stream.push(i, i == 39, p, u64::from(i) * 20);
            }
            kinds.push(stream.next_frame(&mut out).unwrap());
        }
        for _ in 0..10 {
            kinds.push(stream.next_frame(&mut out).unwrap());
        }
        assert_eq!(
            kinds.iter().filter(|k| **k == FrameKind::Recovered).count(),
            1,
            "{kinds:?}"
        );
        assert_eq!(
            kinds.iter().filter(|k| **k == FrameKind::Audio).count(),
            39,
            "{kinds:?}"
        );
        assert_eq!(*kinds.last().unwrap(), FrameKind::Silence);
        assert!(!stream.is_playing());
    }
}
