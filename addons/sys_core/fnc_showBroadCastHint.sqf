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

if !(([] call EFUNC(sys_data,getPlayerRadioList)) isEqualTo []) then {
    private _radioRack = [ACRE_ACTIVE_RADIO] call EFUNC(sys_rack,getRackFromRadio);
    private _realRadio = if (_radioRack == "") then {
        [ACRE_ACTIVE_RADIO] call EFUNC(sys_radio,getRadioBaseClassname);
    } else {
        [_radioRack] call EFUNC(sys_rack,getRackBaseClassname);
    };
    private _typeName = getText (configFile >> "CfgAcreComponents" >> _realRadio >> "name");
    private _line1 = [ACRE_ACTIVE_RADIO, "getChannelDescription"] call EFUNC(sys_data,dataEvent);
    private _line2 = ["L", "C", "R"] select ([ACRE_ACTIVE_RADIO, "getSpatial"] call EFUNC(sys_data,dataEvent)) + 1;
    private _hintColor = EGVAR(sys_list,transmissionColor);
    if (EGVAR(sys_list,showPttColors)) then {
        if (ACRE_ACTIVE_PTTKEY == 0) then { //PTT1
            _hintColor = EGVAR(sys_list,ptt1Color);
        } else if (ACRE_ACTIVE_PTTKEY == 1) then { //PTT2
            _hintColor = EGVAR(sys_list,ptt2Color);
        } else if (ACRE_ACTIVE_PTTKEY == 2) then { //PTT3
            _hintColor = EGVAR(sys_list,ptt3Color);
        };
    };
    ACRE_BROADCASTING_NOTIFICATION_LAYER = [format ["TX: %1", _typeName], _line1, _line2, -1, _hintColor] call EFUNC(sys_list,displayHint);

};
true
