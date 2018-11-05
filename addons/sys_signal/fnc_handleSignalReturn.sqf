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

if (count _result > 0) then {
    _result params ["_id", "_signal"];
    private _maxSignal = missionNamespace getVariable [_transmitterClass + "_best_signal", -992];
    private _currentAntenna = missionNamespace getVariable [_transmitterClass + "_best_ant", ""];
    if (_id == _currentAntenna || {(_id != _currentAntenna && {_signal > _maxSignal})}) then {
        missionNamespace setVariable [_transmitterClass + "_best_signal", _signal];
        missionNamespace setVariable [_transmitterClass + "_best_ant", _id];
        if (_maxSignal >= -500) then {
            private _realRadioRx = [_receiverClass] call EFUNC(sys_radio,getRadioBaseClassname);
            private _min = getNumber (configFile >> "CfgAcreComponents" >> _realRadioRx >> "sensitivityMin");
            private _max = getNumber (configFile >> "CfgAcreComponents" >> _realRadioRx >> "sensitivityMax");

            private _Px = (((_maxSignal - _min) / (_max - _min)) max 0.0) min 1.0;
            missionNamespace setVariable [_transmitterClass + "_best_px", _Px];
        } else {
            missionNamespace setVariable [_transmitterClass + "_best_px", 0];
        };
        if (count _result > 3) then {
            ACRE_DEBUG_SIGNAL_FILE = _result select 3;
        };
    };
};

private _count = missionNamespace getVariable [_transmitterClass + "_running_count", 0];
missionNamespace setVariable [_transmitterClass + "_running_count", _count - 1];
