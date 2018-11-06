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
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
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
    private _line2 = [ACRE_ACTIVE_RADIO, "getChannelDescription"] call EFUNC(sys_data,dataEvent);
    ACRE_BROADCASTING_NOTIFICATION_LAYER = [format ["TX: %1", _typeName], _line2, "", -1, [ACRE_NOTIFICATION_YELLOW]] call EFUNC(sys_list,displayHint);
};
true
