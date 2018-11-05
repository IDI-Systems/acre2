#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks if the ACRE2Arma extension has any pending messages (typically for return data from the TeamSpeak plugin). This is called on a per frame basis.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Successful Read <BOOL>
 *
 * Example:
 * [] call acre_sys_io_fnc_serverReadLoop
 *
 * Public: No
 */

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
                [_msg] call EFUNC(sys_core,displayNotification);
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
