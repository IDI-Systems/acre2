/*
 * Author: ACRE2Team
 * Checks the availability of the infantry phone speaker action.
 *
 * Arguments:
 * 0: Vehicle with an intercom action <OBJECT>
 * 1: Unit to be checked <OBJECT>
 *
 * Return Value:
 * Speaker action is available <BOOL>
 *
 * Example:
 * [cursorTarget] call acre_sys_intercom_isInfantryPhoneSpeakerAvailable
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_unit"];

if (!alive _unit) exitWith {false};

// For the moment only those in crew intercom are entitled to infantry phone actions
[_vehicle, _unit, CREW_INTERCOM] call FUNC(isIntercomAvailable)
