#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns if the mounted radio can be removed or added.
 *
 * Arguments:
 * 0: Rack ID <STRING>
 *
 * Return Value:
 * Removable, true if so <BOOLEAN>
 *
 * Example:
 * ["acre_vrc110_id_1"] call acre_sys_rack_fnc_isRadioRemovable
 *
 * Public: No
 */

params ["_rackClassName"];

private _removable = GET_STATE_RACK(_rackClassName,"isRadioRemovable");

if (isNil "_removable") then {
    _removable = false;
};

_removable
