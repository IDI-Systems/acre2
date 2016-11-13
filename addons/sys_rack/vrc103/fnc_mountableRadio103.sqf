/*
 * Author: ACRE2Team
 * Mount radio classname
 *
 * Arguments:
 * 0: Target Vehicle <OBJECT>
 *
 * Return Value:
 * RETURN VALUE <ARRAY>
 *
 * Example:
 * [] call acre_sys_rack_fnc_mountableRadio103;
 *
 * Public: No
 */
#include "script_component.hpp"

params["_rackId", "_event", "_eventData", "_radioData"];

if (([_rackId] call FUNC(getMountedRadio)) != "") exitWith {false}; // If a radio is already mounted we can't mount another.

private _mountable = false;
private _radioId = _eventData;
private _baseClass = toLower (BASE_CLASS_CONFIG(_radioId));

if (_baseClass in ["acre_prc117f"]) then { _mountable = true; };


_mountable;