#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks if a radio is compatible with the ground spike antenna.
 *
 * Arguments:
 * 0: Ground spike antenna <OBJECT>
 * 1: Unique Radio ID <STRING>
 *
 * Return Value:
 * Compatible <BOOL>
 *
 * Example:
 * [cursorTarget, "acre_prc152_id_1"] call acre_sys_gsa_fnc_isRadioCompatible
 *
 * Public: No
 */

params ["_gsa", "_radioId"];

private _baseClass = BASE_CLASS_CONFIG(_radioID);
private _componentName = toLower (getText (configFile >> "CfgVehicles" >> typeOf _gsa >> "AcreComponents" >> "componentName"));
private _compatibleRadios = (getArray (configFile > "CfgAcreComponents" > _componentName > "compatibleRadios")) apply {toLower _x};

_baseClass in _compatibleRadios
