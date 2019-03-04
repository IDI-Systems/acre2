#include "script_component.hpp"
/*
 * Author: ACE-Team, ACRE2Team
 * Dumps performance counter statistics into RPT.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call acre_main_fnc_dumpPerformanceCounters
 *
 * Public: No
 */

params [["_file", ""], ["_line", ""]];

diag_log text format ["ACRE PERFORMANCE COUNTERS DUMP: %1:%2", _file, _line];


diag_log text format ["REGISTERED ACRE PFH HANDLERS (%1)", count ACRE_PFH];
diag_log text format ["-------------------------------------------"];

if (!isNil "ACRE_PFH") then {
    {
        _x params ["_pfh", "_parameters"];

        private _isActive = ["ACTIVE", "REMOVED"] select isNil {CBA_common_PFHhandles select (_pfh select 0)};

        diag_log text format ["Registered PFH: id=%1 [%2, delay %3], %4:%5", _pfh select 0, _isActive, _parameters select 1, _pfh select 1, _pfh select 2];
        false
    } count ACRE_PFH;
};

diag_log text format ["ACRE COUNTER RESULTS (%1)", count ACRE_COUNTERS];
diag_log text format ["-------------------------------------------"];

{
    private _counterEntry = _x;
    private _iter = 0;
    private _total = 0;
    private _count = 0;
    private _averageResult = 0;

    if (count _counterEntry > 3) then {
        // calc
        {
            if (_iter > 2) then {
                _count = _count + 1;
                private _delta = (_x select 1) - (_x select 0);

                _total = _total + _delta;
            };

            _iter = _iter + 1;
            false
        } count _counterEntry;

        // results
        _averageResult = (_total / _count) * 1000;

        // dump results
        diag_log text format ["%1: Average: %2s / %3 = %4ms", _counterEntry select 0, _total, _count, _averageResult];
    } else {
        diag_log text format ["%1: No results", _counterEntry select 0];
    };
    false
} count ACRE_COUNTERS;
