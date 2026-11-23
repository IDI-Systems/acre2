//! The server's self-signed TLS certificate. Clients pin its SHA-256 fingerprint, which reaches
//! them through the game (authority → game server → player), so no CA is involved.

use std::path::Path;

use anyhow::Context;
use rustls::pki_types::{CertificateDer, PrivateKeyDer, PrivatePkcs8KeyDer};

const CERT_FILE: &str = "cert.der";
const KEY_FILE: &str = "key.der";
const FINGERPRINT_FILE: &str = "fingerprint.txt";

#[derive(Debug)]
pub struct Identity {
    pub cert: CertificateDer<'static>,
    pub key: PrivatePkcs8KeyDer<'static>,
}

impl Clone for Identity {
    fn clone(&self) -> Self {
        Self {
            cert: self.cert.clone(),
            key: self.key.clone_key(),
        }
    }
}

impl Identity {
    /// A fresh certificate, kept in memory only.
    pub fn generate() -> anyhow::Result<Self> {
        let ck = rcgen::generate_simple_self_signed(vec!["acre2-voice".to_string()])
            .context("generating certificate")?;
        Ok(Self {
            cert: ck.cert.der().clone(),
            key: PrivatePkcs8KeyDer::from(ck.signing_key.serialize_der()),
        })
    }

    /// Loads the certificate from `dir`, or generates and saves one. Also writes the hex
    /// fingerprint to `fingerprint.txt` for admins.
    pub fn load_or_generate(dir: &Path) -> anyhow::Result<Self> {
        let cert_path = dir.join(CERT_FILE);
        let key_path = dir.join(KEY_FILE);
        let identity = if cert_path.exists() && key_path.exists() {
            Self {
                cert: CertificateDer::from(
                    std::fs::read(&cert_path)
                        .with_context(|| format!("reading {}", cert_path.display()))?,
                ),
                key: PrivatePkcs8KeyDer::from(
                    std::fs::read(&key_path)
                        .with_context(|| format!("reading {}", key_path.display()))?,
                ),
            }
        } else {
            std::fs::create_dir_all(dir).with_context(|| format!("creating {}", dir.display()))?;
            let identity = Self::generate()?;
            std::fs::write(&cert_path, identity.cert.as_ref())
                .with_context(|| format!("writing {}", cert_path.display()))?;
            write_private(&key_path, identity.key.secret_pkcs8_der())
                .with_context(|| format!("writing {}", key_path.display()))?;
            identity
        };
        std::fs::write(
            dir.join(FINGERPRINT_FILE),
            format!("{}\n", identity.fingerprint_hex()),
        )
        .context("writing fingerprint")?;
        Ok(identity)
    }

    #[must_use]
    pub fn fingerprint(&self) -> [u8; 32] {
        fingerprint(&self.cert)
    }

    #[must_use]
    pub fn fingerprint_hex(&self) -> String {
        hex(&self.fingerprint())
    }

    #[must_use]
    pub fn key_der(&self) -> PrivateKeyDer<'static> {
        PrivateKeyDer::Pkcs8(self.key.clone_key())
    }
}

/// SHA-256 of a DER certificate.
#[must_use]
pub fn fingerprint(cert: &[u8]) -> [u8; 32] {
    let digest = ring::digest::digest(&ring::digest::SHA256, cert);
    digest.as_ref().try_into().expect("SHA-256 is 32 bytes")
}

fn hex(bytes: &[u8]) -> String {
    use std::fmt::Write;
    bytes.iter().fold(String::new(), |mut s, b| {
        let _ = write!(s, "{b:02x}");
        s
    })
}

fn write_private(path: &Path, data: &[u8]) -> std::io::Result<()> {
    #[cfg(unix)]
    {
        use std::io::Write;
        use std::os::unix::fs::OpenOptionsExt;
        let mut f = std::fs::OpenOptions::new()
            .write(true)
            .create(true)
            .truncate(true)
            .mode(0o600)
            .open(path)?;
        f.write_all(data)
    }
    #[cfg(not(unix))]
    {
        std::fs::write(path, data)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn persisted_identity_is_stable() {
        let dir = std::env::temp_dir().join(format!("acre2-voice-identity-{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&dir);
        let a = Identity::load_or_generate(&dir).unwrap();
        let b = Identity::load_or_generate(&dir).unwrap();
        assert_eq!(a.fingerprint(), b.fingerprint());
        let written = std::fs::read_to_string(dir.join(FINGERPRINT_FILE)).unwrap();
        assert_eq!(written.trim(), a.fingerprint_hex());
        std::fs::remove_dir_all(&dir).unwrap();
    }
}
