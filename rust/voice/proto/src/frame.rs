//! Length-prefixed framing for control messages: `[len: u32 LE][postcard bytes]`.

use serde::{Serialize, de::DeserializeOwned};

use crate::MAX_FRAME_LEN;

#[derive(Debug, thiserror::Error)]
pub enum FrameError {
    #[error("frame of {0} bytes exceeds the {MAX_FRAME_LEN} byte limit")]
    TooLarge(usize),
    #[error("malformed message: {0}")]
    Decode(#[from] postcard::Error),
    #[error(transparent)]
    Io(#[from] std::io::Error),
}

/// Encodes a message with its length prefix.
pub fn encode<T: Serialize>(msg: &T) -> Result<Vec<u8>, FrameError> {
    let body = postcard::to_stdvec(msg)?;
    if body.len() > MAX_FRAME_LEN {
        return Err(FrameError::TooLarge(body.len()));
    }
    let mut out = Vec::with_capacity(4 + body.len());
    out.extend_from_slice(&(body.len() as u32).to_le_bytes());
    out.extend_from_slice(&body);
    Ok(out)
}

/// Decodes a message body (without the length prefix).
pub fn decode<T: DeserializeOwned>(body: &[u8]) -> Result<T, FrameError> {
    Ok(postcard::from_bytes(body)?)
}

#[cfg(feature = "io")]
mod io {
    use serde::{Serialize, de::DeserializeOwned};
    use tokio::io::{AsyncRead, AsyncReadExt, AsyncWrite, AsyncWriteExt};

    use super::{FrameError, decode, encode};
    use crate::MAX_FRAME_LEN;

    /// Reads one message. Returns `Ok(None)` on a clean end of stream before a new frame.
    pub async fn read<T, R>(reader: &mut R) -> Result<Option<T>, FrameError>
    where
        T: DeserializeOwned,
        R: AsyncRead + Unpin,
    {
        let mut len = [0u8; 4];
        match reader.read_exact(&mut len).await {
            Ok(_) => {}
            Err(e) if e.kind() == std::io::ErrorKind::UnexpectedEof => return Ok(None),
            Err(e) => return Err(e.into()),
        }
        let len = u32::from_le_bytes(len) as usize;
        if len > MAX_FRAME_LEN {
            return Err(FrameError::TooLarge(len));
        }
        let mut body = vec![0u8; len];
        reader.read_exact(&mut body).await?;
        decode(&body).map(Some)
    }

    /// Writes one message.
    pub async fn write<T, W>(writer: &mut W, msg: &T) -> Result<(), FrameError>
    where
        T: Serialize,
        W: AsyncWrite + Unpin,
    {
        writer.write_all(&encode(msg)?).await?;
        Ok(())
    }
}

#[cfg(feature = "io")]
pub use io::{read, write};

#[cfg(all(test, feature = "io"))]
mod tests {
    use crate::{ClientMsg, TxId};

    #[tokio::test]
    async fn stream_roundtrip() {
        let (mut a, mut b) = tokio::io::duplex(1024);
        super::write(&mut a, &ClientMsg::StopTransmission { tx: TxId(5) })
            .await
            .unwrap();
        super::write(&mut a, &ClientMsg::Ping { nonce: 9 })
            .await
            .unwrap();
        drop(a);
        let m1: Option<ClientMsg> = super::read(&mut b).await.unwrap();
        let m2: Option<ClientMsg> = super::read(&mut b).await.unwrap();
        let m3: Option<ClientMsg> = super::read(&mut b).await.unwrap();
        assert_eq!(m1, Some(ClientMsg::StopTransmission { tx: TxId(5) }));
        assert_eq!(m2, Some(ClientMsg::Ping { nonce: 9 }));
        assert_eq!(m3, None);
    }

    #[tokio::test]
    async fn rejects_oversized_length() {
        use tokio::io::AsyncWriteExt;
        let (mut a, mut b) = tokio::io::duplex(64);
        a.write_all(&u32::MAX.to_le_bytes()).await.unwrap();
        let r: Result<Option<ClientMsg>, _> = super::read(&mut b).await;
        assert!(matches!(r, Err(super::FrameError::TooLarge(_))));
    }
}
