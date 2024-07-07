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
 * [ARGUMENTS] call acre_sys_data_fnc_getRadioState
 *
 * Public: No
 */

params ["_radio"];
private _stateCopy = nil;

if (isNil QEGVAR(sys_server,obelisk)) exitWith {
    diag_log text "GET RADIO STATE acre_sys_data_radioLockObject OR acre_sys_server_obelisk IS NIL!";
    nil
};

// if we own the radio, we pull oblix state
// if we dont own it, we push a CBA event requesting they push latest state, then we get the latest oblix data via the reply event
TRACE_1("_radio",_radio);
private _state = EGVAR(sys_server,obelisk) getVariable _radio;
TRACE_2("",_radio,_state);
_stateCopy = nil;
if (!isNil "_state") then {
    if (IS_ARRAY(_state)) then {
        _stateCopy = [];
        _stateCopy = +_state;
    } else {
        _stateCopy = _state;
    };
};
_stateCopy
