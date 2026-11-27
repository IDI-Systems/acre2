//! Audio pipeline.
//!
//! The pieces are device-free and testable on their own:
//!
//! - [`Transmitter`]: microphone frames → transmission start/stop + Opus packets, with voice
//!   activation and push-to-talk.
//! - [`Mixer`]: server messages + voice datagrams → one stereo frame per period, through a
//!   [`Renderer`] that decides how each stream sounds.
//! - [`Resampler`]: device rate ↔ 48 kHz.
//!
//! With the `devices` feature, [`VoiceSession`] wires them to real audio devices.

mod activation;
mod denoise;
#[cfg(feature = "devices")]
mod device;
mod loopback;
mod mixer;
#[cfg(feature = "devices")]
mod monitor;
mod resample;
#[cfg(feature = "devices")]
mod session;
mod transmit;

pub use activation::{
    ActivationConfig, ActivationMode, SPEECH_FRAMES, SPEECH_OPEN, VoiceGate, level_db,
};
pub use denoise::{Denoiser, NoiseConfig};
#[cfg(feature = "devices")]
pub use device::{AudioDevice, DeviceCallback, DeviceEvent, DeviceList, list_devices};
pub use loopback::{Loopback, Looped};
pub use mixer::{Mixer, PassthroughRenderer, ReceiveTotals, Renderer, StereoFrame, StreamInfo};
#[cfg(feature = "devices")]
pub use monitor::MicMonitor;
pub use resample::{Resampler, downmix};
#[cfg(feature = "devices")]
pub use session::{SessionConfig, SessionEvent, VoiceSession};
pub use transmit::{DIRECT_TX, Outgoing, Transmitter, TxAction};

/// Sends a transmitter's output on a connection.
pub fn apply_actions(client: &crate::Client, actions: Vec<TxAction>) {
    for a in actions {
        let result = match a {
            TxAction::Start {
                tx,
                targets,
                metadata,
            } => client.start_transmission(tx, targets, metadata),
            TxAction::Voice {
                tx,
                seq,
                flags,
                payload,
            } => client.send_voice(tx, seq, flags, payload),
            TxAction::Stop { tx } => client.stop_transmission(tx),
        };
        if let Err(e) = result {
            tracing::debug!(error = %e, "could not send");
        }
    }
}
