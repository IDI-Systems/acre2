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
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

private _ret = nil;

private _exit = false;
private _count = 0;

if(GVAR(pipeCode) == "1") then {
    while {!_exit && _count < 50} do {
        // diag_log text format["Trying pipe."];
        _ret = "ACRE2Arma" callExtension "3";
        // diag_log text format["Pipe Response: %1", _ret];
        if(!(isNil "_ret")) then {
            if(_ret != "_JERR_FALSE") then {
                if(_ret != "_JERR_NULL" && _ret != "_JERR_NOCONNECT") then {
                    TRACE_1("got message", _ret);
                    _ret call CALLSTACK(GVAR(ioEventFnc));
                } else {
                    _exit = true;
                };
            } else {
                GVAR(hasErrored) = true;
                diag_log text format["%1 ACRE: ACRE HAS EXPERIENCED A PIPE ERROR AND PIPE IS NOW CLOSING!", COMPAT_diag_tickTime];
                if(isMultiplayer) then {
                    hint format["%1 ACRE: ACRE HAS EXPERIENCED A PIPE ERROR AND PIPE IS NOW CLOSING!", COMPAT_diag_tickTime];
                };
                "ACRE2Arma" callExtension "1";
                GVAR(pipeCode) = "0";
                _exit = true;
            };
        } else {
            _exit = true;
        };
        _count = _count + 1;
    };
    // diag_log text format["~~~~~~~~~~~~~~!!!!!!!!!!!!!!!!!!!! READ COUNT: %1", _count];
};
true
