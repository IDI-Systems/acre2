---
title: Creating New Radio
---

For best artwork results you should have your own textured model to create the in-game radio interface. To simplify things we'll assume you already have one and are able to render images of it.

In ACRE every radio object is treated as a unique object with its own settings (volume, channel frequencies etc). To a player this means if they pick up someone else's radio it will be in the exact same state the last player left it in (knob positions, selected channel, etc). As such every radio model has its own a data model behind it that is responsible for storing the settings. ACRE automatically syncs this data model of every radio between clients as long as you stick with the data model as described below.

The existing radios in ACRE should serve as good examples of what is possible. I would recommend getting loosely familiar with them. The SEM52SL and AN/PRC-343 in particular are fairly simple radios.


## Creating the data model

When a radio is given to a player it is 'initialized', this creates an instance of the radio model. Every radio type typically has a set of presets available to it, each of these typically store their own frequencies. When a radio is initialized, the channel data is set to that of the currently active preset by default, this is 'default' unless an API call is made (e.g. `["ACRE_PRC343","default2"] call acre_sys_api_fnc_setPreset`)

### Radio Presets

The radio presets typically store the channel settings. Typically there should always be 4 presets, ideally they should be set to be independent frequencies of each other so they can be used by different teams:

```
default - This is the default preset
default2 - Given to east side by modules
default3 - Given to west side by modules
default4 - Given to independent side by modules
```

Each of these is created in:
`RADIO/functions/fnc_presetInformation.sqf` - This files creates the radio presets.

### General radio settings

General radio settings (On state/Volume) are setup in the initialize radio function.
`radio/fnc_initializeRadio.sqf` - This file sets up the data.

### Getters/Setters

Most data states also have their own getters and setters these are typically setup in `radio/CfgAcreRadios.hpp` under `class interfaces`. In the radio framework template these are all already defined.
Some static data isn't initialized in the `presetInformation`/`initializeRadio` functions to save on the need. Below is a loosely annotated list on what most of these scripts are for.

```
getChannelData - Get the data for the specified channel
getChannelDescription - Get the information to display in the yellow and black broadcasting hint
getCurrentChannel - Get the channel number
getCurrentChannelData - Get data for the current channel
getExternalAudioPosition - Used for position of speaker
getListInfo - Get the information to display in the yellow and black broadcasting hint
getOnOffState - Is the radio on/off
getSpatial - Get the radio output mode: "LEFT", "CENTER" or "RIGHT"
getState - Generic get data function
getStates -
getVolume - Get the radio volume
isExternalAudio - Is the radio outputting as a speaker
setChannelData
setCurrentChannel
setOnOffState
setSpatial
setState
setVolume
handlePTTDown
handlePTTUp
handleSignalData
openGui
```

### Signal Processor

The following events are available for handling incoming signals. The `handleMultipleTransmission` is the most important and is used to determine which incoming radios can be heard. This is useful for implementing custom crypto.  

```
handleBeginTransmission
handlEndTransmission
handleMultipleTransmission
```

The sensitivity (minimum signal strength the radio can pick up) should also go in here as well. In the below code the sensitivity of the radio is -117, any signal with a strength less than it is discarded.
```
_squelch = -117 + HASH_GET(_channel,"squelch");
if(_signalDbM < _squelch) then {
```


## Components

ACRE2 also has a [component system](https://github.com/IDI-Systems/acre2/wiki/Component-System) where components can be added and removed from radios. Antennas are treated as components and must be setup in `radio/CfgAcreRadios.hpp`. Appropriate connectors must also be specified for the radio. Typically radios use either BNC or TNC connectors for the antennas. The components a radio starts with are determined in the `defaultComponents` property.

```
connectors[] = {
    {"Antenna", ACRE_CONNECTOR_BNC},
    {"Audio/Data", ACRE_CONNECTOR_U_283}
};
defaultComponents[] = {
    {0, "ACRE_120CM_VHF_BNC"} // Connector index, Component name
};
```

Antennas themselves are defined in the `sys_antennas` component of ACRE2. You can find the available antennas in the [sys_antennas\CfgAcreComponents.hpp](https://github.com/IDI-Systems/acre2/blob/master/addons/sys_antenna/CfgAcreComponents.hpp).


## Create the dialog config

The easiest approach for handling the artwork is to use a layer based system where all artwork is `.paa` files of size 2048x2048. Each control/knob should have its own set of textures with a texture for each state that will be rendered on top of a background image and alongside the other knobs/controls.

### Graphical parts

Typically `RADIOTYPE_RadioDialog.hpp` is used to define the radio dialog. A control should be defined for every graphical element that needs to be displayed and altered. All 'graphical' controls should be the same size and use the same positions/sizes in the config file. If you want to tweak the scale/size of the radio on screen tweak the `NEW_SCALE` macro. This is used to ensure compatibility with multi screen setups. Wide radios should be based off `safeZoneH` and Tall radios should be based off `safeZoneW` (for wide radios see the AN/PRC-117F or AN-PRC77 configs - for tall radios see the AN/PRC-343, AN/PRC-148 or AN/PRC-152 configs.

Typically this should follow this format:
```
BEGIN_CONTROL(CONTROL_GRAPHICAL_PART_NAME, RADIO_RscPicture, 300)
    x=safeZoneX + safeZoneW - NEW_SCALE * SafeZoneH - 1/16 * safeZoneW;
    y=SafeZoneY + SafeZoneH - NEW_SCALE * SafeZoneH + 2/8 * safeZoneW;
    w=NEW_SCALE * SafeZoneH;
    h=NEW_SCALE * SafeZoneH;
    text = "RADIO\data\knobs\CONTROL\PATH_TO_PAA.paa";
END_CONTROL
```

### Clickable controls

A config control should be defined for every clickable area/control but these should be separate of the graphical part of the control which will serve as a background. The clickable part should use a tool tip to indicate it is a clickable area. Typically each clickable control should also have its function script e.g. `fn_onCONTROLPress.sqf`.

```
BEGIN_CONTROL(CONTROL_CLICKABLE_PART_NAME, RADIO_RscButton, 201)
    x=((((0.416-0.543)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY; // This needs tweaking to the correct position
    y=((((0.595-0.5)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY; // This needs tweaking to the correct position
    w=(1.15/0.8)*0.050*SafeZoneH;
    h=(1.15/0.8)*0.050*SafeZoneH;
    text = ""; // This should always be blank
    onMouseButtonUp = QUOTE(_this call FUNC(onCONTROLPress));
    tooltip = "Change channel"; // Tool tip this text
END_CONTROL
```
