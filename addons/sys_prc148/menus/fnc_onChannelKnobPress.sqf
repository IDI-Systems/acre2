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
 * [ARGUMENTS] call acre_sys_prc148_fnc_onChannelKnobPress
 *
 * Public: No
 */

private _dir = _this select 1;
if (_dir == 0) then {
    _dir = 1;
} else {
    if (_dir == 1) then {
        _dir = -1;
    };
};
private _group = GET_STATE("groups") select GET_STATE("currentGroup");
private _channelPositionOld = GET_STATE("channelKnobPosition");

private _channelPosition = _channelPositionOld + _dir;


if (_channelPosition > 15) then {
    _channelPosition = 15;
};
if (_channelPosition < 0) then {
    _channelPosition = 0;
};
if (_channelPositionOld != _channelPosition) then {
    ["Acre_GenericClick", [0, 0, 0], [0, 0, 0], 0.6, false] call EFUNC(sys_sounds,playSound);
    SET_STATE_CRIT("channelKnobPosition",_channelPosition);


    if (_channelPosition > (count (_group select 1))-1) then {
        _channelPosition = (count (_group select 1))-1;
    };
    private _channelNumber = (_group select 1) select _channelPosition;
    ["setCurrentChannel", _channelNumber] call GUI_DATA_EVENT;
    // if (GET_STATE("currentState") == "AlternateDisplay") then {
        // [GVAR(currentRadioId), "DefaultDisplay"] call FUNC(changeState);
    // };
    if (GET_STATE("editEntry")) then {
        SET_STATE("editEntry",false);
        SET_STATE("currentEditEntry","");
    };
    [GET_DISPLAY] call FUNC(render);
};
