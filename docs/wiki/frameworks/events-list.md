---
title: Events List
---

{% include important.html content="Following table lists only public API events!" %}

| Name  | Arguments | Type | Version |
| ----- |---------- | ---- | ------- |
| `acre_startedSpeaking`        | Unit <OBJECT>, On Radio <BOOL>, Radio ID <NUMBER>, Speaking Type <NUMBER> | Local | 2.7.0 |
| `acre_stoppedSpeaking`        | Unit <OBJECT>, On Radio <BOOL> | Local | 2.7.0 |
| `acre_remoteStartedSpeaking`  | Unit <OBJECT>, Speaking Type <NUMBER>, Radio ID <STRING> | Local | 2.7.2 |
| `acre_remoteStoppedSpeaking`  | Unit <OBJECT> | Local | 2.7.2 |
