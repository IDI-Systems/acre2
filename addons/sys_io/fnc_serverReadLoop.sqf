/*
 * Author: ACRE2Team
 * Handles return data from the TeamSpeak plugin.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Successful <BOOL>
 *
 * Example:
 * [] call acre_sys_io_fnc_serverReadLoop
 *
 * Public: No
 */
#include "script_component.hpp"

if (GVAR(pipeCode) == "1") then {
    for "_count" from 0 to 50 do {
        // diag_log text format["Trying pipe."];
        private _ret = "ACRE2Arma" callExtension "3";
        // diag_log text format["Pipe Response: %1", _ret];
        if (isNil "_ret") exitWith {};
        if (_ret isEqualTo "_JERR_FALSE") exitWith {
            GVAR(hasErrored) = true;
            private _msg = "Experienced a pipe error! Closing!";
            WARNING(_msg);
            if (isMultiplayer) then {
                hint _msg;
            };
            "ACRE2Arma" callExtension "1";
            GVAR(pipeCode) = "0";
        };
        
        if (_ret isEqualTo "_JERR_NOCONNECT" || _ret isEqualTo "_JERR_NULL") exitWith {};

        TRACE_1("got message", _ret);
        _ret call CALLSTACK(GVAR(ioEventFnc));
    };
    // diag_log text format["~~~~~~~~~~~~~~!!!!!!!!!!!!!!!!!!!! READ COUNT: %1", _count];
};
true
