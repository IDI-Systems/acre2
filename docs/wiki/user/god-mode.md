---
title: God Mode
---

{% include important.html content="Dev-build only" %}

ACRE2 offers the possibility of sending voice and text messages to groups of players without attenuation effects. This functionality is known as God Mode and consists of:

- Integration with Arma 3 Chat Channel: when pressing the corresponding Push-To-Talk (PTT), a voice message is going to be sent to those players matching the criteria of the current chat channel. _Note: Custom chat channels are not supported. Custom, Direct and Command all behave same as Global.
- Group presets: up to three configurable group presets that can be accessed through their respective PTTs. When pressing it, a voice message without attenuation is going to be sent to those players, including dead ones. The group presets can be modified through the API.
- Sending a text message to group presets.

By default, Administrators and players in Zeus can access God Mode functionality. Its access can be further customized through the API.

For technical details for addon makers see [God Mode configuration](/wiki/frameworks/god-mode).
