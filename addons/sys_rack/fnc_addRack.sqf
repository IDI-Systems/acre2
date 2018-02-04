/*
 * Author: ACRE2Team
 * This will add a rack to a vehicle.
 *
 * Arguments:
 * 0: Vehicle <OBJECt>
 * 1: Classname of rack (Without ID) <TYPE>
 * 2: Rackname - this is diplayed to the user. Ideally short <STRING>
 * 3: Is mounted radio removable <BOOLEAN> (default: true)
 * 4: Access - Determines who can use the rack <ARRAY> (default: ["inside"])
 * 5: Disabled positions - Blacklist rack use positions <ARRAY> (default: [])
 * 6: Stashed radio - Does the rack start with a radio in it <STRING> (default: "")
 * 7: Components <ARRAY> (default: [])
 * 8: Connected intercoms <ARRAY> (default: [])
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, "ACRE_VRC110", "Dash", true, [["driver"], ["commander"], ["gunner"]], [], "ACRE_PRC152", [], ["crew"]] call acre_sys_rack_fnc_addRack
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_rackClassname", "_rackName", ["_isRadioRemovable", true], ["_allowed", ["inside"]], ["_disabled", []], ["_mountedRadio",""], ["_defaultComponents", []], ["_intercoms",[]], ["_rackPosition", [0, 0, 0]]];

private _queue = _vehicle getVariable [QGVAR(queue), []];

_queue pushBack [_rackClassname, _rackName, _isRadioRemovable, _allowed, _disabled, _mountedRadio, _defaultComponents, _intercoms, _rackPosition];
_vehicle setVariable [QGVAR(queue), _queue];

// Request RACK ID
["acre_getRadioId", [_vehicle, _rackClassname, QGVAR(returnRackId)]] call CALLSTACK(CBA_fnc_globalEvent);
