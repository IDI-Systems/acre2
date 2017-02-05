/*
 * Author: ACRE2Team
 * Handles the reciept of a stop garbage collect message.
 *
 * Arguments:
 * 0: Player <OBJECT>
 * 1: Radio ID <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [acre_player,"acre_prc152_id_1"] call acre_sys_server_fnc_stopRadioGarbageCollect
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_player", "_radioId"];

if (HASH_HASKEY(GVAR(markedForGC),_radioId)) then {
    private _value = HASH_GET(GVAR(markedForGC),_radioId);
    _value params ["_timeMessage","_timeGC","_object"];
    if (time < _timeGC + 15) then {
        WARNING_2("Desync - Garbage collection prevented for radio '%1' from player '%2' as it still exists for them locally!",_radioId,name _player);
    };
    _timeMessage = time;
    _value = [_timeMessage,_timeGC,_player];
    HASH_SET(GVAR(markedForGC),_radioId,_value);
} else {
    ERROR_2("Desync - Received an unexpected invalid stop garbage collect message radio for '%1' from player '%2'!",_radioId,name _player);
};
