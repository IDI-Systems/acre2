//! Checks which UDP socket path works on this platform (handy under Wine/Proton):
//! `cargo run -p acre2_voice_net --example socket_probe`.

use std::sync::Arc;

#[tokio::main]
async fn main() {
    let addr = "0.0.0.0:0".parse().unwrap();
    let socket = std::net::UdpSocket::bind(addr).unwrap();
    match quinn::Endpoint::new(
        quinn::EndpointConfig::default(),
        None,
        socket,
        Arc::new(quinn::TokioRuntime),
    ) {
        Ok(_) => println!("default quinn socket: ok"),
        Err(e) => println!("default quinn socket: FAILED: {e}"),
    }
    match acre2_voice_net::bind(addr, None) {
        Ok(e) => println!("acre2_voice_net::bind: ok on {}", e.local_addr().unwrap()),
        Err(e) => println!("acre2_voice_net::bind: FAILED: {e}"),
    }
}
