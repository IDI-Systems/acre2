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
 * [ARGUMENTS] call acre_sys_data_fnc_onDataChangeEvent
 *
 * Public: No
 */

TRACE_1("NETWORK DATA EVENT",_this);

EGVAR(sys_core,speaking_cache_valid) = false;

if (ACRE_DATA_SYNCED) then {
    params ["_networkSequence", "_eventId"];
    if !(_eventId in GVAR(pendingNetworkEvents)) then {
        {
            _x params ["_unit", "_radioId", "_event", "_data", ["_eventKind", "CfgAcreDataInterface"]];
            /*_eventKind = "CfgAcreDataInterface";
            if ((count _x) > 4) then {
                _eventKind = _x select 4;
            } else {
                missionNamespace setVariable [_radioId+"dataCache", nil];
            };*/
            _data = _data call FUNC(deserialize);
            TRACE_1("NETWORK EVENT",_x);
            private _params = [_eventKind, _radioId, _event, _data, true];
            TRACE_1("PARAMS 1",_params);
            _params call FUNC(processSysEvent);
            TRACE_1("PARAMS 2",_params);
            _params call FUNC(processRadioEvent);
            TRACE_1("PARAMS 3",_params);
            if (isServer) then {
                private _radio = HASH_GET(GVAR(currentRadioStates),_radioId);
                if (isNil "_radio") then {
                    _radio = HASH_CREATE;
                    HASH_SET(GVAR(currentRadioStates),_radioId,_radio);
                };
                HASH_SET(_radio,_event,[ARR_2(diag_tickTime,_data)]);
            };
        } forEach (_this select 2);
    } else {
        TRACE_1("RECIEVED NETWORK EVENT CONFIRMATION",_eventId);
        GVAR(pendingNetworkEvents) = GVAR(pendingNetworkEvents) - [_eventId];
    };
} else {
    PUSH(GVAR(pendingSyncEvents),_this);
};

true
