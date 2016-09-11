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

params ["_logic", "_units", "_activated"];

if (!_activated) exitWith {};

ACRE_DEPRECATED("Basic Mission Setup module","2.4.0","CBA Settings");

// Frequencies and Babel
[_logic getVariable ["RadioSetup", false], _logic getVariable ["BabelSetup", 0]] call FUNC(setupFrequenciesAndBabel);

// Default radios
[0, _logic getVariable ["DefaultRadio", ""]] call FUNC(setupDefaultRadios);
[1, _logic getVariable ["DefaultRadio_Two", ""]] call FUNC(setupDefaultRadios);
[2, _logic getVariable ["DefaultRadio_Three", ""]] call FUNC(setupDefaultRadios);
[3, _logic getVariable ["DefaultRadio_Four", ""]] call FUNC(setupDefaultRadios);
