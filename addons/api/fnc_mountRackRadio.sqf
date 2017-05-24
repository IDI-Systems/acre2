/*
 * Author: ACRE2Team
 * Sets the given radio as mounted.
 *
 * Arguments:
 * 0: Rack ID <STRING>
 * 1: Radio to mount <STRING>
 * 2: Unit with radio to mount <OBJECT>
 *
 * Return Value:
 * Setup successful <BOOL>
 *
 * Example:
 * ["ACRE_VRC103_ID_1", "ACRE_PRC117F_ID_1", acre_player] call acre_api_fnc_mountRackRadio
 *
 * Public: Yes
 */
#include "script_component.hpp"

params [["_rackId", ""], ["_radioId", ""], ["_unit", objNull]];

private _return = false;

if (!([_rackId] call EFUNC(sys_radio,radioExists))) exitWith {
    WARNING_1("Non existant rack ID provided: %1",_rackId);
    _return
};

if (!([_radioId] call EFUNC(sys_radio,radioExists))) exitWith {
    WARNING_1("Non existant radio ID provided: %1",_radioId);
    _return
};

if (isNull _unit) exitWith {
    WARNING("Null unit passed as argument.");
    _return
};

if ([_rackId] call FUNC(getMountedRackRadio) != "") exitWith {
     WARNING_1("Rack ID %1 has already a radio mounted.",_rackId);
     _return
};

if (_radioId in ([_rackId, [_radioId]] call EFUNC(sys_rack,getMountableRadios))) then {
    [_rackId, _radioId, _unit] call EFUNC(sys_rack,mountRadio);
    _return = true;
} else {
    WARNING_2("Cannot mount %1 into %2.",_radioId,_rackId);
    _return
};

_return
