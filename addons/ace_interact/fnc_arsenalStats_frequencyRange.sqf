#include "script_component.hpp"
/*
 * Author: PabstMirror
 * Shows arsenal stats for frequency range
 *
 * Arguments:
 * 0: Stats Array of config strings <ARRAY>
 * 1: Radio Cfg <CONFIG>
 *
 * Return Value:
 * <STRING>
 *
 * Example:
 * [["..min", "...max"], configFile >> "CfgWeapons" >> "ACRE_PRC117F"] call acre_ace_interact_fnc_arsenalStats_frequencyRange
 *
 * Public: No
 */

params ["_statsArray", "_itemCfg"];

_statsArray = _statsArray apply {
    private _value = getNumber (_itemCfg >> _x);
    switch (true) do {
        case (_value == 0): {"?"};
        case (_value < 1e6): {format ["%1kHz", _value / 1e3]};
        case (_value < 1e9): {format ["%1MHz", _value / 1e6]};
        default {format ["%1GHz", _value / 1e9]};
    };
};

// note: doesn't handle non-contiguous ranges,
// and just because 2 radios are on same freq doesn't mean their bandwidth/modulation will be compatible..

format ["%1 - %2", _statsArray#0, _statsArray#1]
