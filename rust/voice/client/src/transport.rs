//! QUIC connection setup with certificate pinning.

use std::{net::SocketAddr, sync::Arc, time::Duration};

use rustls::{
    DigitallySignedStruct, SignatureScheme,
    client::danger::{HandshakeSignatureValid, ServerCertVerified, ServerCertVerifier},
    crypto::CryptoProvider,
    pki_types::{CertificateDer, ServerName, UnixTime},
};

use crate::Error;

/// Server name presented in TLS. The certificate isn't checked against it; pinning replaces
/// name validation.
const SERVER_NAME: &str = "acre2-voice";
const CONNECT_TIMEOUT: Duration = Duration::from_secs(10);

/// SHA-256 of a DER certificate.
#[must_use]
pub fn fingerprint(cert: &[u8]) -> [u8; 32] {
    let digest = ring::digest::digest(&ring::digest::SHA256, cert);
    digest.as_ref().try_into().expect("SHA-256 is 32 bytes")
}

/// Parses a 64-character hex fingerprint.
#[must_use]
pub fn parse_fingerprint(hex: &str) -> Option<[u8; 32]> {
    acre2_voice_proto::Token::from_hex(hex.trim()).map(|t| t.0)
}

/// Accepts exactly the certificate with the pinned fingerprint, or any certificate when
/// `pinned` is `None` (only for the authority, when the admin hasn't configured one).
#[derive(Debug)]
struct PinnedVerifier {
    pinned: Option<[u8; 32]>,
    provider: Arc<CryptoProvider>,
}

impl ServerCertVerifier for PinnedVerifier {
    fn verify_server_cert(
        &self,
        end_entity: &CertificateDer<'_>,
        _intermediates: &[CertificateDer<'_>],
        _server_name: &ServerName<'_>,
        _ocsp_response: &[u8],
        _now: UnixTime,
    ) -> Result<ServerCertVerified, rustls::Error> {
        match self.pinned {
            Some(pinned) if fingerprint(end_entity) != pinned => Err(rustls::Error::General(
                "server certificate does not match the pinned fingerprint".into(),
            )),
            _ => Ok(ServerCertVerified::assertion()),
        }
    }

    fn verify_tls12_signature(
        &self,
        message: &[u8],
        cert: &CertificateDer<'_>,
        dss: &DigitallySignedStruct,
    ) -> Result<HandshakeSignatureValid, rustls::Error> {
        rustls::crypto::verify_tls12_signature(
            message,
            cert,
            dss,
            &self.provider.signature_verification_algorithms,
        )
    }

    fn verify_tls13_signature(
        &self,
        message: &[u8],
        cert: &CertificateDer<'_>,
        dss: &DigitallySignedStruct,
    ) -> Result<HandshakeSignatureValid, rustls::Error> {
        rustls::crypto::verify_tls13_signature(
            message,
            cert,
            dss,
            &self.provider.signature_verification_algorithms,
        )
    }

    fn supported_verify_schemes(&self) -> Vec<SignatureScheme> {
        self.provider
            .signature_verification_algorithms
            .supported_schemes()
    }
}

fn client_config(pinned: Option<[u8; 32]>, alpn: &[u8]) -> Result<quinn::ClientConfig, Error> {
    let provider = Arc::new(rustls::crypto::ring::default_provider());
    let mut crypto = rustls::ClientConfig::builder_with_provider(provider.clone())
        .with_protocol_versions(&[&rustls::version::TLS13])
        .map_err(|e| Error::Tls(e.to_string()))?
        .dangerous()
        .with_custom_certificate_verifier(Arc::new(PinnedVerifier { pinned, provider }))
        .with_no_client_auth();
    crypto.alpn_protocols = vec![alpn.to_vec()];
    let crypto = quinn::crypto::rustls::QuicClientConfig::try_from(crypto)
        .map_err(|e| Error::Tls(e.to_string()))?;
    let mut config = quinn::ClientConfig::new(Arc::new(crypto));
    let mut transport = quinn::TransportConfig::default();
    transport.max_idle_timeout(Some(
        Duration::from_secs(20)
            .try_into()
            .expect("valid idle timeout"),
    ));
    transport.keep_alive_interval(Some(Duration::from_secs(5)));
    config.transport_config(Arc::new(transport));
    Ok(config)
}

pub(crate) async fn resolve(addr: &str) -> Result<SocketAddr, Error> {
    tokio::net::lookup_host(addr)
        .await
        .map_err(|e| Error::Resolve(format!("{addr}: {e}")))?
        .next()
        .ok_or_else(|| Error::Resolve(format!("{addr}: no addresses")))
}

/// Opens a QUIC connection and its control stream.
pub(crate) async fn connect(
    addr: &str,
    pinned: Option<[u8; 32]>,
    alpn: &[u8],
) -> Result<
    (
        quinn::Endpoint,
        quinn::Connection,
        quinn::SendStream,
        quinn::RecvStream,
    ),
    Error,
> {
    let remote = resolve(addr).await?;
    let local: SocketAddr = if remote.is_ipv6() {
        "[::]:0".parse().expect("valid")
    } else {
        "0.0.0.0:0".parse().expect("valid")
    };
    let mut endpoint = acre2_voice_net::bind(local, None).map_err(Error::Io)?;
    endpoint.set_default_client_config(client_config(pinned, alpn)?);
    let conn = tokio::time::timeout(CONNECT_TIMEOUT, async {
        endpoint
            .connect(remote, SERVER_NAME)?
            .await
            .map_err(Error::from)
    })
    .await
    .map_err(|_| Error::Timeout)??;
    let (send, recv) = conn.open_bi().await?;
    Ok((endpoint, conn, send, recv))
}

/// Text form of why a connection closed.
pub(crate) fn describe_close(err: &quinn::ConnectionError) -> String {
    match err {
        quinn::ConnectionError::ApplicationClosed(c) => {
            String::from_utf8_lossy(&c.reason).into_owned()
        }
        other => other.to_string(),
    }
}
