//! Voice datagrams. Fixed little-endian headers followed by one Opus packet.
//!
//! ```text
//! client → server:  [tx: u16][seq: u16][flags: u8][opus…]
//! server → client:  [speaker: u32][tx: u16][seq: u16][flags: u8][opus…]
//! ```

use bytes::{BufMut, Bytes, BytesMut};

use crate::{PeerId, TxId};

/// Header length of a [`ClientVoice`] datagram.
pub const CLIENT_HEADER_LEN: usize = 5;
/// Header length of a [`ServerVoice`] datagram.
pub const SERVER_HEADER_LEN: usize = 9;

/// Flag bits.
pub mod flags {
    /// Last frame of a talk spurt (speech paused or PTT released). Lets the receiver flush its
    /// jitter buffer instead of waiting for more frames.
    pub const END_OF_SPURT: u8 = 0b0000_0001;
}

#[derive(Debug, thiserror::Error, PartialEq, Eq)]
#[error("voice datagram too short: {0} bytes")]
pub struct TooShort(pub usize);

/// A voice frame sent by a speaker.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ClientVoice {
    pub tx: TxId,
    pub seq: u16,
    pub flags: u8,
    pub payload: Bytes,
}

impl ClientVoice {
    #[must_use]
    pub fn encode(&self) -> Bytes {
        let mut b = BytesMut::with_capacity(CLIENT_HEADER_LEN + self.payload.len());
        b.put_u16_le(self.tx.0);
        b.put_u16_le(self.seq);
        b.put_u8(self.flags);
        b.put_slice(&self.payload);
        b.freeze()
    }

    /// Decodes without copying the payload.
    pub fn decode(mut data: Bytes) -> Result<Self, TooShort> {
        if data.len() < CLIENT_HEADER_LEN {
            return Err(TooShort(data.len()));
        }
        let payload = data.split_off(CLIENT_HEADER_LEN);
        Ok(Self {
            tx: TxId(u16::from_le_bytes([data[0], data[1]])),
            seq: u16::from_le_bytes([data[2], data[3]]),
            flags: data[4],
            payload,
        })
    }

    /// The datagram the server forwards to recipients.
    #[must_use]
    pub fn forward(&self, speaker: PeerId) -> ServerVoice {
        ServerVoice {
            speaker,
            tx: self.tx,
            seq: self.seq,
            flags: self.flags,
            payload: self.payload.clone(),
        }
    }
}

/// A voice frame forwarded by the server.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ServerVoice {
    pub speaker: PeerId,
    pub tx: TxId,
    pub seq: u16,
    pub flags: u8,
    pub payload: Bytes,
}

impl ServerVoice {
    #[must_use]
    pub fn encode(&self) -> Bytes {
        let mut b = BytesMut::with_capacity(SERVER_HEADER_LEN + self.payload.len());
        b.put_u32_le(self.speaker.0);
        b.put_u16_le(self.tx.0);
        b.put_u16_le(self.seq);
        b.put_u8(self.flags);
        b.put_slice(&self.payload);
        b.freeze()
    }

    /// Decodes without copying the payload.
    pub fn decode(mut data: Bytes) -> Result<Self, TooShort> {
        if data.len() < SERVER_HEADER_LEN {
            return Err(TooShort(data.len()));
        }
        let payload = data.split_off(SERVER_HEADER_LEN);
        Ok(Self {
            speaker: PeerId(u32::from_le_bytes([data[0], data[1], data[2], data[3]])),
            tx: TxId(u16::from_le_bytes([data[4], data[5]])),
            seq: u16::from_le_bytes([data[6], data[7]]),
            flags: data[8],
            payload,
        })
    }

    #[must_use]
    pub fn end_of_spurt(&self) -> bool {
        self.flags & flags::END_OF_SPURT != 0
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn client_roundtrip_and_forward() {
        let v = ClientVoice {
            tx: TxId(0x1234),
            seq: 0xfffe,
            flags: flags::END_OF_SPURT,
            payload: Bytes::from_static(b"opus"),
        };
        let enc = v.encode();
        assert_eq!(enc.len(), CLIENT_HEADER_LEN + 4);
        let dec = ClientVoice::decode(enc).unwrap();
        assert_eq!(dec, v);

        let fwd = dec.forward(PeerId(42));
        let back = ServerVoice::decode(fwd.encode()).unwrap();
        assert_eq!(back.speaker, PeerId(42));
        assert_eq!(back.tx, v.tx);
        assert_eq!(back.seq, v.seq);
        assert!(back.end_of_spurt());
        assert_eq!(&back.payload[..], b"opus");
    }

    #[test]
    fn too_short() {
        assert_eq!(
            ClientVoice::decode(Bytes::from_static(&[1, 2, 3])),
            Err(TooShort(3))
        );
        assert_eq!(
            ServerVoice::decode(Bytes::from_static(&[0; 8])),
            Err(TooShort(8))
        );
    }

    #[test]
    fn empty_payload_is_valid() {
        let d = ClientVoice::decode(Bytes::from_static(&[0; CLIENT_HEADER_LEN])).unwrap();
        assert!(d.payload.is_empty());
    }
}
