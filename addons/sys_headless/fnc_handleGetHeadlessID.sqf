#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Get the alive player units matching the current channel. If global chat, all units are targeted.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * ["1:2", "Botty", 499] call acre_sys_headless_fnc_handleGetHeadlessID
 *
 * Public: No
 */

params [["_netId","",[""]],["_targetName","",[""]],["_targetID","0",[""]]];
TRACE_3("handleGetHeadlessID",_netId,_targetName,_targetID);

private _unit = objectFromNetId _netId;
if (isNull _unit) exitWith {
    WARNING_1("null unit %1",_this);
};
_targetID = parseNumber _targetID;
if (_targetID == 0) then {
    WARNING_2("Cannot find TSID - Headless Unit [%1] DisplayName [%2]",_unit,_tsDisplayName);
};

_unit setVariable [QGVAR(virtualID), _targetID];
