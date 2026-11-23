use std::{net::SocketAddr, path::PathBuf, time::Duration};

use serde::Deserialize;

use crate::world::Limits;

/// Server configuration, usually read from a TOML file.
///
/// ```toml
/// bind = "0.0.0.0:9987"
/// public_address = "voice.example.com:9987"
/// authority_secret = "change me"
/// data_dir = "data"
/// ```
#[derive(Debug, Clone, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Config {
    /// UDP address to listen on.
    #[serde(default = "default_bind")]
    pub bind: SocketAddr,
    /// Address clients should connect to, passed to the authority. Defaults to letting the
    /// game server use the address it connected to.
    #[serde(default)]
    pub public_address: Option<String>,
    /// Shared secret the authority (game server) must present.
    pub authority_secret: String,
    /// Where the certificate is stored.
    #[serde(default = "default_data_dir")]
    pub data_dir: PathBuf,
    /// How long an issued join token stays valid.
    #[serde(default = "default_token_ttl", with = "secs")]
    pub token_ttl: Duration,
    /// How often transmissions are re-routed as people move.
    #[serde(default = "default_reresolve", with = "millis")]
    pub reresolve_interval: Duration,
    #[serde(default = "default_max_spatial_range")]
    pub max_spatial_range: f32,
    #[serde(default = "default_max_extra_positions")]
    pub max_extra_positions: usize,
    #[serde(default = "default_max_peers")]
    pub max_peers: usize,
}

fn default_bind() -> SocketAddr {
    SocketAddr::from(([0, 0, 0, 0], 9987))
}
fn default_data_dir() -> PathBuf {
    PathBuf::from("data")
}
fn default_token_ttl() -> Duration {
    Duration::from_secs(120)
}
fn default_reresolve() -> Duration {
    Duration::from_millis(200)
}
fn default_max_spatial_range() -> f32 {
    Limits::default().max_spatial_range
}
fn default_max_extra_positions() -> usize {
    Limits::default().max_extra_positions
}
fn default_max_peers() -> usize {
    512
}

mod secs {
    use std::time::Duration;

    use serde::{Deserialize, Deserializer};

    pub fn deserialize<'de, D: Deserializer<'de>>(d: D) -> Result<Duration, D::Error> {
        u64::deserialize(d).map(Duration::from_secs)
    }
}

mod millis {
    use std::time::Duration;

    use serde::{Deserialize, Deserializer};

    pub fn deserialize<'de, D: Deserializer<'de>>(d: D) -> Result<Duration, D::Error> {
        u64::deserialize(d).map(Duration::from_millis)
    }
}

impl Config {
    /// A config with defaults and the given secret, mainly for tests and embedding.
    #[must_use]
    pub fn new(authority_secret: impl Into<String>) -> Self {
        Self {
            bind: default_bind(),
            public_address: None,
            authority_secret: authority_secret.into(),
            data_dir: default_data_dir(),
            token_ttl: default_token_ttl(),
            reresolve_interval: default_reresolve(),
            max_spatial_range: default_max_spatial_range(),
            max_extra_positions: default_max_extra_positions(),
            max_peers: default_max_peers(),
        }
    }

    pub fn validate(&self) -> anyhow::Result<()> {
        anyhow::ensure!(
            self.authority_secret.len() >= 8,
            "authority_secret must be at least 8 characters"
        );
        anyhow::ensure!(
            self.max_spatial_range.is_finite() && self.max_spatial_range > 0.0,
            "max_spatial_range must be positive"
        );
        anyhow::ensure!(
            !self.reresolve_interval.is_zero(),
            "reresolve_interval must be positive"
        );
        Ok(())
    }

    #[must_use]
    pub fn limits(&self) -> Limits {
        Limits {
            max_spatial_range: self.max_spatial_range,
            max_extra_positions: self.max_extra_positions,
            ..Limits::default()
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parses_minimal_and_full() {
        let c: Config = toml::from_str(r#"authority_secret = "12345678""#).unwrap();
        c.validate().unwrap();
        assert_eq!(c.bind.port(), 9987);

        let c: Config = toml::from_str(
            r#"
            bind = "127.0.0.1:1234"
            public_address = "voice.example.com:1234"
            authority_secret = "12345678"
            token_ttl = 30
            reresolve_interval = 100
            max_spatial_range = 500.0
            "#,
        )
        .unwrap();
        assert_eq!(c.token_ttl, Duration::from_secs(30));
        assert_eq!(c.reresolve_interval, Duration::from_millis(100));
        assert_eq!(c.limits().max_spatial_range, 500.0);
    }

    #[test]
    fn rejects_short_secret_and_unknown_keys() {
        let c: Config = toml::from_str(r#"authority_secret = "short""#).unwrap();
        assert!(c.validate().is_err());
        assert!(toml::from_str::<Config>("authority_secret = \"12345678\"\nbogus = 1").is_err());
    }
}
