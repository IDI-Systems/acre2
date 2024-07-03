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
 * [ARGUMENTS] call acre_sys_data_fnc__processQueue
 *
 * Public: No
 */

if (ACRE_DATA_SYNCED && {GVAR(eventQueue) isNotEqualTo []}) then {
    private _newQueue = [];
    private _sendEvents = [];
    {
        if ((_x select 4) <= diag_tickTime) then {
            private _data = (_x select 3) call FUNC(serialize);
            if ((_x select 5) != "CfgAcreDataInterface") then {
                PUSH(_sendEvents,[ARR_5(_x select 0,_x select 1,_x select 2,_data,_x select 5)]);
            } else {
                PUSH(_sendEvents,[ARR_4(_x select 0,_x select 1,_x select 2,_data)]);
            };
        } else {
            PUSH(_newQueue,_x);
        };
    } forEach GVAR(eventQueue);
    TRACE_1("SEND EVENT COUNT",(count _sendEvents));
    if (_sendEvents isNotEqualTo []) then {
        private _id = [] call FUNC(createEventMsgId);
        PUSH(GVAR(pendingNetworkEvents),_id);
        TRACE_2("SENDING NETWORK EVENT",_id,_sendEvents);
        [_id, _sendEvents] call FUNC(sendDataEvent);
    };
    GVAR(eventQueue) = _newQueue;
};
