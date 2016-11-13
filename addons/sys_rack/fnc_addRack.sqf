/*
 * Author: ACRE2Team
 * This will add a rack to a vehicle.
 *
 * Arguments:
 * 0: Vehicle <OBJECt>
 * 1: Classname of rack (Without ID) <TYPE>
 * 2: Rackname - this is diplayed to the user. Ideally short <STRING>
 * 3: Is mounted radio removable <BOOLEAN>
 * 4: Access - Determines who can use the rack. Uses an array of text "inside" - for anyone, "external" - for outside, "driver" - for driver
 *    "gunner" and " Commander are also usable
 *    Default - "inside" <ARRAY>
 * 5: Stashed radio - Does the rack start with a radio in it - Default "" - None <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [vehicle1,"ACRE_VRC110","Dash",true,["driver","commander","gunner"],'ACRE_PRC152'] call acre_sys_rack_fnc_addRack;
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle","_rackClassname","_rackName",["_isRadioRemovable",true],["_allowed",["inside"]],["_mountedRadio",""],["_defaultComponents",[]]];

private _queue = _vehicle getVariable [QGVAR(queue),[]];

_queue pushBack [_rackClassname,_rackName,_isRadioRemovable,_allowed,_mountedRadio,_defaultComponents];
_vehicle setVariable [QGVAR(queue),_queue];
//Request RACK ID
["acre_getRadioId", [_vehicle, _rackClassname, QGVAR(returnRackId)]] call CALLSTACK(CBA_fnc_globalEvent);

