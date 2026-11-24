//! QUIC endpoint setup.
//!
//! quinn's default UDP socket enables platform features (packet info, ECN, don't-fragment) and
//! refuses to run if the OS rejects any of them. Wine/Proton rejects some
//! (`WSAEOPNOTSUPP`, OS error 10045), so if the default socket can't be set up this falls back
//! to a plain UDP socket without them. QUIC works fine without; it only loses ECN and path MTU
//! probing.

use std::{
    fmt,
    io::{self, IoSliceMut},
    net::{SocketAddr, UdpSocket as StdUdpSocket},
    pin::Pin,
    sync::Arc,
    task::{Context, Poll, ready},
};

use quinn::{
    AsyncUdpSocket, Endpoint, EndpointConfig, ServerConfig, TokioRuntime, UdpPoller,
    udp::{RecvMeta, Transmit},
};

/// Binds a QUIC endpoint on `addr` (a server if `server_config` is given). Must be called inside
/// a tokio runtime.
pub fn bind(addr: SocketAddr, server_config: Option<ServerConfig>) -> io::Result<Endpoint> {
    let socket = StdUdpSocket::bind(addr)?;
    match Endpoint::new(
        EndpointConfig::default(),
        server_config.clone(),
        socket,
        Arc::new(TokioRuntime),
    ) {
        Ok(endpoint) => Ok(endpoint),
        Err(e) => {
            tracing::warn!(error = %e, "platform UDP socket unsupported, using a plain UDP socket");
            bind_plain(addr, server_config)
        }
    }
}

/// Binds an endpoint on a plain UDP socket (no ECN, packet info or GSO).
pub fn bind_plain(addr: SocketAddr, server_config: Option<ServerConfig>) -> io::Result<Endpoint> {
    let socket = StdUdpSocket::bind(addr)?;
    socket.set_nonblocking(true)?;
    let socket = PlainUdp {
        io: tokio::net::UdpSocket::from_std(socket)?,
    };
    Endpoint::new_with_abstract_socket(
        EndpointConfig::default(),
        server_config,
        Arc::new(socket),
        Arc::new(TokioRuntime),
    )
}

struct PlainUdp {
    io: tokio::net::UdpSocket,
}

impl fmt::Debug for PlainUdp {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("PlainUdp")
            .field("local", &self.io.local_addr().ok())
            .finish()
    }
}

#[derive(Debug)]
struct PlainPoller(Arc<PlainUdp>);

impl UdpPoller for PlainPoller {
    fn poll_writable(self: Pin<&mut Self>, cx: &mut Context) -> Poll<io::Result<()>> {
        self.0.io.poll_send_ready(cx)
    }
}

impl AsyncUdpSocket for PlainUdp {
    fn create_io_poller(self: Arc<Self>) -> Pin<Box<dyn UdpPoller>> {
        Box::pin(PlainPoller(self))
    }

    fn try_send(&self, transmit: &Transmit) -> io::Result<()> {
        // max_transmit_segments is 1, so there is never more than one datagram.
        self.io
            .try_send_to(transmit.contents, transmit.destination)
            .map(|_| ())
    }

    fn poll_recv(
        &self,
        cx: &mut Context,
        bufs: &mut [IoSliceMut<'_>],
        meta: &mut [RecvMeta],
    ) -> Poll<io::Result<usize>> {
        loop {
            ready!(self.io.poll_recv_ready(cx))?;
            match self.io.try_recv_from(&mut bufs[0]) {
                Ok((len, addr)) => {
                    meta[0] = RecvMeta {
                        addr,
                        len,
                        stride: len,
                        ..RecvMeta::default()
                    };
                    return Poll::Ready(Ok(1));
                }
                Err(e) if e.kind() == io::ErrorKind::WouldBlock => {}
                Err(e) => return Poll::Ready(Err(e)),
            }
        }
    }

    fn local_addr(&self) -> io::Result<SocketAddr> {
        self.io.local_addr()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    /// The fallback socket carries real QUIC traffic.
    #[tokio::test]
    async fn plain_socket_endpoints_talk() {
        // A throwaway self-signed server.
        let ck = rcgen_free_cert();
        let mut crypto = quinn::rustls::ServerConfig::builder_with_provider(Arc::new(
            quinn::rustls::crypto::ring::default_provider(),
        ))
        .with_protocol_versions(&[&quinn::rustls::version::TLS13])
        .unwrap()
        .with_no_client_auth()
        .with_single_cert(vec![ck.0.clone()], ck.1)
        .unwrap();
        crypto.alpn_protocols = vec![b"t".to_vec()];
        let server_config = ServerConfig::with_crypto(Arc::new(
            quinn::crypto::rustls::QuicServerConfig::try_from(crypto).unwrap(),
        ));
        let server = bind_plain("127.0.0.1:0".parse().unwrap(), Some(server_config)).unwrap();
        let server_addr = server.local_addr().unwrap();
        tokio::spawn(async move {
            let conn = server.accept().await.unwrap().await.unwrap();
            let d = conn.read_datagram().await.unwrap();
            conn.send_datagram(d).unwrap();
            conn.closed().await;
        });

        let mut roots = quinn::rustls::RootCertStore::empty();
        roots.add(ck.0).unwrap();
        let mut client_crypto = quinn::rustls::ClientConfig::builder_with_provider(Arc::new(
            quinn::rustls::crypto::ring::default_provider(),
        ))
        .with_protocol_versions(&[&quinn::rustls::version::TLS13])
        .unwrap()
        .with_root_certificates(roots)
        .with_no_client_auth();
        client_crypto.alpn_protocols = vec![b"t".to_vec()];
        let mut client = bind_plain("127.0.0.1:0".parse().unwrap(), None).unwrap();
        client.set_default_client_config(quinn::ClientConfig::new(Arc::new(
            quinn::crypto::rustls::QuicClientConfig::try_from(client_crypto).unwrap(),
        )));
        let conn = client
            .connect(server_addr, "localhost")
            .unwrap()
            .await
            .unwrap();
        conn.send_datagram(bytes_from(b"ping")).unwrap();
        assert_eq!(&conn.read_datagram().await.unwrap()[..], b"ping");
    }

    fn bytes_from(b: &'static [u8]) -> bytes::Bytes {
        bytes::Bytes::from_static(b)
    }

    fn rcgen_free_cert() -> (
        quinn::rustls::pki_types::CertificateDer<'static>,
        quinn::rustls::pki_types::PrivateKeyDer<'static>,
    ) {
        let ck = rcgen::generate_simple_self_signed(vec!["localhost".into()]).unwrap();
        (
            ck.cert.der().clone(),
            quinn::rustls::pki_types::PrivateKeyDer::Pkcs8(ck.signing_key.serialize_der().into()),
        )
    }
}
