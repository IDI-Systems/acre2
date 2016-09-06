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

if (!hasInterface) exitWith {false}; //Exit on server.

params[["_unit",acre_player]];

private _returnValue = !([_unit] call FUNC(hasBaseRadio)); // Is initialized if the unit has no base radio. HasBaseRadio also can not return nil.

if(_returnValue) then { // Just check that we don't return true if the unit has an itemRadio as itemRadio is also a base radio.
    if( ("ItemRadio" in ([_unit] call EFUNC(lib,getGear))) ) then {
        _returnValue = false;
    };
};

_returnValue
