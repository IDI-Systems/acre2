//! ACRE Arma 3 extension. Built as `acre_x64.dll` / `acre_x64.so`. (Phase 4, mostly not yet implemented.)

use arma_rs::{Extension, arma};

#[arma]
fn init() -> Extension {
    Extension::build()
        .version(env!("CARGO_PKG_VERSION").to_string())
        .command("version", version)
        .finish()
}

fn version() -> &'static str {
    env!("CARGO_PKG_VERSION")
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
