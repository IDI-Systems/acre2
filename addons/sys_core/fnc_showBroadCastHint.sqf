#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Shows the transmitting hint. Intended for use when transmitting.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [] call acre_sys_core_fnc_showBroadCastHint
 *
 * Public: No
 */

if (([] call EFUNC(sys_data,getPlayerRadioList)) isNotEqualTo []) then {
    private _radioRack = [ACRE_ACTIVE_RADIO] call EFUNC(sys_rack,getRackFromRadio);
    private _realRadio = if (_radioRack == "") then {
        [ACRE_ACTIVE_RADIO] call EFUNC(sys_radio,getRadioBaseClassname);
    } else {
        [_radioRack] call EFUNC(sys_rack,getRackBaseClassname);
    };
    private _typeName = getText (configFile >> "CfgAcreComponents" >> _realRadio >> "name");
    private _line1 = [ACRE_ACTIVE_RADIO, "getChannelDescription"] call EFUNC(sys_data,dataEvent);
    private _line2 = ["L", "C", "R"] select ([ACRE_ACTIVE_RADIO, "getSpatial"] call EFUNC(sys_data,dataEvent)) + 1;
    private _hintColor = EGVAR(sys_list,DefaultPTTColor);
    switch (ACRE_ACTIVE_PTTKEY) do {
        case 0: {_hintColor = EGVAR(sys_list,PTT1Color)};
        case 1: {_hintColor = EGVAR(sys_list,PTT2Color)};
        case 2: {_hintColor = EGVAR(sys_list,PTT3Color)};
        default {_hintColor = EGVAR(sys_list,DefaultPTTColor)};
    };

    [
        "acre_broadcast",
        format ["TX: %1", _typeName],
        _line1,
        _line2,
        -1,
        _hintColor
    ] call EFUNC(sys_list,displayHint);
};

true
