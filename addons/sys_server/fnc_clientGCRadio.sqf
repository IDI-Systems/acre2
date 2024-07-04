#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Garbage collects a radio locally. This will delete its data.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["acre_prc343_id_1"] call acre_sys_server_fnc_clientGCRadio
 *
 * Public: No
 */

params ["_radioId"];

private _radioList = ([] call EFUNC(sys_data,getPlayerRadioList)) apply {toLower _x};

if ((toLower _radioId) in _radioList) then {
    private _message = format ["Your radio '%1' is being garbage collected. The server believes you do not have this radio.",_radioId];
    // systemChat format ["[ACRE2] %1", _message];
    ERROR(_message);

    [QGVAR(invalidGarbageCollect), [profileName, _radioId]] call CALLSTACK(CBA_fnc_serverEvent);
};

HASH_SET(EGVAR(sys_data,radioData),_radioId,nil);
if (HASH_HASKEY(EGVAR(sys_data,radioScratchData),_radioId)) then {
    HASH_REM(EGVAR(sys_data,radioScratchData),_radioId);
};
HASH_REM(GVAR(objectIdRelationTable),_radioId);
