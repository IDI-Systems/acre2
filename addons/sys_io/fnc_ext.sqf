#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Calls the voice extension with typed arguments.
 *
 * Arguments:
 * 0: Command, e.g. "tx:start" <STRING>
 * 1: Arguments <ARRAY> (default: [])
 *
 * Return Value:
 * Result, or "" if the call failed <STRING>
 *
 * Example:
 * ["vox:ptt", [true]] call acre_sys_io_fnc_ext
 *
 * Public: No
 */

params ["_command", ["_args", []]];

("acre_voice" callExtension [_command, _args]) params ["_result", "_returnCode", "_errorCode"];

if (_returnCode != 0 || {_errorCode != 0}) exitWith {
    WARNING_4("Voice extension call %1 %2 failed (%3): %4",_command,_args,_returnCode,_result);
    ""
};

_result
