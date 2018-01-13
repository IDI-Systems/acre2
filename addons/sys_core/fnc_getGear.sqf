/*
 * Author: ACRE2Team
 * Returns an array of ACRE gear in the passed unit.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Array of ACRE related gear (all lower-case except "ItemRadio" and "ItemRadioAcreFlagged") <ARRAY>
 *
 * Example:
 * [player] call acre_sys_core_fnc_getGear
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_unit"];

if (isNull _unit) exitWith {[]};

// diag_log text format["Assigned Items: %1", (assignedItems _unit)];

private _gear = (weapons _unit) + (items _unit) + (assignedItems _unit);

_gear = _gear select {(_x select [0, 4]) == "ACRE" || _x == "ItemRadio" || _x == "ItemRadioAcreFlagged"}; // We are only interested in ACRE gear.
// The below is really slow and tends to worsen performance.
//_gear = _gear select {(_x call EFUNC(api,getBaseRadio)) in (call EFUNC(api,getAllRadios) select 0) || {_x == "ItemRadio"} || {_x == "ItemRadioAcreFlagged"}};

_gear = _gear apply { [_x, toLower _x] select (_x select [0, 4] == "ACRE") };

_gear
