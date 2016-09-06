/*
 * Author: AUTHOR
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

if((count GVAR(runningProcesses)) > 0) then {
    params ["_pParams"];
    _pParams params ["_pIndex","_currentCount"];
    if(_pIndex < 0 || _currentCount < (count GVAR(runningProcesses))) then {
        _pIndex = (count GVAR(runningProcesses))-1;
        _pParams set[0, _pIndex];
        _pParams set[1, (count GVAR(runningProcesses))];
    };
    private _startTime = diag_tickTime;
    while {diag_tickTime-_startTime < 0.002 && _pIndex >= 0} do {
        private _procParams = GVAR(runningProcesses) select _pIndex;
        private _stepStartTime = diag_tickTime;
        private _stillRunning = _procParams call FUNC(doMultiPath);
        private _stepEndTime = diag_tickTime;
        // diag_log text format["t: %1", _stepEndTime-_stepStartTime];
        if(!_stillRunning) then {
            // diag_log text "------------------------------------------------------------------------------------------";
            GVAR(runningProcesses) deleteAt _pIndex;
            _pParams set[1, (count GVAR(runningProcesses))];
        };
        _pIndex = _pIndex-1;
        _pParams set[0, _pIndex];
    };
};
