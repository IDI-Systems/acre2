---
title: Spectator Displays
---

## Overview

The ACRE2 spectator displays framework allows users to easily integrate ACRE spectator radios functionality into their spectator systems.

It provides a radio list control that allows spectators to select which radios to listen in on. In addition, there is a speaking control that displays the unit and channel names for spectator radio transmissions.

## Implementation

Integrating the above functionality into custom spectator systems requires the `acre_sys_spectator_RscRadios` and `acre_sys_spectator_RscSpeaking` controls to be added to the display. This can be done either through config or through scripting when the display is initialized.

The `acre_sys_spectator_RscRadios` control should be added to the spectator display's focus info widget that shows information about the currently selected unit. The `acre_sys_spectator_RscSpeaking` control should be positioned in the top-right of the display.

Next, the `acre_sys_spectator_fnc_initDisplay` function must be called to initialize the controls. This function adds the handling necessary for updating the controls as well as adding support for the "Clear Spectator Radios" keybind. The arguments for this function are as follows:

\#   | Description | Type
:---: | ----------- | ----
0 | Spectator Display | DISPLAY
1 | Target Function | CODE
2 | Visible Function | CODE

The Target Function must return an `OBJECT` which is the currently focused entity, `objNull` if there is none. The Visible Function must return a `BOOL` that is `true` if the interface is currently visible.

## Example

This section showcases how spectator radios support is added by ACRE2 to [BI's EG Spectator](https://community.bistudio.com/wiki/Arma_3_End_Game_Spectator_Mode).

**Adding the Controls:**

Since the EG Spectator is the default spectator system for Arma 3, the default values for the controls are setup best for it. While most spectator displays have similar characteristics, you may need to adjust values such as control positioning to best suit your display.

```cpp
class RscDisplayEGSpectator {
    class Controls {
        class FocusInfo: RscControlsGroupNoScrollbars {
            y = POS_Y(21);
            h = POS_H(7.1);
            class controls {
                class acre_sys_spectator_radios: acre_sys_spectator_RscRadios {};
            };
        };
        class acre_sys_spectator_speaking: acre_sys_spectator_RscSpeaking {};
    };
};
```

**Calling the Initialization Function:**

```js
[
    _display,
    {uiNamespace getVariable ["RscEGSpectator_focus", objNull]},
    {uiNamespace getVariable ["RscEGSpectator_interfaceVisible", true]}
] call acre_sys_spectator_fnc_initDisplay;
```
