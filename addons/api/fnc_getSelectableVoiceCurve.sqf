/*
 * Author: ACRE2Team
 * Retrieves the scale of how far the local player's voice will be heard from.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Voice curve scale <NUMBER>
 *
 * Example:
 * _ret = [] call acre_api_fnc_getSelectableVoiceCurve;
 *
 * Public: Yes
 */
#include "script_component.hpp"

GVAR(selectableCurveScale)
