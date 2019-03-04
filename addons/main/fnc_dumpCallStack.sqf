#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Dumps call stack into RPT.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call acre_main_fnc_dumpCallStack
 *
 * Public: No
 */

params [["_file", ""], ["_line", ""]];

diag_log text format ["ACRE CALL STACK DUMP: %1:%2 (%3) DEPTH: %4", _file, _line, ACRE_CURRENT_FUNCTION, ACRE_STACK_DEPTH];

for "_x" from ACRE_STACK_DEPTH - 1 to 0 step -1 do {
    (ACRE_STACK_TRACE select _x) params ["_callTickTime", "_callFileName", "_callLineNumb", "_callFuncName", "_nextFuncName", "_nextFuncArgs"];

    if (_callFuncName == "") then {
        _callFuncName = "<root>";
    };

    diag_log text format ["%8%1:%2 | %3:%4(%5) => %6(%7)",
        _x + 1,
        _callTickTime,
        _callFileName,
        _callLineNumb,
        _callFuncName,
        _nextFuncName,
        _nextFuncArgs,
        toString [9]
    ];
};
