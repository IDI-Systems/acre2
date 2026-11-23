use std::path::PathBuf;

use acre2_voice_server::{Config, Identity, Server};
use anyhow::Context;
use clap::Parser;
use tracing_subscriber::EnvFilter;

/// acre2 voice server.
#[derive(Debug, Parser)]
#[command(version)]
struct Args {
    /// Path to the TOML config file.
    #[arg(short, long, default_value = "acre2_voice_server.toml")]
    config: PathBuf,
}

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    tracing_subscriber::fmt()
        .with_env_filter(
            EnvFilter::try_from_default_env().unwrap_or_else(|_| EnvFilter::new("info")),
        )
        .init();

    let args = Args::parse();
    let text = std::fs::read_to_string(&args.config)
        .with_context(|| format!("reading config {}", args.config.display()))?;
    let config: Config =
        toml::from_str(&text).with_context(|| format!("parsing {}", args.config.display()))?;
    config.validate()?;

    let identity = Identity::load_or_generate(&config.data_dir)?;
    println!("certificate fingerprint: {}", identity.fingerprint_hex());
    let server = Server::start(config, &identity)?;

    tokio::signal::ctrl_c()
        .await
        .context("waiting for ctrl-c")?;
    tracing::info!("shutting down");
    server.shutdown().await;
    Ok(())
}
