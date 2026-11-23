//! Decoding ACRE's sound files (base64 WAV, as the `.b64` files in `sys_sounds` hold them).

use acre2_voice_client::audio::{Resampler, downmix};
use acre2_voice_codec::SAMPLE_RATE;
use base64::Engine;

/// Base64 WAV → 48 kHz mono `f32`.
pub fn decode(base64: &str) -> Result<Vec<f32>, String> {
    let bytes = base64::engine::general_purpose::STANDARD
        .decode(base64.trim())
        .map_err(|e| format!("bad base64: {e}"))?;
    let wav = parse_wav(&bytes)?;
    let mut mono = Vec::new();
    downmix(&wav.samples, usize::from(wav.channels), &mut mono);
    let mut out = Vec::with_capacity(mono.len());
    Resampler::new(wav.sample_rate, SAMPLE_RATE).process(&mono, &mut out);
    Ok(out)
}

#[derive(Debug, PartialEq)]
struct Wav {
    channels: u16,
    sample_rate: u32,
    samples: Vec<f32>,
}

fn u16_at(b: &[u8], i: usize) -> Option<u16> {
    Some(u16::from_le_bytes(b.get(i..i + 2)?.try_into().ok()?))
}
fn u32_at(b: &[u8], i: usize) -> Option<u32> {
    Some(u32::from_le_bytes(b.get(i..i + 4)?.try_into().ok()?))
}

/// Minimal RIFF/WAVE reader: 16-bit PCM, any channel count and rate.
fn parse_wav(b: &[u8]) -> Result<Wav, String> {
    if b.get(0..4) != Some(b"RIFF") || b.get(8..12) != Some(b"WAVE") {
        return Err("not a WAV file".into());
    }
    let mut pos = 12;
    let mut format = None;
    while pos + 8 <= b.len() {
        let id = &b[pos..pos + 4];
        let len = u32_at(b, pos + 4).ok_or("truncated chunk")? as usize;
        let body = pos + 8;
        let end = (body + len).min(b.len());
        match id {
            b"fmt " => {
                let tag = u16_at(b, body).ok_or("truncated fmt")?;
                let channels = u16_at(b, body + 2).ok_or("truncated fmt")?;
                let rate = u32_at(b, body + 4).ok_or("truncated fmt")?;
                let bits = u16_at(b, body + 14).ok_or("truncated fmt")?;
                if tag != 1 || bits != 16 || channels == 0 {
                    return Err(format!("unsupported WAV format (tag {tag}, {bits} bit)"));
                }
                format = Some((channels, rate));
            }
            b"data" => {
                let (channels, sample_rate) = format.ok_or("data before fmt")?;
                let samples = b[body..end]
                    .as_chunks::<2>()
                    .0
                    .iter()
                    .map(|s| f32::from(i16::from_le_bytes([s[0], s[1]])) / 32768.0)
                    .collect();
                return Ok(Wav {
                    channels,
                    sample_rate,
                    samples,
                });
            }
            _ => {}
        }
        pos = body + len + (len & 1);
    }
    Err("no data chunk".into())
}

#[cfg(test)]
mod tests {
    use super::*;

    fn wav(channels: u16, rate: u32, samples: &[i16]) -> Vec<u8> {
        let data: Vec<u8> = samples.iter().flat_map(|s| s.to_le_bytes()).collect();
        let mut b = Vec::new();
        b.extend_from_slice(b"RIFF");
        b.extend_from_slice(&(36 + data.len() as u32).to_le_bytes());
        b.extend_from_slice(b"WAVEfmt ");
        b.extend_from_slice(&16u32.to_le_bytes());
        b.extend_from_slice(&1u16.to_le_bytes());
        b.extend_from_slice(&channels.to_le_bytes());
        b.extend_from_slice(&rate.to_le_bytes());
        b.extend_from_slice(&(rate * u32::from(channels) * 2).to_le_bytes());
        b.extend_from_slice(&(channels * 2).to_le_bytes());
        b.extend_from_slice(&16u16.to_le_bytes());
        b.extend_from_slice(b"data");
        b.extend_from_slice(&(data.len() as u32).to_le_bytes());
        b.extend_from_slice(&data);
        b
    }

    #[test]
    fn decodes_mono_48k() {
        let b64 =
            base64::engine::general_purpose::STANDARD.encode(wav(1, 48_000, &[0, 16384, -16384]));
        assert_eq!(decode(&b64).unwrap(), vec![0.0, 0.5, -0.5]);
    }

    #[test]
    fn downmixes_and_resamples() {
        let b64 = base64::engine::general_purpose::STANDARD.encode(wav(2, 24_000, &[1000; 2400]));
        let out = decode(&b64).unwrap();
        assert!((out.len() as i64 - 2400).abs() <= 4, "{}", out.len());
    }

    #[test]
    fn rejects_garbage() {
        assert!(decode("!!!").is_err());
        let b64 = base64::engine::general_purpose::STANDARD.encode(b"RIFF....WAVExxxx");
        assert!(decode(&b64).is_err());
    }

    #[test]
    fn decodes_the_real_acre_beep() {
        let path = concat!(
            env!("CARGO_MANIFEST_DIR"),
            "/../../../addons/sys_sounds/sounds/beep.b64"
        );
        let Ok(text) = std::fs::read_to_string(path) else {
            return; // not in a full checkout
        };
        // The file is SQF: ACRE_B64_FILE = ["…", "…", ""];
        let b64: String = text.split('"').skip(1).step_by(2).collect();
        let samples = decode(&b64).unwrap();
        assert!(samples.len() > 4000, "{}", samples.len());
    }
}
