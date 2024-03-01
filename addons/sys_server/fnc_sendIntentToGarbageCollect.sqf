#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sends the intent to collect event to clients from the server.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["acre_prc343_id_1"] call acre_sys_server_fnc_sendIntentToGarbageCollect
 *
 * Public: No
 */

params ["_radioId"];

_radioId = toLower _radioId;

private _object = objNull;
private _idTableEntry = HASH_GET(GVAR(masterIdTable),_radioId);
if (!isNil "_idTableEntry") then { _object = _idTableEntry select 0; };

private _value = [-10, time, _object];

HASH_SET(GVAR(markedForGC),_radioId,_value);

[QGVAR(intentToGarbageCollect), [_radioId]] call CBA_fnc_globalEvent;
