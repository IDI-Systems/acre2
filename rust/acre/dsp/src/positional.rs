//! Positional audio: distance attenuation and stereo placement of a mono source.
//!
//! ACRE2Core used Windows' X3DAudio for this (`CFilterPosition`). This reimplements the parts
//! ACRE relied on, using X3DAudio's documented behaviour:
//!
//! - **Distance curves**: the default inverse-distance curve (`1` up to `scaler`, then
//!   `scaler / d`), or ACRE's 151-point table, evaluated at `d / scaler`.
//! - **Emitter cone**: 1.2× in front of the speaker (within 22.5°), 1.0× beyond 45°, linear in
//!   between.
//! - **Panning**: equal-power stereo pan from the source's azimuth around the listener, spreading
//!   to centre inside the 2 m inner radius.
//! - ACRE's own **kill fade** for some curve models: full volume to 75 m, silent at 225 m.
//!
//! Vectors use X3DAudio's left-handed convention: `x` right/east, `y` up, `z` forward/north.
//! ACRE's Arma `[x, y, z]` (z up) maps to `[x, z, y]` here; see [`from_arma`].

use std::f32::consts::{FRAC_PI_2, FRAC_PI_4, PI};

pub type Vec3 = [f32; 3];

/// Converts an Arma `[x, y, z]` (z up) position or direction to this module's `[x, up, forward]`.
#[must_use]
pub fn from_arma(v: Vec3) -> Vec3 {
    [v[0], v[2], v[1]]
}

fn sub(a: Vec3, b: Vec3) -> Vec3 {
    [a[0] - b[0], a[1] - b[1], a[2] - b[2]]
}
fn dot(a: Vec3, b: Vec3) -> f32 {
    a[0] * b[0] + a[1] * b[1] + a[2] * b[2]
}
fn cross(a: Vec3, b: Vec3) -> Vec3 {
    [
        a[1] * b[2] - a[2] * b[1],
        a[2] * b[0] - a[0] * b[2],
        a[0] * b[1] - a[1] * b[0],
    ]
}
fn length(a: Vec3) -> f32 {
    dot(a, a).sqrt()
}
fn normalize(a: Vec3) -> Option<Vec3> {
    let l = length(a);
    (l > 1e-6).then(|| [a[0] / l, a[1] / l, a[2] / l])
}

/// The "top" vector ACRE derived for a front vector (`CFilterPosition::getUpVector`).
#[must_use]
pub fn up_vector(front: Vec3) -> Vec3 {
    let elev = front[1].clamp(-1.0, 1.0).asin() + FRAC_PI_2;
    let dir = front[0].atan2(front[2]);
    [elev.cos() * dir.sin(), elev.sin(), elev.cos() * dir.cos()]
}

/// Which distance model direct speech uses (`ACRE_CURVE_MODEL_*`). Other speaking types
/// always use the table curve.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Default)]
pub enum CurveModel {
    /// Inverse-distance curve, no scaling.
    Original,
    /// Like `Original`, plus the kill fade.
    Amplitude,
    /// Inverse-distance curve scaled by the speaker's curve scale, plus the kill fade.
    SelectableA,
    /// ACRE's table curve scaled by the speaker's curve scale. ACRE's default.
    #[default]
    SelectableB,
}

impl CurveModel {
    /// From `ACRE_CURVE_MODEL_*` (0–3).
    #[must_use]
    pub fn from_index(i: i64) -> Self {
        match i {
            0 => Self::Original,
            1 => Self::Amplitude,
            2 => Self::SelectableA,
            _ => Self::SelectableB,
        }
    }
}

/// ACRE's distance table: 1.0 to 8 m, then roughly inverse-square to 150 m, then silent.
/// Index = metres (after scaling).
const TABLE: [f32; 151] = [
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.857_339, 0.694_445, 0.573_921, 0.482_253,
    0.410_914, 0.354_308, 0.308_642, 0.271_267, 0.240_292, 0.214_335, 0.192_367, 0.173_611,
    0.157_47, 0.143_48, 0.131_275, 0.120_563, 0.111_111, 0.102_728, 0.095_26, 0.088_577, 0.082_574,
    0.077_16, 0.072_263, 0.067_817, 0.063_769, 0.060_073, 0.056_689, 0.053_584, 0.050_726,
    0.048_092, 0.045_657, 0.043_403, 0.041_311, 0.039_368, 0.037_558, 0.035_87, 0.034_294,
    0.032_819, 0.031_437, 0.030_141, 0.028_923, 0.027_778, 0.026_699, 0.025_682, 0.024_722,
    0.023_815, 0.022_957, 0.022_144, 0.021_374, 0.020_643, 0.019_95, 0.019_29, 0.018_663,
    0.018_066, 0.017_497, 0.016_954, 0.016_437, 0.015_942, 0.015_47, 0.015_018, 0.014_586,
    0.014_172, 0.013_776, 0.013_396, 0.013_031, 0.012_682, 0.012_346, 0.012_023, 0.011_713,
    0.011_414, 0.011_127, 0.010_851, 0.010_584, 0.010_328, 0.010_08, 0.009_842, 0.009_612,
    0.009_389, 0.009_175, 0.008_968, 0.008_767, 0.008_573, 0.008_386, 0.008_205, 0.008_029,
    0.007_859, 0.007_695, 0.007_535, 0.007_381, 0.007_231, 0.007_085, 0.006_944, 0.006_808,
    0.006_675, 0.006_546, 0.006_421, 0.006_299, 0.006_181, 0.006_066, 0.005_954, 0.005_845,
    0.005_739, 0.005_636, 0.005_536, 0.005_439, 0.005_344, 0.005_251, 0.005_161, 0.005_073,
    0.004_987, 0.004_904, 0.004_823, 0.004_743, 0.004_666, 0.004_59, 0.004_516, 0.004_444,
    0.004_374, 0.004_306, 0.004_239, 0.004_173, 0.004_109, 0.004_047, 0.003_986, 0.003_926,
    0.003_867, 0.003_81, 0.003_755, 0.003_7, 0.003_647, 0.003_594, 0.003_543, 0.003_493, 0.003_444,
    0.003_396, 0.003_349, 0.003_303, 0.003_258, 0.003_214, 0.003_17, 0.003_128, 0.0,
];

fn table_curve(d: f32) -> f32 {
    if d <= 0.0 {
        return TABLE[0];
    }
    let i = d.floor() as usize;
    if i >= TABLE.len() - 1 {
        return TABLE[TABLE.len() - 1];
    }
    let t = d - i as f32;
    TABLE[i] + (TABLE[i + 1] - TABLE[i]) * t
}

fn inverse_curve(d: f32) -> f32 {
    if d <= 1.0 { 1.0 } else { 1.0 / d }
}

/// The emitter cone: louder in front of the speaker's face.
fn cone(front: Vec3, to_listener: Vec3) -> f32 {
    const INNER: f32 = FRAC_PI_4 / 2.0; // half of the π/4 inner angle
    const OUTER: f32 = FRAC_PI_2 / 2.0;
    const INNER_VOLUME: f32 = 1.2;
    const OUTER_VOLUME: f32 = 1.0;
    let (Some(f), Some(t)) = (normalize(front), normalize(to_listener)) else {
        return OUTER_VOLUME;
    };
    let angle = dot(f, t).clamp(-1.0, 1.0).acos();
    if angle <= INNER {
        INNER_VOLUME
    } else if angle >= OUTER {
        OUTER_VOLUME
    } else {
        INNER_VOLUME + (OUTER_VOLUME - INNER_VOLUME) * (angle - INNER) / (OUTER - INNER)
    }
}

/// How a distance turns into volume.
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Attenuation {
    /// Use ACRE's table instead of the inverse-distance curve.
    pub table: bool,
    /// Distances are divided by this before the curve.
    pub scaler: f32,
    /// Apply the 75–225 m kill fade.
    pub kill_fade: bool,
}

impl Attenuation {
    /// For direct speech under a curve model, with the speaker's selectable curve scale.
    #[must_use]
    pub fn direct(model: CurveModel, curve_scale: f32) -> Self {
        match model {
            CurveModel::Original => Self {
                table: false,
                scaler: 1.0,
                kill_fade: false,
            },
            CurveModel::Amplitude => Self {
                table: false,
                scaler: 1.0,
                kill_fade: true,
            },
            CurveModel::SelectableA => Self {
                table: false,
                scaler: curve_scale,
                kill_fade: true,
            },
            CurveModel::SelectableB => Self {
                table: true,
                scaler: curve_scale,
                kill_fade: false,
            },
        }
    }

    /// For everything other than direct speech (radios, intercom), and for local sounds.
    /// The kill fade still follows the curve model, as in ACRE2Core.
    #[must_use]
    pub fn other(model: CurveModel) -> Self {
        Self {
            table: true,
            scaler: 1.0,
            kill_fade: matches!(model, CurveModel::Amplitude | CurveModel::SelectableA),
        }
    }

    #[must_use]
    pub fn gain(&self, distance: f32) -> f32 {
        let d = distance / self.scaler.max(1e-3);
        let curve = if self.table {
            table_curve(d)
        } else {
            inverse_curve(d)
        };
        let kill = if self.kill_fade && distance >= 75.0 {
            (1.0 - (distance - 75.0) / 150.0).clamp(0.0, 1.0)
        } else {
            1.0
        };
        curve * kill
    }
}

/// Where the listener is.
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Listener {
    pub position: Vec3,
    pub front: Vec3,
}

impl Listener {
    /// The fixed listener used for headset (non-world) sources: at the origin, facing +y, so a
    /// source at `[-2, 0, 0]` is in the left ear and `[2, 0, 0]` in the right.
    pub const HEADSET: Self = Self {
        position: [0.0; 3],
        front: [0.0, 1.0, 0.0],
    };
}

/// A sound source.
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Emitter {
    pub position: Vec3,
    pub front: Vec3,
}

/// Left/right gains for a mono source.
#[must_use]
pub fn stereo_gains(listener: Listener, emitter: Emitter, attenuation: Attenuation) -> (f32, f32) {
    const INNER_RADIUS: f32 = 2.0;

    let rel = sub(emitter.position, listener.position);
    let distance = length(rel);
    let volume =
        attenuation.gain(distance) * cone(emitter.front, sub(listener.position, emitter.position));

    // Azimuth in the listener's frame.
    let front = normalize(listener.front).unwrap_or([0.0, 0.0, 1.0]);
    let top = up_vector(front);
    let right = cross(top, front);
    let x = dot(rel, right);
    let z = dot(rel, front);
    let horizontal = (x * x + z * z).sqrt();
    let mut pan = if horizontal > 1e-6 {
        x / horizontal
    } else {
        0.0
    };
    // Inside the inner radius the source spreads towards both ears.
    if distance < INNER_RADIUS {
        pan *= distance / INNER_RADIUS;
    }
    let angle = (pan + 1.0) * PI / 4.0; // 0 = hard left, π/2 = hard right
    (volume * angle.cos(), volume * angle.sin())
}

#[cfg(test)]
mod tests {
    use super::*;

    fn arma_listener(pos: Vec3, dir: Vec3) -> Listener {
        Listener {
            position: from_arma(pos),
            front: from_arma(dir),
        }
    }

    fn arma_emitter(pos: Vec3, dir: Vec3) -> Emitter {
        Emitter {
            position: from_arma(pos),
            front: from_arma(dir),
        }
    }

    const NORTH: Vec3 = [0.0, 1.0, 0.0];
    const SOUTH: Vec3 = [0.0, -1.0, 0.0];

    #[test]
    fn table_and_inverse_curves() {
        assert_eq!(table_curve(5.0), 1.0);
        assert!((table_curve(9.5) - f32::midpoint(0.857_339, 0.694_445)).abs() < 1e-5);
        assert_eq!(table_curve(200.0), 0.0);
        assert_eq!(inverse_curve(0.5), 1.0);
        assert_eq!(inverse_curve(4.0), 0.25);
    }

    #[test]
    fn selectable_b_scales_distance() {
        let a = Attenuation::direct(CurveModel::SelectableB, 0.5);
        // 5 m at scale 0.5 reads the table at 10 m.
        assert!((a.gain(5.0) - 0.694_445).abs() < 1e-5);
    }

    #[test]
    fn kill_fade() {
        let a = Attenuation::direct(CurveModel::Amplitude, 1.0);
        assert!((a.gain(150.0) - (1.0 / 150.0) * 0.5).abs() < 1e-6);
        assert_eq!(a.gain(300.0), 0.0);
    }

    #[test]
    fn source_to_the_east_of_a_north_facing_listener_is_on_the_right() {
        let l = arma_listener([0.0; 3], NORTH);
        let e = arma_emitter([5.0, 0.0, 0.0], SOUTH);
        let (left, right) = stereo_gains(l, e, Attenuation::direct(CurveModel::Original, 1.0));
        assert!(right > 0.15 && left < 0.01, "{left} {right}");
    }

    #[test]
    fn source_in_front_is_centred_and_louder_when_facing_us() {
        let l = arma_listener([0.0; 3], NORTH);
        let facing = arma_emitter([0.0, 4.0, 0.0], SOUTH);
        let away = arma_emitter([0.0, 4.0, 0.0], NORTH);
        let att = Attenuation::direct(CurveModel::Original, 1.0);
        let (l1, r1) = stereo_gains(l, facing, att);
        let (l2, _) = stereo_gains(l, away, att);
        assert!((l1 - r1).abs() < 1e-5);
        assert!((l1 / l2 - 1.2).abs() < 1e-4, "{l1} {l2}");
    }

    #[test]
    fn turning_round_swaps_ears() {
        let e = arma_emitter([5.0, 0.0, 0.0], SOUTH);
        let att = Attenuation::other(CurveModel::SelectableB);
        let (l1, r1) = stereo_gains(arma_listener([0.0; 3], NORTH), e, att);
        let (l2, r2) = stereo_gains(arma_listener([0.0; 3], SOUTH), e, att);
        assert!((l1 - r2).abs() < 1e-5 && (r1 - l2).abs() < 1e-5);
    }

    #[test]
    fn headset_ears() {
        let att = Attenuation::other(CurveModel::SelectableB);
        let front = [0.0, 0.0, 1.0];
        let (l, r) = stereo_gains(
            Listener::HEADSET,
            Emitter {
                position: [-2.0, 0.0, 0.0],
                front,
            },
            att,
        );
        assert!(l > 0.99 && r < 0.01, "left ear {l} {r}");
        let (l, r) = stereo_gains(
            Listener::HEADSET,
            Emitter {
                position: [2.0, 0.0, 0.0],
                front,
            },
            att,
        );
        assert!(r > 0.99 && l < 0.01, "right ear {l} {r}");
        let (l, r) = stereo_gains(
            Listener::HEADSET,
            Emitter {
                position: [0.0; 3],
                front,
            },
            att,
        );
        assert!(
            (l - r).abs() < 1e-6 && (l - std::f32::consts::FRAC_1_SQRT_2).abs() < 1e-5,
            "centre {l} {r}"
        );
    }
}
