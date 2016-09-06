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

params["_radio"];


// is it a radio that doesn't have an data anymore? if so, that means it got hit with GC and we create a new one
if(!([_radio] call EFUNC(sys_data,isRadioInitialized))) then {
    LOG("New Radio was invalid, replacing with a base...");
    [acre_player, _radio, _base] call EFUNC(lib,replaceGear);
} else {
    [_radio] call EFUNC(sys_radio,setActiveRadio);
};
