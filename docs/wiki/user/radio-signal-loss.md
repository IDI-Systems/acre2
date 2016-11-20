---
title: Radio Signal Loss
---

ACRE2 seeks to provide a realistic fidelity when it comes to radio signal. The signal model is customisable and should able to fit the desired gameplay for most communities. See the 'Configuration' section below for further details.

The radio model in ACRE uses the terrain height map to calculate multiple possible pathways the radiowaves travel ( https://en.wikipedia.org/wiki/Multipath_propagation ). For performance reasons this is carried out with an extension and is not handled in SQF. Constructive and destructive interference from the multipath pathways is calculated.

Every radio also has its own transmission power which determines the initial strength of the radiowave. Antennas also play an important role in determining the directional strength of radiowaves being sent and received ( https://en.wikipedia.org/wiki/Radiation_pattern ) and are modelled in ACRE. The frequency of a radiowave determines the wavelength and every antenna has its own properties for the ideal frequencies it can pick up. The strength of a radiowave is calculated by the receiving radio and if isn't strong enough you will either not hear it or may hear some distortion.

The antenna direction for infantry is simulated as being relative to the direction of their back. If radio antenna direction is not ignored (see below) this can be observed by having difficulties receiving transmissions from other players who are prone if you are standing and vice versa as the antennas will be out of alignment.

The radios in ACRE2 by default are setup to use maximum transmission power and the frequencies their antennas are best suited for.

Note: In the present simulation model buildings and terrain objects do not effect radio signals due to technical limitations but this may change in future versions of ACRE2.

## Configuration

These can be setup either by placing the ACRE2 difficulty module in the mission or by using the API functions.

### Terrain Loss

This setting effects the signal loss that occurs due to terrain. In the module this can be enabled or disabled. The API functions can be used to change the simulation model on the fly and only effect the local client.

*Default value*: Enabled (1)

API function example:
`[0.0] call acre_api_fnc_setLossModelScale;`

The API function accepted values between 0 and 1. 1 represents enabled, 0 represents disabled. Intermediate values between 0 and 1 provide a allow a form of interpolation.

### Interference

Multiple transmissions on the same frequency can be destructive this setting allows you disable that interference allowing you to hear multiple speakers on the same frequency at once. Otherwise you will hear destructive interference if multiple people are transmitting on the same frequency (if both transmissions are received and one does not dominate the other).

Default value: Enabled (`true`)

API function example:
`[false] call acre_api_fnc_setInterference;`

`false` will disable the interference.

### Full Duplex

This setting allows a radio to broadcast and receive transmissions at the same time. Allowing you to hear others speaker on the same frequency as you talk. It is recommended to disable interference if you enable full duplex.

Default value: Disabled (`false`)

API function example:
`[true] call acre_api_fnc_setFullDuplex;`

`true` enables the full duplex mode.

###  Ignore Antenna direction (New setting to be introduced in v2.2.0)

This setting can be used to disable the simulation of antenna radiation patterns for both the transmitting and receiving radios. It will make all antennas act with perfect omni-directional behaviour.

Default value: Disabled (`false`) (Antenna direction is taken into account)

API function example:
`[true] call acre_api_fnc_ignoreAntennaDirection;`

`true` enables is used to ignore the antenna direction.
