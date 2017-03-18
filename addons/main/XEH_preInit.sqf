#include "script_component.hpp"

ADDON = false;

// Funtions and definitions of stack variables must remain in main due to the dependency within script_debug.hpp
ACRE_STACK_TRACE = [];
ACRE_STACK_DEPTH = 0;
ACRE_CURRENT_FUNCTION = "";

ACRE_DUMPSTACK_FNC = {
    diag_log text format["ACRE CALL STACK DUMP: %1:%2(%3) DEPTH: %4", _this select 0, _this select 1, ACRE_CURRENT_FUNCTION, ACRE_STACK_DEPTH];
    for "_x" from ACRE_STACK_DEPTH-1 to 0 step -1 do {
        _stackEntry = ACRE_STACK_TRACE select _x;
        _stackEntry params ["_callTickTime", "_callFileName", "_callLineNumb", "_callFuncName", "_nextFuncName", "_nextFuncArgs"];

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
};

ADDON = true;
