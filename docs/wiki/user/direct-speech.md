---
title: Direct Speech
---

ACRE2's direct speech simulates speech coming from a player's mouth and be heard by players around them. If you broadcast on the radio you will also be heard by other players within range of you.

## Direct speech slider

ACRE2 has a built in direct speech slider allowing you to determine how far your voice in direct speech should travel. The system has five states and by default starts in the middle state. The below table contains an approximated table with empirical testing by Bullhorn.

| Volume state | Loud (m)| Quiet (m)| Barely audible (m)|
| -------- | -------- | -------- | -------- |
| 1/5 | 1 | 2 | 13 |
| 2/5 | 3 | 15 | 55 |
| 3/5 | 8 | 30 | 100 |
| 4/5 | 12 | 45 | 145 |
| 5/5 | 15 | 55 | 195 |

### Changing the volume state

Simply hold your volume modifier key (default: TAB) and use your scroll wheel to move the slider. The bigger the slider gets (scroll up) the further your voice will go. The smaller the slider gets (scroll down) the shorter your voice will travel.

## Object occlusion

Voice occlusion will occur if there is direct path for another player's voice to be heard. There is a system which will reduce the volume of other players that are behind objects or in buildings they will close across as quieter.

## Vehicle attenuation

Vehicle attenuation is the system where people outside and inside of a vehicle may hear each other at reduced volumes. This is particularly noticeable in armoured vehicles but generally isn't in effect in open seats. This is can be different for each seat in the vehicle. Turning out of the vehicle will also reduce this effect. Generally firing from vehicles positions, helicopter door gunners) will have this effect weakened too. This should generally work well with most vehicles from mods.

For technical details for addon makers see [vehicle attenuation configuration](/wiki/frameworks/vehicle-attenuation).
