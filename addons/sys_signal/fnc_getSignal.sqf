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

params ["_f", "_mW", "_receiverClass", "_transmitterClass", ["_skip", false]];

private _count = missionNamespace getVariable [_transmitterClass + "_running_count", 0];
if(_count == 0) then {
    private _rxAntennas = [_receiverClass] call EFUNC(sys_components,findAntenna);
    private _txAntennas = [_transmitterClass] call EFUNC(sys_components,findAntenna);

    {
        private _txAntenna = _x;
        {
            private _rxAntenna = _x;
            _count = _count + 1;
            private _id = format["%1_%2_%3_%4", _transmitterClass, (_txAntenna select 0), _receiverClass, (_rxAntenna select 0)];
            [
                "process_signal",
                [
                    _id,
                    (_txAntenna select 2),
                    (_txAntenna select 3),
                    (_txAntenna select 0),
                    (_rxAntenna select 2),
                    (_rxAntenna select 3),
                    (_rxAntenna select 0),
                    _f,
                    _mW,
                    GVAR(terrainScaling),
                    diag_tickTime,
                    ACRE_SIGNAL_DEBUGGING,
                    GVAR(omnidirectionalRadios)
                ],
                true,
                FUNC(handleSignalReturn),
                [_transmitterClass, _receiverClass]
            ] call EFUNC(sys_core,callExt);
        } forEach _rxAntennas;
    } forEach _txAntennas;
    missionNamespace setVariable [_transmitterClass + "_running_count", _count];
};
private _maxSignal = missionNamespace getVariable [_transmitterClass + "_best_signal", -992];
private _Px = missionNamespace getVariable [_transmitterClass + "_best_px", 0];

if (ACRE_SIGNAL_DEBUGGING > 0) then {
    private _signalTrace = missionNamespace getVariable [_transmitterClass + "_signal_trace", []];
    _signalTrace pushBack _maxSignal;
    missionNamespace setVariable [_transmitterClass + "_signal_trace", _signalTrace];
};


[_Px, _maxSignal];
