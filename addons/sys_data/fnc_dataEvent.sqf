#include "script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_data_fnc_dataEvent
 *
 * Public: No
 */

// _this = [radioId, eventType, data]
private _params = ["CfgAcreDataInterface"];
_params append _this;

//private _checkCache = false;
//private _event = "";
/*if ((count _this) == 3) then {
    _checkCache = false;
};*/

//_return = nil;
// if (_checkCache) then {
    // _event = (_this select 1);
    // _cache = missionNamespace getVariable ((_this select 0)+"dataCache");
    // if (!isNil "_cache") then {
        // _cachedIndex = (_cache select 0) find _event;
        // if (_cachedIndex != -1) then {
            // _return = (_cache select 1) select _cachedIndex;
        // };
    // };
// };
//if (!isNil "_return") exitWith { _return; };
private _return = _params call FUNC(acreEvent);

// if (_checkCache) then {
    // if (!isNil "_return") then {
        // _cache = missionNamespace getVariable ((_this select 0)+"dataCache");
        // if (isNil "_cache") then {
            // _cache = [[],[]];
            // missionNamespace setVariable [(_this select 0)+"dataCache", _cache];
        // };
        // _cachedIndex = (_cache select 0) find _event;
        // if (_cachedIndex != -1) then {
            // _return = (_cache select 1) set[_cachedIndex, _return];
        // } else {
            // _cachedIndex = PUSH((_cache select 0),_event);
            // (_cache select 1) set[_cachedIndex, _return];
        // };
    // };
// };

if (isNil "_return") exitWith { nil };
_return;
