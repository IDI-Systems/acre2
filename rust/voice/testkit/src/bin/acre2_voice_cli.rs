//! Manual testing with real audio devices, without the game.
//!
//! ```text
//! acre2_voice_cli devices
//! acre2_voice_cli talk --server 127.0.0.1:9987 --secret '…' --name alice --pos 0,0,0
//! acre2_voice_cli talk --server 127.0.0.1:9987 --secret '…' --name bob --pos 10,0,0 --ptt
//! ```
//!
//! Each `talk` briefly acts as the authority to issue its own token and set its position (so
//! don't run it against a server a game is using), then joins and talks: voice activation by
//! default, or hold Enter-to-toggle with `--ptt`. Set `--radio` to also transmit and listen on a
//! channel.

use std::io::{BufRead, Write};

use acre2_voice_client::{
    Authority, Client,
    audio::{
        ActivationConfig, ActivationMode, Outgoing, PassthroughRenderer, SessionConfig,
        SessionEvent, VoiceSession, list_devices,
    },
    parse_fingerprint,
};
use acre2_voice_proto::{ChannelKey, Target, TxId, WorldUpdate};
use anyhow::Context;
use clap::{Parser, Subcommand};

#[derive(Debug, Parser)]
#[command(version, about = "Test client for the acre2 voice server")]
struct Args {
    #[command(subcommand)]
    command: Command,
}

#[derive(Debug, Subcommand)]
enum Command {
    /// List audio devices.
    Devices,
    /// Join and talk.
    Talk {
        #[arg(long, default_value = "127.0.0.1:9987")]
        server: String,
        /// The server's authority secret.
        #[arg(long)]
        secret: String,
        /// Certificate fingerprint (hex). Without it, the first certificate seen is trusted.
        #[arg(long)]
        fingerprint: Option<String>,
        #[arg(long, default_value = "cli")]
        name: String,
        /// Position as x,y,z.
        #[arg(long, default_value = "0,0,0", value_parser = parse_pos)]
        pos: [f32; 3],
        /// Direct speech range in metres.
        #[arg(long, default_value_t = 50.0)]
        range: f32,
        /// Push-to-talk: Enter toggles transmitting.
        #[arg(long)]
        ptt: bool,
        /// Voice activation threshold, dBFS.
        #[arg(long, default_value_t = -45.0)]
        threshold: f32,
        /// Also listen on this channel; with --ptt, Enter keys it as well.
        #[arg(long)]
        radio: Option<String>,
        #[arg(long)]
        input: Option<String>,
        #[arg(long)]
        output: Option<String>,
    },
}

fn parse_pos(s: &str) -> Result<[f32; 3], String> {
    let v: Vec<f32> = s
        .split(',')
        .map(|p| p.trim().parse::<f32>().map_err(|e| e.to_string()))
        .collect::<Result<_, _>>()?;
    v.try_into().map_err(|_| "expected x,y,z".to_string())
}

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    tracing_subscriber::fmt()
        .with_env_filter(
            tracing_subscriber::EnvFilter::try_from_default_env()
                .unwrap_or_else(|_| tracing_subscriber::EnvFilter::new("info")),
        )
        .init();

    match Args::parse().command {
        Command::Devices => {
            let d = list_devices();
            let show =
                |title: &str,
                 list: Vec<acre2_voice_client::audio::AudioDevice>,
                 default: Option<acre2_voice_client::audio::AudioDevice>| {
                    println!("{title}:");
                    for dev in list {
                        let mark = if default.as_ref() == Some(&dev) {
                            "*"
                        } else {
                            " "
                        };
                        println!(" {mark} {:<40} {}", dev.id, dev.name);
                    }
                };
            show("inputs", d.inputs, d.default_input);
            show("outputs", d.outputs, d.default_output);
            Ok(())
        }
        Command::Talk {
            server,
            secret,
            fingerprint,
            name,
            pos,
            range,
            ptt,
            threshold,
            radio,
            input,
            output,
        } => {
            let pinned = fingerprint
                .as_deref()
                .map(|f| parse_fingerprint(f).context("fingerprint must be 64 hex characters"))
                .transpose()?;
            let (authority, _) = Authority::connect(&server, pinned, &secret).await?;
            let fingerprint = authority.welcome().cert_fingerprint;
            authority.update_world(vec![WorldUpdate {
                external_id: name.clone(),
                position: pos,
                active: true,
            }])?;
            let token = authority.issue_token(name.clone()).await?.token;
            authority.ping().await?;
            drop(authority);

            let (client, events) = Client::connect(&server, fingerprint, token).await?;
            println!("joined as {} ({name}) at {pos:?}", client.peer_id());
            let radio = radio.map(ChannelKey::new).transpose()?;
            if let Some(r) = &radio {
                client.set_subscriptions(vec![r.clone()])?;
            }
            let (session, session_events) = VoiceSession::start(
                client,
                events,
                SessionConfig {
                    activation: ActivationConfig {
                        mode: if ptt {
                            ActivationMode::PushToTalk
                        } else {
                            ActivationMode::Voice
                        },
                        open_db: threshold,
                        close_db: threshold - 5.0,
                        ..ActivationConfig::default()
                    },
                    input_device: input,
                    output_device: output,
                    ..SessionConfig::default()
                },
                Box::new(PassthroughRenderer),
            )?;
            session.transmitter().set_direct(Some(Outgoing {
                targets: vec![Target::Spatial { range }],
                metadata: name.into_bytes(),
            }));

            std::thread::spawn(move || {
                for ev in session_events {
                    match ev {
                        SessionEvent::Server(m) => println!("server: {m:?}"),
                        SessionEvent::Device(d) => println!("device: {d:?}"),
                        SessionEvent::Transmitting { tx, active } => {
                            println!(
                                "{} transmitting on {tx:?}",
                                if active { "started" } else { "stopped" }
                            );
                        }
                        SessionEvent::Closed { reason } => {
                            println!("disconnected: {reason}");
                            std::process::exit(0);
                        }
                    }
                }
            });

            if ptt {
                println!("press Enter to start/stop talking, Ctrl-C to quit");
                let mut talking = false;
                for _ in std::io::stdin().lock().lines() {
                    talking = !talking;
                    let mut t = session.transmitter();
                    t.set_direct_ptt(talking);
                    if let Some(r) = &radio {
                        if talking {
                            t.key(
                                TxId(1),
                                Outgoing {
                                    targets: vec![Target::Channel(r.clone())],
                                    metadata: vec![],
                                },
                            );
                        } else {
                            t.unkey(TxId(1));
                        }
                    }
                    println!("{}", if talking { "talking" } else { "stopped" });
                }
            } else {
                println!("voice activation at {threshold} dBFS, Ctrl-C to quit");
                loop {
                    tokio::time::sleep(std::time::Duration::from_secs(1)).await;
                    print!("\rmic {:6.1} dBFS ", session.mic_level_db());
                    let _ = std::io::stdout().flush();
                }
            }
            Ok(())
        }
    }
}
