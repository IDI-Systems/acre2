---
title: Radio Signal Loss
---

ACRE2 seeks to provide a realistic fidelity when it comes to radio signal. The signal model is customisable and should able to fit the desired gameplay for most communities. See the 'Configuration' section below for further details.

The radio model in ACRE uses the terrain height map to calculate [multiple possible pathways the radiowaves travel](https://en.wikipedia.org/wiki/Multipath_propagation). For performance reasons this is carried out with an extension and is not handled in SQF. Constructive and destructive interference from the multipath pathways is calculated.

Every radio also has its own transmission power which determines the initial strength of the radiowave. Antennas also play an important role in determining the [directional strength of radiowaves being sent and received](https://en.wikipedia.org/wiki/Radiation_pattern) and are modelled in ACRE. The frequency of a radiowave determines the wavelength and every antenna has its own properties for the ideal frequencies it can pick up. The strength of a radiowave is calculated by the receiving radio and if isn't strong enough you will either not hear it or may hear some distortion.

The antenna direction for infantry is simulated as being relative to the direction of their back. If radio antenna direction is not ignored (see below) this can be observed by having difficulties receiving transmissions from other players who are prone if you are standing and vice versa as the antennas will be out of alignment.

(Only in Dev-Build): However it is possible to manually align the antenna by bending it in order to improve signal quality. To keep it as simple as possible, there are only two possible antenna alignments, the player can choose between the two via ACE Interaction Menu or Custom Keybind (default: `CTRL+ALT+UP`). In addition to the manual method, there is always the possibility to activate an automatic antenna alignment via CBA Settings (see below). The current alignment of the antenna is shown in the Arma 3 Stance Indicator. 

{% include image.html file="user/antenna_indicator.png" alt="Antenna Alignment shown in Stance Indicator" %}


The radios in ACRE2 by default are setup to use maximum transmission power and the frequencies their antennas are best suited for.

Note: In the present simulation model buildings and terrain objects do not effect radio signals due to technical limitations but this may change in future versions of ACRE2.

## Configuration

These can be setup via [CBA Settings](https://github.com/CBATeam/CBA_A3/wiki/CBA-Settings-System).

### Terrain Loss

This setting effects the signal loss that occurs due to terrain. The CBA Setting can be used to change the simulation model on the fly.

Default value: Enabled (0.5)

### Interference

Multiple transmissions on the same frequency can be destructive this setting allows you disable that interference allowing you to hear multiple speakers on the same frequency at once. Otherwise you will hear destructive interference if multiple people are transmitting on the same frequency (if both transmissions are received and one does not dominate the other).

Default value: Enabled

### Full Duplex

This setting allows a radio to broadcast and receive transmissions at the same time. Allowing you to hear others speaker on the same frequency as you talk. It is recommended to disable interference if you enable full duplex.

Default value: Disabled

### Ignore Antenna direction (introduced in v2.2.0)

This setting can be used to disable the simulation of antenna radiation patterns for both the transmitting and receiving radios. It will make all antennas act with perfect omni-directional behaviour.

Default value: Disabled (antenna direction is taken into account)

###  Automatic Antenna direction

{% include note.html content="Development Build only!" %}

This setting enables an automatic antenna alignment to improve signal strength e.g. when being prone. 

Default value: Disabled (antenna needs to be aligned manually)

Note: _If the antenna direction is ignored, this setting will have no effect._
