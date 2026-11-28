//! Adaptive jitter buffer for one voice stream.
//!
//! Pull-based: the playback side calls [`JitterBuffer::pop`] exactly once per frame period and
//! always gets a [`Slot`]. Playback starts once enough frames are buffered to absorb the
//! measured jitter, and stops at the end of a talk spurt or after too many missing frames.

use std::collections::BTreeMap;

use bytes::Bytes;

use crate::{FRAME_MS, SAMPLE_RATE};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct JitterConfig {
    pub frame_ms: u32,
    /// Frames buffered before playback starts, with no jitter.
    pub min_delay_frames: usize,
    /// Upper bound on the adaptive delay.
    pub max_delay_frames: usize,
    /// Consecutive frames to conceal with nothing buffered before giving up and rebuffering.
    pub max_concealed: usize,
}

impl Default for JitterConfig {
    fn default() -> Self {
        Self {
            frame_ms: FRAME_MS,
            min_delay_frames: 2,
            max_delay_frames: 12,
            max_concealed: 5,
        }
    }
}

impl JitterConfig {
    #[must_use]
    pub fn frame_samples(&self) -> usize {
        (SAMPLE_RATE / 1000 * self.frame_ms) as usize
    }
}

/// One frame period's worth of output.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Slot {
    /// The frame's packet.
    Packet(Bytes),
    /// The frame is missing. `next` is the following packet if it's already here, which may
    /// carry FEC data for the missing one.
    Lost { next: Option<Bytes> },
    /// Not playing.
    Idle,
}

#[derive(Debug, Clone, Copy, Default, PartialEq, Eq)]
pub struct JitterStats {
    pub received: u64,
    pub played: u64,
    /// Missing frames where the next packet was available (FEC possible).
    pub recovered: u64,
    /// Missing frames with nothing to recover from.
    pub concealed: u64,
    /// Packets that arrived after their slot was played.
    pub late: u64,
    pub duplicates: u64,
    /// Packets dropped to cut latency when the buffer grew too deep.
    pub overflow: u64,
    /// Current playout delay target, in frames.
    pub target_frames: usize,
}

#[derive(Debug)]
struct Entry {
    payload: Bytes,
    eos: bool,
}

#[derive(Debug)]
pub struct JitterBuffer {
    config: JitterConfig,
    packets: BTreeMap<u64, Entry>,
    /// Highest extended sequence number seen, for unwrapping `u16` sequence numbers.
    highest: Option<u64>,
    /// Next extended sequence number to play.
    next: Option<u64>,
    playing: bool,
    buffering_ticks: usize,
    missing_run: usize,
    last_transit: Option<f64>,
    jitter_ms: f64,
    target: usize,
    stats: JitterStats,
}

impl JitterBuffer {
    #[must_use]
    pub fn new(config: JitterConfig) -> Self {
        Self {
            target: config.min_delay_frames,
            config,
            packets: BTreeMap::new(),
            highest: None,
            next: None,
            playing: false,
            buffering_ticks: 0,
            missing_run: 0,
            last_transit: None,
            jitter_ms: 0.0,
            stats: JitterStats::default(),
        }
    }

    #[must_use]
    pub fn is_playing(&self) -> bool {
        self.playing
    }

    #[must_use]
    pub fn stats(&self) -> JitterStats {
        JitterStats {
            target_frames: self.target,
            ..self.stats
        }
    }

    fn unwrap_seq(&mut self, seq: u16) -> u64 {
        let ext = match self.highest {
            // Start high so sequence numbers just below the first one still fit.
            None => (1u64 << 32) | u64::from(seq),
            Some(h) => {
                let diff = i64::from(seq.wrapping_sub(h as u16) as i16);
                h.checked_add_signed(diff).unwrap_or(0)
            }
        };
        self.highest = Some(self.highest.map_or(ext, |h| h.max(ext)));
        ext
    }

    /// Adds a received packet. `now_ms` is a monotonic clock in milliseconds.
    pub fn push(&mut self, seq: u16, end_of_spurt: bool, payload: Bytes, now_ms: u64) {
        let ext = self.unwrap_seq(seq);
        if self.next.is_some_and(|next| ext < next) {
            self.stats.late += 1;
            return;
        }
        if self.packets.contains_key(&ext) {
            self.stats.duplicates += 1;
            return;
        }
        self.stats.received += 1;

        // RFC 3550-style interarrival jitter.
        let transit = now_ms as f64 - ext as f64 * f64::from(self.config.frame_ms);
        if let Some(last) = self.last_transit {
            let d = (transit - last).abs();
            self.jitter_ms += (d - self.jitter_ms) / 16.0;
        }
        self.last_transit = Some(transit);
        if end_of_spurt {
            // The next spurt starts after an arbitrary pause; don't count it as jitter.
            self.last_transit = None;
        }
        let jitter_frames =
            (2.0 * self.jitter_ms / f64::from(self.config.frame_ms)).ceil() as usize;
        self.target =
            (self.config.min_delay_frames + jitter_frames).min(self.config.max_delay_frames);

        self.packets.insert(
            ext,
            Entry {
                payload,
                eos: end_of_spurt,
            },
        );

        // Too deep (e.g. after a network stall delivered a burst): skip ahead to cut latency.
        let limit = self.target * 2 + 2;
        if self.playing {
            while self.packets.len() > limit {
                if let Some((k, _)) = self.packets.pop_first() {
                    self.stats.overflow += 1;
                    self.next = Some(k + 1);
                }
            }
        }
    }

    /// The slot for the next frame period.
    pub fn pop(&mut self) -> Slot {
        if !self.playing {
            let Some((&first, _)) = self.packets.first_key_value() else {
                self.buffering_ticks = 0;
                return Slot::Idle;
            };
            self.buffering_ticks += 1;
            let has_eos = self.packets.values().any(|e| e.eos);
            if self.packets.len() < self.target && !has_eos && self.buffering_ticks < self.target {
                return Slot::Idle;
            }
            self.playing = true;
            self.buffering_ticks = 0;
            self.missing_run = 0;
            self.next = Some(self.next.map_or(first, |n| n.max(first)));
        }

        let n = self.next.expect("set when playing");
        if let Some(entry) = self.packets.remove(&n) {
            self.next = Some(n + 1);
            self.missing_run = 0;
            self.stats.played += 1;
            if entry.eos {
                self.playing = false;
            }
            return Slot::Packet(entry.payload);
        }

        match self.packets.first_key_value() {
            None => {
                if self.missing_run >= self.config.max_concealed {
                    self.playing = false;
                    // Whatever arrives next comes after a pause, not jitter.
                    self.last_transit = None;
                    return Slot::Idle;
                }
                self.missing_run += 1;
                self.next = Some(n + 1);
                self.stats.concealed += 1;
                Slot::Lost { next: None }
            }
            Some((&first, _)) => {
                self.missing_run += 1;
                // A long gap: conceal once and jump to what we have.
                if first - n > self.config.max_concealed as u64 {
                    self.next = Some(first);
                    self.stats.concealed += 1;
                    return Slot::Lost { next: None };
                }
                self.next = Some(n + 1);
                let next = self.packets.get(&(n + 1)).map(|e| e.payload.clone());
                if next.is_some() {
                    self.stats.recovered += 1;
                } else {
                    self.stats.concealed += 1;
                }
                Slot::Lost { next }
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn p(n: u8) -> Bytes {
        Bytes::from(vec![n])
    }

    fn jb() -> JitterBuffer {
        JitterBuffer::new(JitterConfig::default())
    }

    fn payload(slot: &Slot) -> Option<u8> {
        match slot {
            Slot::Packet(b) => Some(b[0]),
            _ => None,
        }
    }

    #[test]
    fn buffers_then_plays_in_order() {
        let mut j = jb();
        j.push(0, false, p(0), 0);
        assert_eq!(j.pop(), Slot::Idle);
        j.push(2, false, p(2), 40);
        j.push(1, false, p(1), 41);
        assert_eq!(payload(&j.pop()), Some(0));
        assert_eq!(payload(&j.pop()), Some(1));
        assert_eq!(payload(&j.pop()), Some(2));
    }

    #[test]
    fn short_spurt_with_eos_plays_immediately() {
        let mut j = jb();
        j.push(0, true, p(0), 0);
        assert_eq!(payload(&j.pop()), Some(0));
        assert_eq!(j.pop(), Slot::Idle);
        assert!(!j.is_playing());
    }

    #[test]
    fn lone_packet_without_eos_eventually_plays() {
        let mut j = jb();
        j.push(0, false, p(0), 0);
        assert_eq!(j.pop(), Slot::Idle);
        assert_eq!(payload(&j.pop()), Some(0));
    }

    #[test]
    fn loss_offers_next_packet_for_fec() {
        let mut j = jb();
        for s in [0u16, 1, 3, 4] {
            j.push(s, false, p(s as u8), u64::from(s) * 20);
        }
        assert_eq!(payload(&j.pop()), Some(0));
        assert_eq!(payload(&j.pop()), Some(1));
        assert_eq!(j.pop(), Slot::Lost { next: Some(p(3)) });
        assert_eq!(payload(&j.pop()), Some(3));
        assert_eq!(j.stats().recovered, 1);
    }

    #[test]
    fn late_and_duplicate_packets_are_dropped() {
        let mut j = jb();
        j.push(0, false, p(0), 0);
        j.push(1, false, p(1), 20);
        j.push(1, false, p(1), 21);
        j.pop();
        j.push(0, false, p(0), 60);
        assert_eq!(j.stats().late, 1);
        assert_eq!(j.stats().duplicates, 1);
    }

    #[test]
    fn sequence_wraps() {
        let mut j = jb();
        let seqs = [65534u16, 65535, 0, 1];
        for (i, s) in seqs.iter().enumerate() {
            j.push(*s, false, p(i as u8), i as u64 * 20);
        }
        let out: Vec<_> = (0..4).map(|_| payload(&j.pop())).collect();
        assert_eq!(out, vec![Some(0), Some(1), Some(2), Some(3)]);
    }

    #[test]
    fn underrun_conceals_then_stops() {
        let mut j = jb();
        j.push(0, false, p(0), 0);
        j.push(1, false, p(1), 20);
        j.pop();
        j.pop();
        for _ in 0..5 {
            assert_eq!(j.pop(), Slot::Lost { next: None });
        }
        assert_eq!(j.pop(), Slot::Idle);
        assert!(!j.is_playing());
        // Resumes with the next packets.
        j.push(7, false, p(7), 500);
        j.push(8, false, p(8), 520);
        assert_eq!(payload(&j.pop()), Some(7));
    }

    #[test]
    fn jitter_raises_target_delay() {
        let mut j = jb();
        for s in 0..100u16 {
            // Alternate early/late by 30 ms.
            let t = u64::from(s) * 20 + if s % 2 == 0 { 0 } else { 30 };
            j.push(s, false, p(0), t);
            j.pop();
        }
        assert!(j.stats().target_frames > 2, "{:?}", j.stats());
    }

    #[test]
    fn overflow_skips_ahead() {
        let mut j = jb();
        j.push(0, false, p(0), 0);
        j.push(1, false, p(1), 20);
        j.pop();
        // A stall delivers a burst.
        for s in 2..40u16 {
            j.push(s, false, p(s as u8), 800);
        }
        assert!(j.stats().overflow > 0);
        assert!(j.packets.len() <= j.target * 2 + 2);
    }

    #[test]
    fn long_gap_jumps() {
        let mut j = jb();
        j.push(0, false, p(0), 0);
        j.push(1, false, p(1), 20);
        j.pop();
        j.pop();
        j.push(50, false, p(50), 1000);
        assert_eq!(j.pop(), Slot::Lost { next: None });
        assert_eq!(payload(&j.pop()), Some(50));
    }
}
