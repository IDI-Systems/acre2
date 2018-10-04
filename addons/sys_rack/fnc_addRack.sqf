#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * This will add a rack to a vehicle.
 *
 * Arguments:
 * 0: Vehicle <OBJECt>
 * 1: Base classname of the rack (Without ID) <STRING>
 * 2: Rackname - this is diplayed to the user. Ideally short <STRING>
 * 3: Rack short name - displayed in GUI information. Max 4 characters <STRING>
 * 4: Is mounted radio removable <BOOLEAN> (default: true)
 * 5: Access - Determines who can use the rack <ARRAY> (default: ["inside"])
 * 6: Disabled positions - Blacklist rack use positions <ARRAY> (default: [])
 * 7: Stashed radio - Does the rack start with a radio in it <STRING> (default: "")
 * 8: Components <ARRAY> (default: [])
 * 9: Connected intercoms <ARRAY> (default: [])
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, "ACRE_VRC110", "Dash", true, [["driver"], ["commander"], ["gunner"]], [], "ACRE_PRC152", [], ["crew"]] call acre_sys_rack_fnc_addRack
 *
 * Public: No
 */

params ["_vehicle", "_rackClassname", "_rackName", "_rackShortName", ["_isRadioRemovable", true], ["_allowed", ["inside"]], ["_disabled", []], ["_mountedRadio",""], ["_defaultComponents", []], ["_intercoms",[]]];

private _queue = _vehicle getVariable [QGVAR(queue), []];

_queue pushBack [_rackClassname, _rackName, _rackShortName, _isRadioRemovable, _allowed, _disabled, _mountedRadio, _defaultComponents, _intercoms];
_vehicle setVariable [QGVAR(queue), _queue];

// Request RACK ID
["acre_getRadioId", [_vehicle, _rackClassname, QGVAR(returnRackId)]] call CALLSTACK(CBA_fnc_globalEvent);
