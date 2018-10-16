 #include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets the mounted radio external audio to ON/OFF.
 *
 * Arguments:
 * 0: Radio Unique ID <STRING>
 * 1: External audio on/off <BOOL>
 * 1: Rack Unique ID <STRING><OPTIONAL>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_PRC152_ID_1", true] call acre_sys_rack_fnc_activateRackSpeaker
 *
 * Public: No
 */

params ["_radioId", "_active", ["_rackId",""]];

// TODO: For version 2.7. Implement check if rack has an external speaker

[_radioId, "setState", ["audioPath", "RACKSPEAKER"]] call EFUNC(sys_data,dataEvent);
