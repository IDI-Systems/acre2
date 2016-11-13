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
 * [ARGUMENTS] call acre_sys_rack_fnc_initializeRack
 *
 * Public: No
 */
#include "script_component.hpp"

params["_radioId", "_event", "_eventData", "_radioData"];
_eventData params ["_componentName","_displayName","_isRadioRemovable","_allowed","_mountedRadio","_defaultComponents","_vehicle"];


HASH_SET(_radioData,"name",_displayName);
HASH_SET(_radioData,"allowed",_allowed);
HASH_SET(_radioData,"mountedRadio",_mountedRadio);
HASH_SET(_radioData,"isRadioRemovable",_isRadioRemovable);
HASH_SET(_radioData,"vehicle",_vehicle);