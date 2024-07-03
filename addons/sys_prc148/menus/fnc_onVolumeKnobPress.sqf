#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_sys_prc148_fnc_onVolumeKnobPress
 *
 * Public: No
 */

#define RADIO_CTRL(var1) (MAIN_DISPLAY displayCtrl var1)

private _dir = -0.20;
if ((_this select 1) == 0) then {
    _dir = 0.20;
};
private _ctrl = _this select 5;
private _currentVolume = GET_STATE("volume");     //I am not using the API for getting the volume because that could
                                        //be different from what the internal value is based on the speaker
                                        //the API value should be used as a modifier coefficient, not as a
                                        //state.

private _newVolume = _currentVolume + _dir;
if (_newVolume < 0) then {
    _newVolume = 0.0;
};
if (_newVolume > 1) then {
    _newVolume = 1.0;
};
// acre_player sideChat format["NEW VOL: %1", _newVolume];
if (_currentVolume != _newVolume) then {
    if (_newVolume >= 0.2) then {
        ["Acre_GenericClick", [0, 0, 0], [0, 0, 0], _newVolume^3, false] call EFUNC(sys_sounds,playSound);
        ["setVolume", _newVolume] call GUI_DATA_EVENT;
        RADIO_CTRL(12010+201) ctrlSetTooltip format ["%1: %2%3", LELSTRING(sys_radio,ui_CurrentVolume),round (_newVolume*100), "%"];
    };
    if (_newVolume < 0.2 /*&& _ctrl*/) then {
        ["setVolume", 0] call GUI_DATA_EVENT;
        ["setOnOffState", 0] call GUI_DATA_EVENT;
        RADIO_CTRL(12010+201) ctrlSetTooltip LELSTRING(sys_radio,ui_Radiooff);
    } else {
        if (_newVolume > 0 && _currentVolume < 0.2) then {
            //acre_player sideChat "STARTING RADIO!";
            ["setOnOffState", 0.5] call GUI_DATA_EVENT;
            [GVAR(currentRadioId), FUNC(PostScreen_End), 3] call FUNC(delayFunction);
        };
    };
    [GET_DISPLAY] call FUNC(render);
};
