//! ACRE's audio effects, ported from the TeamSpeak plugin (ACRE2Core).
//!
//! - [`effects`]: radio, babel and volume effects on mono `f32` audio.
//! - [`positional`]: distance curves and stereo placement (replacing X3DAudio).
//! - [`biquad`], [`noise`]: the building blocks.
//!
//! Everything is 48 kHz.

pub mod biquad;
pub mod effects;
pub mod noise;
pub mod positional;

pub const SAMPLE_RATE: u32 = 48_000;
