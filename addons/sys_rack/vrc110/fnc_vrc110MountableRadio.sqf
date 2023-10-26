#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Check if the radio is mountable in AN/VRC110 rack.
 *
 * Arguments:
 * 0: Unique rack ID <STRING>
 * 1: Event type <STRING> (Unused)
 * 2: Event data with unique radio ID <STRING>
 * 3: Radio data <ARRAY> (Unused)
 *
 * Return Value:
 * Is radio mountable <BOOL>
 *
 * Example:
 * [cursorTarget] call acre_sys_rack_fnc_vrc110MountableRadio
 *
 * Public: No
 */

params ["_rackId", "", "_eventData", ""];

if (([_rackId] call FUNC(getMountedRadio)) != "") exitWith {false}; // If a radio is already mounted we can't mount another.

private _mountable = false;
private _radioId = _eventData;
private _baseClass = toLower (BASE_CLASS_CONFIG(_radioId));

if (_baseClass in ["acre_prc152"]) then { _mountable = true; };

_mountable
