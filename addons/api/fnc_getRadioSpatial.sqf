/*
 * Author: ACRE2Team
 * Gets what spatialization zone the specified radio ID is currently in. “LEFT”, “RIGHT” or “CENTER”
 *
 * Arguments:
 * 0: Radio ID <STRING>
 *
 * Return Value:
 * "LEFT", "RIGHT" or "CENTER" <STRING>
 *
 * Example:
 * _spatial = ["ACRE_PRC148"] call acre_api_fnc_getRadioSpatial;
 *
 * Public: Yes
 */
#include "script_component.hpp"

private _ret = [(_this select 0)] call EFUNC(sys_radio,getRadioSpatial);

_ret
