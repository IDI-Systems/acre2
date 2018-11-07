---
title: Basic Concepts
---

## Radios and Classes

| Radio Name    | Radio Classname | Strength | City Range | Perfect Range |
| ------------- | --------------- | -------- | ---------- | ------------- |
| AN/PRC-343    | ACRE_PRC343     | 100mW    | 400m       | 850m          |
| AN/PRC-148    | ACRE_PRC148     | 5W       | 3-5km      | 5-7km         |
| AN/PRC-152(c) | ACRE_PRC152     | 5W       | 3-5km      | 5-7km         |
| AN/PRC-117F   | ACRE_PRC117F    | 20W      | 10-20km    | Horizon       |
| AN/PRC-77     | ACRE_PRC77      | 4W       | 1-3km      | 3-5km         |


## Half-duplex radios

All the radios currently included in ACRE 2 are what is commonly known as half-duplex radios. This means that they can only transmit **or** receive at any given time. In practice, this means that if you are transmitting on a radio, you cannot hear anyone else.

If there are multiple speakers on the same frequency, they will interfere with eachother in such a way that you will only receive the strongest (usually closest) speaker.

Half-duplex limitations can be turned off in missions by using the [Full Duplex](http://acre2.idi-systems.com/wiki/user/radio-signal-loss#full-duplex) and [Interference](http://acre2.idi-systems.com/wiki/user/radio-signal-loss#interference) CBA Settings.

## Terrain and object interference

ACRE 2 realistically traces a signal path from the transmitting radio to any potential receivers. At the frequencies used on the currently available radios (VHF to UHF, 30 to 3000 megahertz), the radio waves act mostly like light, in the sense that they are blocked or attenuated by objects and the ground.

Unlike light these radio waves can still penetrate things like walls to some extent, but they will lose power and the range of the radio will be reduced. This might not affect a speaker if he is in a lone building in otherwise open terrain, but it will reduce signal strength and range inside a city or built-up area.

Terrain will outright block VHF and UHF signals. Some waves can bleed through via scattering and reflection, but generally radios on these bands are considered to be Line of Sight (LOS) radios as far as terrain is concerned.

The amount the signal is attenuated by objects and terrain can be reduced or removed using the [Loss Model Scale](http://acre2.idi-systems.com/wiki/user/radio-signal-loss#terrain-loss) CBA Setting.
