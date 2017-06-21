---
title: Babel
---

The Babel System uses a local API system that must be executed on all clients equally except for where the definition of a individual persons language is concerned, which can differ between clients. Language IDs are sent during the start of speaking events, with non-timely updates applied if a person changes languages in the middle of a conversation. It is imperative that languages be added in the same order on all machines, including JIP, otherwise the numerical values sent during speaking events will not match their literal values on the client. It is best to avoid manipulating the list of languages available after mission init or JIP init.
