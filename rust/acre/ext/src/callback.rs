//! Callbacks into SQF (`ExtensionCallback` with name `"acre_voice"`).
//!
//! arma-rs hands out a [`Context`] per call; the `init` command parks one here so background
//! threads can raise events.

use std::sync::Mutex;

use arma_rs::{Context, IntoArma};

static CONTEXT: Mutex<Option<Context>> = Mutex::new(None);

pub const NAME: &str = "acre_voice";

pub fn set_context(ctx: Context) {
    *CONTEXT.lock().expect("callback lock") = Some(ctx);
}

/// Raises `ExtensionCallback` with [`NAME`], `func` and `data`, which is always an array so SQF
/// can `parseSimpleArray` it. Dropped if `init` hasn't run.
pub fn emit(func: &str, data: impl IntoArma) {
    if let Some(ctx) = CONTEXT.lock().expect("callback lock").as_ref() {
        if ctx.callback_data(NAME, func, data).is_err() {
            tracing::warn!(%func, "callback channel closed");
        }
    } else {
        tracing::debug!(%func, "callback before init, dropped");
    }
}
