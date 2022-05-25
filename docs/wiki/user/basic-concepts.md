---
title: Basic Concepts
---

## Half-duplex radios

All the radios currently included in ACRE 2 are what is commonly known as half-duplex radios. This means that they can only transmit **or** receive at any given time. In practice, this means that if you are transmitting on a radio, you cannot hear anyone else.

If there are multiple speakers on the same frequency, they will interfere with eachother in such a way that you will only receive the strongest (usually closest) speaker.

Half-duplex limitations can be turned off in missions by using the [Full Duplex](http://acre2.idi-systems.com/wiki/user/radio-signal-loss#full-duplex) and [Interference](http://acre2.idi-systems.com/wiki/user/radio-signal-loss#interference) CBA Settings.

### Radios

| Radio Name    | Strength | City Range | Perfect Range |
| ------------- | -------- | ---------- | ------------- |
| AN/PRC-343    | 100 mW   | 400 m      | 850 m         |
| AN/PRC-148    | 5 W      | 3-5 km     | 5-7 km        |
| AN/PRC-152(c) | 5 W      | 3-5 km     | 5-7 km        |
| AN/PRC-117F   | 20 W     | 10-20 km   | Horizon       |
| AN/PRC-77     | 4 W      | 1-3 km     | 3-5 km        |
| SEM 52 SL     | 1 W      | 1-2 km     | 2-4 km        |
| SEM 70        | 4 W      | 1-3 km     | 3-5 km        |
| BF-888S       | 5 W      | 2-4 km     | 4-6 km        |

_Classes can be found on the [Class Names](/wiki/class-names) page._

## Terrain and object interference

ACRE 2 realistically traces a signal path from the transmitting radio to any potential receivers. At the frequencies used on the currently available radios (VHF to UHF, 30 to 3000 megahertz), the radio waves act mostly like light, in the sense that they are blocked or attenuated by objects and the ground.

Unlike light these radio waves can still penetrate things like walls to some extent, but they will lose power and the range of the radio will be reduced. This might not affect a speaker if he is in a lone building in otherwise open terrain, but it will reduce signal strength and range inside a city or built-up area.

Terrain will outright block VHF and UHF signals. Some waves can bleed through via scattering and reflection, but generally radios on these bands are considered to be Line of Sight (LOS) radios as far as terrain is concerned.

The amount the signal is attenuated by objects and terrain can be reduced or removed using the [Loss Model Scale](http://acre2.idi-systems.com/wiki/user/radio-signal-loss#terrain-loss) CBA Setting.

### Antennas

Following table shows a list of all antennas implemented in ACRE2. Currently, antennas cannot be swapped on the devices, default attached antennas are marked in bold.

Each antenna has a gain pattern (visualized in linked video), which is the signal pattern of the antenna over the supported range of frequencies. Gain patterns can be used to determine best frequencies to use in specific conditions with a given antenna. This is only relevant if using directional antennas (Ignore Antenna Direction setting disabled).

| Antenna Name | Type | Compatible Devices |
| ------------ | ---- | ------------------ |
| 1M VHF TNC | TNC | **AN/PRC-148**, **AN/PRC-152** |
| 1M VHF BNC | BNC | AN/PRC-148, AN/PRC-152 |
| [2.5 INCH UHF PRC343](https://www.youtube.com/watch?v=UZQZ23aorg4) | TNC | **AN/PRC-343** |
| [0.4M SEM52/SEM70](https://www.youtube.com/watch?v=9K7nYbC4tD8) | BNC | SEM 52 SL |
| [0.9M SEM52](https://www.youtube.com/watch?v=N72diKJHo5k) | BNC | **SEM 52 SL** |
| [1.03M SEM70](https://www.youtube.com/watch?v=t3YMP7XuIwM) | BNC | **SEM 70** |
| [AT-271 PRC-77](https://www.youtube.com/watch?v=v0EGHoT7XGA) | 3/8" | **AN/PRC-77** |
| [1.23M VHF TNC](https://www.youtube.com/watch?v=a-ydqMUjAMY) | TNC | **AN/PRC-117F** |
| [2.7M MB VEH BNC](https://www.youtube.com/watch?v=zALwqsWz7Wk) | BNC | **AN/VRC-103**, **AN/VRC-110**, **AN/VRC-111** |
| [FA80 VEH BNC](https://www.youtube.com/watch?v=rubFrJwYhgg) | BNC | **SEM90** |
| [AS-1729/VRC](https://www.youtube.com/watch?v=3G_87lPpEMM) | 3/8" | **AN/VRC-64** |
| [2.43M Ground Spike](https://www.youtube.com/watch?v=GDZLo0TkZyI) | TNC | AN/PRC-148, AN/PRC-152, AN/PRC-117F, AN/PRC-77, SEM 70 |
| [6.43M Ground Spike](https://www.youtube.com/watch?v=0gCv0mSm5-w) | TNC | AN/PRC-148, AN/PRC-152, AN/PRC-117F, AN/PRC-77, SEM 70 |
| 22CM NA-701 | SMA | **BF-888S** |

_Classes can be found on the [Class Names](/wiki/class-names) page._
