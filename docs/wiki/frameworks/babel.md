
---
title: Babel
---

## Overview

ACRE2 introduces an exciting new voice feature for adversarial and cooperative play in the Babel System. This system allows mission makers to define a set of "languages" for players and assign players individually, however you choose, which languages from that set they speak, from one language to multiple languages. If a player speaks a language that another player doesn’t understand the voice of that speaker will be transformed into an unintelligible sound, but one that still retains the elements of language, such as inflection, tone of voice, and cadence of speech. If you speak multiple languages you are able to switch between which language you are speaking in, and will hear people speaking any of the languages you understand unaffected by the Babel System.

For adversarial play this allows you to hide all enemy communications from understanding unless there is someone defined as speaking that language. For cooperative play the use of interpreters between multiple language groups becomes essential, adding a new dynamic to the play experience.

The Babel System and API is present as of the ACRE2 Alpha build number 509. All functions are part of the standard mission maker API and are listed below.

## Concepts

The Babel System uses a local API system that must be executed on all clients equally except for where the definition of a individual persons language is concerned, which can differ between clients. Language IDs are sent during the start of speaking events, with non-timely updates applied if a person changes languages in the middle of a conversation. It is imperative that languages be added in the same order on all machines, including JIP, otherwise the numerical values sent during speaking events will not match their literal values on the client. It is best to avoid manipulating the list of languages available after mission init or JIP init.
