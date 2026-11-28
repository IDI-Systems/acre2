//! End-to-end tests over real QUIC on localhost.

use std::time::Duration;

use acre2_voice_client::{Authority, AuthorityEvent, Client, ClientEvent, Error};
use acre2_voice_proto::{
    ChannelKey, ChannelRule, ExtraPosition, MatchedTarget, PositionRole, ServerMsg, Target, Token,
    TxId,
};
use acre2_voice_testkit::{Bot, Harness, SECRET};
use bytes::Bytes;

const QUIET: Duration = Duration::from_millis(300);

fn key(s: &str) -> ChannelKey {
    ChannelKey::new(s).unwrap()
}

/// Sends a few frames, as a real speaker would keep doing; returns once `listener` hears one.
async fn talk_until_heard(speaker: &Bot, listener: &mut Bot, tx: TxId) -> anyhow::Result<()> {
    for seq in 0..20u16 {
        speaker
            .client
            .send_voice(tx, seq, 0, Bytes::from_static(b"\x01opus"))?;
        tokio::time::sleep(Duration::from_millis(20)).await;
    }
    let v = listener.next_voice().await?;
    assert_eq!(v.speaker, speaker.client.peer_id());
    assert_eq!(v.tx, tx);
    assert_eq!(&v.payload[..], b"\x01opus");
    Ok(())
}

#[tokio::test]
async fn join_and_authority_notifications() -> anyhow::Result<()> {
    let mut h = Harness::start().await?;
    let a = h.join("a").await?;
    assert_eq!(a.client.external_id(), "a");
    assert_eq!(
        h.next_authority_event().await?,
        AuthorityEvent::PeerConnected {
            external_id: "a".into(),
            peer_id: a.client.peer_id()
        }
    );
    let peer = a.client.peer_id();
    drop(a);
    assert_eq!(
        h.next_authority_event().await?,
        AuthorityEvent::PeerDisconnected {
            external_id: "a".into(),
            peer_id: peer
        }
    );
    Ok(())
}

#[tokio::test]
async fn direct_speech_reaches_only_nearby() -> anyhow::Result<()> {
    let h = Harness::start().await?;
    let mut a = h.join("a").await?;
    let mut b = h.join("b").await?;
    let mut c = h.join("c").await?;
    h.place(&[
        ("a", [0.0; 3]),
        ("b", [10.0, 0.0, 0.0]),
        ("c", [1000.0, 0.0, 0.0]),
    ])
    .await?;

    a.client.start_transmission(
        TxId(1),
        vec![Target::Spatial { range: 50.0 }],
        b"meta".to_vec(),
    )?;
    a.sync().await?;

    match b.next_message().await? {
        ServerMsg::TransmissionStarted {
            speaker,
            speaker_external_id,
            tx,
            matched,
            metadata,
        } => {
            assert_eq!(speaker, a.client.peer_id());
            assert_eq!(speaker_external_id, "a");
            assert_eq!(tx, TxId(1));
            assert_eq!(metadata, b"meta");
            assert!(
                matches!(matched[..], [MatchedTarget::Spatial { distance }] if (distance - 10.0).abs() < 0.01)
            );
        }
        other => panic!("unexpected {other:?}"),
    }
    talk_until_heard(&a, &mut b, TxId(1)).await?;
    c.expect_silence(QUIET).await?;

    a.client.stop_transmission(TxId(1))?;
    assert_eq!(
        b.next_message().await?,
        ServerMsg::TransmissionEnded {
            speaker: a.client.peer_id(),
            tx: TxId(1)
        }
    );
    Ok(())
}

#[tokio::test]
async fn radio_channel_ignores_distance() -> anyhow::Result<()> {
    let h = Harness::start().await?;
    let mut a = h.join("a").await?;
    let mut c = h.join("c").await?;
    h.place(&[("a", [0.0; 3]), ("c", [10_000.0, 0.0, 0.0])])
        .await?;

    c.client.set_subscriptions(vec![key("radio:43.100")])?;
    c.sync().await?;
    a.client
        .start_transmission(TxId(2), vec![Target::Channel(key("radio:43.100"))], vec![])?;
    a.sync().await?;

    assert!(matches!(
        c.next_message().await?,
        ServerMsg::TransmissionStarted { matched, .. } if matched == vec![MatchedTarget::Channel(key("radio:43.100"))]
    ));
    talk_until_heard(&a, &mut c, TxId(2)).await?;

    // Tuning away mid-transmission ends it for the listener.
    c.client.set_subscriptions(vec![])?;
    let msgs = c.sync().await?;
    assert!(msgs.contains(&ServerMsg::TransmissionEnded {
        speaker: a.client.peer_id(),
        tx: TxId(2)
    }));
    Ok(())
}

#[tokio::test]
async fn walking_into_range_starts_hearing() -> anyhow::Result<()> {
    let h = Harness::start().await?;
    let mut a = h.join("a").await?;
    let mut b = h.join("b").await?;
    h.place(&[("a", [0.0; 3]), ("b", [500.0, 0.0, 0.0])])
        .await?;
    a.client
        .start_transmission(TxId(0), vec![Target::Spatial { range: 30.0 }], vec![])?;
    a.sync().await?;
    b.expect_silence(QUIET).await?;

    h.place(&[("b", [20.0, 0.0, 0.0])]).await?;
    // Picked up by the periodic re-resolve.
    assert!(matches!(
        b.next_message().await?,
        ServerMsg::TransmissionStarted { .. }
    ));
    talk_until_heard(&a, &mut b, TxId(0)).await?;
    Ok(())
}

#[tokio::test]
async fn speaker_disconnect_ends_transmission() -> anyhow::Result<()> {
    let h = Harness::start().await?;
    let mut a = h.join("a").await?;
    let mut b = h.join("b").await?;
    h.place(&[("a", [0.0; 3]), ("b", [1.0, 0.0, 0.0])]).await?;
    a.client
        .start_transmission(TxId(0), vec![Target::Spatial { range: 30.0 }], vec![])?;
    a.sync().await?;
    assert!(matches!(
        b.next_message().await?,
        ServerMsg::TransmissionStarted { .. }
    ));
    let peer = a.client.peer_id();
    drop(a);
    assert_eq!(
        b.next_message().await?,
        ServerMsg::TransmissionEnded {
            speaker: peer,
            tx: TxId(0)
        }
    );
    Ok(())
}

#[tokio::test]
async fn zeus_camera_needs_permission() -> anyhow::Result<()> {
    let h = Harness::start().await?;
    let mut zeus = h.join("zeus").await?;
    let mut far = h.join("far").await?;
    h.place(&[("zeus", [0.0; 3]), ("far", [2000.0, 0.0, 0.0])])
        .await?;
    let camera = vec![ExtraPosition {
        position: [1995.0, 0.0, 10.0],
        role: PositionRole::Both,
    }];

    zeus.client.set_extra_positions(camera.clone())?;
    let msgs = zeus.sync().await?;
    assert!(matches!(&msgs[..], [ServerMsg::Error { message }] if message.contains("not allowed")));

    h.authority.set_report_position("zeus", true)?;
    h.authority.ping().await?;
    zeus.client.set_extra_positions(camera)?;
    assert_eq!(zeus.sync().await?, [] as [acre2_voice_proto::ServerMsg; 0]);

    zeus.client
        .start_transmission(TxId(0), vec![Target::Spatial { range: 50.0 }], vec![])?;
    zeus.sync().await?;
    assert!(matches!(
        far.next_message().await?,
        ServerMsg::TransmissionStarted { .. }
    ));
    talk_until_heard(&zeus, &mut far, TxId(0)).await?;
    Ok(())
}

#[tokio::test]
async fn channel_rules_block_transmitting() -> anyhow::Result<()> {
    let h = Harness::start().await?;
    let mut a = h.join("a").await?;
    let mut b = h.join("b").await?;
    h.authority.set_channel_rules(
        None,
        vec![ChannelRule {
            prefix: "god:".into(),
            allow_tx: false,
            allow_rx: true,
        }],
    )?;
    h.authority.ping().await?;
    b.client.set_subscriptions(vec![key("god:all")])?;
    b.sync().await?;

    a.client
        .start_transmission(TxId(0), vec![Target::Channel(key("god:all"))], vec![])?;
    let msgs = a.sync().await?;
    assert!(matches!(&msgs[..], [ServerMsg::Error { message }] if message.contains("god:all")));
    b.expect_silence(QUIET).await?;
    Ok(())
}

#[tokio::test]
async fn tokens_are_single_use() -> anyhow::Result<()> {
    let h = Harness::start().await?;
    let issued = h.authority.issue_token("a").await?;
    let (_a, _) = Client::connect(&h.addr, h.fingerprint, issued.token).await?;
    let err = Client::connect(&h.addr, h.fingerprint, issued.token)
        .await
        .unwrap_err();
    assert!(
        matches!(err, Error::Rejected(ref r) if r.contains("token")),
        "{err:?}"
    );

    let err = Client::connect(&h.addr, h.fingerprint, Token([0; 32]))
        .await
        .unwrap_err();
    assert!(matches!(err, Error::Rejected(_)), "{err:?}");
    Ok(())
}

#[tokio::test]
async fn rejoining_replaces_old_connection() -> anyhow::Result<()> {
    let h = Harness::start().await?;
    let mut first = h.join("a").await?;
    let second = h.join("a").await?;
    assert_ne!(first.client.peer_id(), second.client.peer_id());
    loop {
        if let ClientEvent::Closed { reason } = first.next().await? {
            assert!(reason.contains("replaced"), "{reason}");
            break;
        }
    }
    Ok(())
}

#[tokio::test]
async fn authority_can_remove_player() -> anyhow::Result<()> {
    let h = Harness::start().await?;
    let mut a = h.join("a").await?;
    h.authority.remove_player("a")?;
    loop {
        if let ClientEvent::Closed { reason } = a.next().await? {
            assert!(reason.contains("removed"), "{reason}");
            break;
        }
    }
    Ok(())
}

#[tokio::test]
async fn wrong_fingerprint_is_refused() -> anyhow::Result<()> {
    let h = Harness::start().await?;
    let issued = h.authority.issue_token("a").await?;
    let err = Client::connect(&h.addr, [0xaa; 32], issued.token)
        .await
        .unwrap_err();
    assert!(matches!(err, Error::Connection(_)), "{err:?}");
    Ok(())
}

#[tokio::test]
async fn wrong_authority_secret_is_refused() -> anyhow::Result<()> {
    let h = Harness::start().await?;
    let err = Authority::connect(&h.addr, Some(h.fingerprint), "nope-nope-nope")
        .await
        .unwrap_err();
    assert!(matches!(err, Error::Rejected(_)), "{err:?}");
    // The real authority is unaffected.
    h.authority.ping().await?;
    let _ = SECRET;
    Ok(())
}

#[tokio::test]
async fn server_full() -> anyhow::Result<()> {
    let h = Harness::with_config(|c| c.max_peers = 1).await?;
    let _a = h.join("a").await?;
    let err = h.join("b").await.unwrap_err();
    assert!(err.to_string().contains("full"), "{err}");
    Ok(())
}

#[tokio::test]
async fn flooding_control_messages_gets_kicked() -> anyhow::Result<()> {
    let h = Harness::start().await?;
    let mut a = h.join("a").await?;
    // Far beyond the 200-message burst, faster than 50/s refills it.
    for nonce in 0..1000 {
        if a.client
            .send(acre2_voice_proto::ClientMsg::Ping { nonce })
            .is_err()
        {
            tokio::task::yield_now().await;
        }
    }
    loop {
        if let ClientEvent::Closed { reason } = a.next().await? {
            assert!(reason.contains("too many"), "{reason}");
            break;
        }
    }
    Ok(())
}
