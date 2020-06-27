#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Return function for signal calculation. Will be called after signal has been calculated in the extension.
 *
 * Arguments:
 * 0: Radio IDs (TX and RX) <ARRAY>
 * 1: Antenna and Signal Strength <ARRAY>
 *
 * Return Value:
 * None
 *
 *
 * Public: No
 */

params ["_args", "_result"];
_args params ["_transmitterClass", "_receiverClass"];

if !(_result isEqualTo []) then {
    _result params ["_id", "_signal"];
    TRACE_2("",_id,_signal);

    private _bestSignalStr = format ["%1_best_signal", _transmitterClass];
    private _bestAntStr = format ["%1_best_ant", _transmitterClass];

    private _maxSignal = missionNamespace getVariable [_bestSignalStr , -992];
    private _currentAntenna = missionNamespace getVariable [_bestAntStr, ""];

    TRACE_4("",_bestSignalStr,_maxSignal,_bestAntStr,_currentAntenna);

    if ((_id == _currentAntenna) || {(_id != _currentAntenna) && {_signal > _maxSignal}}) then {
        missionNamespace setVariable [_bestSignalStr, _signal];
        missionNamespace setVariable [_bestAntStr, _id];

        private _bestPxStr = format ["%1_best_px", _transmitterClass];
        if (_maxSignal >= -500) then {
            private _realRadioRx = [_receiverClass] call EFUNC(sys_radio,getRadioBaseClassname);
            private _min = getNumber (configFile >> "CfgAcreComponents" >> _realRadioRx >> "sensitivityMin");
            private _max = getNumber (configFile >> "CfgAcreComponents" >> _realRadioRx >> "sensitivityMax");

            private _Px = (((_maxSignal - _min) / (_max - _min)) max 0.0) min 1.0;
            missionNamespace setVariable [_bestPxStr, _Px];
        } else {
            missionNamespace setVariable [_bestPxStr, 0];
        };
        if (count _result > 3) then {
            ACRE_DEBUG_SIGNAL_FILE = _result select 3;
        };
    };
};

private _runningCountStr = format ["%1_running_count", _transmitterClass];
private _count = missionNamespace getVariable [_runningCountStr, 0];
missionNamespace setVariable [_runningCountStr, _count - 1];
