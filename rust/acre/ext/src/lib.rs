//! ACRE's Arma 3 extension, `acre_x64.dll` / `acre_x64.so`.
//!
//! Called as `"acre" callExtension ["group:command", [args…]]` with typed arguments, and answers
//! asynchronous work through `ExtensionCallback` (name `"acre"`). Call `init` first.
//!
//! - Player side ([`client`], with the `client` feature): voice connection, transmissions,
//!   the parameters for how others sound, local sounds, audio devices.
//! - Server side ([`authority`]): the Arma server feeding the voice server and issuing tokens.

// Command handlers take owned arguments and mirror the SQF argument lists.
#![allow(clippy::needless_pass_by_value, clippy::too_many_arguments)]

pub mod authority;
mod callback;
#[cfg(feature = "client")]
pub mod client;
pub mod meta;
#[cfg(feature = "client")]
pub mod render;
mod runtime;
#[cfg(feature = "client")]
mod sounds;
#[cfg(feature = "client")]
pub mod speakers;
#[cfg(all(test, feature = "client", target_os = "linux"))]
mod tests_e2e;

use arma_rs::{Context, Extension, arma};

#[arma]
fn init() -> Extension {
    let ext = Extension::build()
        .version(env!("CARGO_PKG_VERSION").to_string())
        .command("version", version)
        .command("init", init_callbacks)
        .group("authority", authority::group());
    #[cfg(feature = "client")]
    let ext = client::groups()
        .into_iter()
        .fold(ext, |ext, (name, group)| ext.group(name, group));
    ext.finish()
}

fn version() -> &'static str {
    env!("CARGO_PKG_VERSION")
}

/// `["init", []]`: enables callbacks and logging. Returns the version.
fn init_callbacks(ctx: Context) -> &'static str {
    runtime::init_logging();
    callback::set_context(ctx);
    tracing::info!(
        version = env!("CARGO_PKG_VERSION"),
        "ACRE extension initialised"
    );
    version()
}

#[cfg(test)]
mod tests {
    #[test]
    fn version() {
        let ext = super::init().testing();
        let (out, code) = ext.call("version", None);
        assert_eq!(code, 0);
        assert_eq!(out, env!("CARGO_PKG_VERSION"));
    }
}
