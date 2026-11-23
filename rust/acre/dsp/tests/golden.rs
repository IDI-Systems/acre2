//! Compares the Rust effects with the original C++ (ACRE2Core) on the same input.
//! The golden files come from `reference/generate.sh`.

use acre2_dsp::{
    effects::{BabbelEffect, RadioEffect, RadioParams},
    noise::Rng,
};

fn read(name: &str) -> Vec<f32> {
    let path = format!("{}/tests/golden/{name}.i16", env!("CARGO_MANIFEST_DIR"));
    let bytes = std::fs::read(&path).unwrap_or_else(|e| panic!("{path}: {e}"));
    bytes
        .as_chunks::<2>()
        .0
        .iter()
        .map(|b| f32::from(i16::from_le_bytes([b[0], b[1]])))
        .collect()
}

/// The input as the C++ saw it (i16 / 32768).
fn input() -> Vec<f32> {
    read("input").into_iter().map(|s| s / 32768.0).collect()
}

/// The C++ output (written as floor(x * 32767)).
fn expected(name: &str) -> Vec<f32> {
    read(name).into_iter().map(|s| s / 32767.0).collect()
}

/// Signal-to-error ratio in dB.
fn snr(expected: &[f32], actual: &[f32]) -> f64 {
    assert_eq!(expected.len(), actual.len());
    let signal: f64 = expected.iter().map(|s| f64::from(*s).powi(2)).sum();
    let error: f64 = expected
        .iter()
        .zip(actual)
        .map(|(e, a)| f64::from(e - a).powi(2))
        .sum();
    10.0 * (signal / error.max(1e-30)).log10()
}

fn check(name: &str, actual: &[f32], min_snr: f64) {
    let exp = expected(name);
    let snr = snr(&exp, actual);
    let max_err = exp
        .iter()
        .zip(actual)
        .map(|(e, a)| (e - a).abs())
        .fold(0.0f32, f32::max);
    println!("{name}: SNR {snr:.1} dB, max error {max_err:.5}");
    assert!(
        snr >= min_snr,
        "{name}: SNR {snr:.1} dB < {min_snr} dB (max error {max_err})"
    );
}

fn radio(quality: f32, loudspeaker: bool) -> Vec<f32> {
    let mut x = input();
    RadioEffect::new(Rng::new(1)).process(
        &mut x,
        RadioParams {
            signal_quality: quality,
            noise: false,
            loudspeaker,
        },
    );
    x
}

#[test]
fn radio_full_signal_matches_cpp() {
    check("radio_q100", &radio(1.0, false), 60.0);
}

#[test]
fn radio_half_signal_loudspeaker_matches_cpp() {
    check("radio_q050_loudspeaker", &radio(0.5, true), 60.0);
}

#[test]
fn radio_weak_signal_matches_cpp() {
    check("radio_q015", &radio(0.15, false), 60.0);
}

#[test]
fn babbel_matches_cpp() {
    let mut x = input();
    BabbelEffect::default().process(&mut x);
    check("babbel", &x, 40.0);
}
