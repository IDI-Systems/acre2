#include "script_component.hpp"
/*
 * Author: mharis001
 * Sets the voice curve level based on the given volume level.
 * Used to convert between the level displayed by the volume control and the actual voice level used.
 * Handles a custom voice curve being defined by the ACRE_CustomVolumeControl function.
 *
 * Arguments:
 * 0: Volume Level (0..1) <NUMBER>
 *
 * Return Value:
 * Voice Level <NUMBER>
 *
 * Example:
 * [0.5] call acre_sys_gui_fnc_setVoiceCurveLevel
 *
 * Public: No
 */

params ["_volumeLevel"];

private _voiceLevel = if (!isNil "ACRE_CustomVolumeControl" && {ACRE_CustomVolumeControl isEqualType {}}) then {
    [round linearConversion [0, 1, _volumeLevel, -2, 2, true]] call ACRE_CustomVolumeControl // custom curve, BWC for old volume levels [-2, -1, 0, 1, 2]
} else {
    linearConversion [0, 1, _volumeLevel, 0.1, 1.3, true] // default voice curve
};

if (_voiceLevel != call EFUNC(api,getSelectableVoiceCurve)) then {
    _voiceLevel call EFUNC(api,setSelectableVoiceCurve);
};

_voiceLevel
