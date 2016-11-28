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
 * [ARGUMENTS] call acre_sys_signalmap_fnc_drawSignalSamples;
 *
 * Public: No
 */
#include "script_component.hpp"

with uiNamespace do {
    _mapCtrl = _this select 0;
    {
        _sample = _x;
        // player sideChat format["%1 %2", _x select 0, _x select 1];
        _txPos = _sample select 0;
        _rxPos = _sample select 1;
        _mapCtrl drawArrow [_txPos, _rxPos, [0, 1, 0, 1]];
        _reflections = _sample select 3;
        {
            _reflection = _x;
            if(count _reflection == 0) exitWith {};
            _point = _reflection select 0;
            _mapCtrl drawLine [_txPos, _point, [1, 0, 0, 1]];
            _mapCtrl drawArrow [_point, _rxPos, [0, 0, 1, 1]];
            _mapCtrl drawIcon [
                '\a3\ui_f\data\IGUI\Cfg\Actions\clear_empty_ca.paa',
                [0,0,1,1],
                _point,
                5,
                5,
                0,
                format["%1, %2, %3", deg(_reflection select 2), _reflection select 3, _reflection select 4],
                0,
                0.05,
                'EtelkaNarrowMediumPro',
                "center"
            ];
        } forEach _reflections;
    } forEach GVAR(sampleData);
};
