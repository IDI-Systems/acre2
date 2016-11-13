/*
 * Author: ACRE2Team
 * Initializes the rack data.
 *
 * Arguments:
 * 0: Rack ID <STRING>
 * 1: Event <STRING>
 * 2: Event Data <ANY>
 * 3: Rack Data <HASH>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_VRC110_ID_1","initializeRack",["ACRE_VRC110_ID_1","Dash",true,["inside"],false,[],vehicle1],(acre_sys_data_radioData getVariable "ACRE_VRC110_ID_1")] call acre_sys_rack_fnc_initializeRack
 *
 * Public: No
 */
#include "script_component.hpp"

params["_rackId", "_event", "_eventData", "_rackData"];
_eventData params ["_componentName","_displayName","_isRadioRemovable","_allowed","_mountedRadio","_defaultComponents","_vehicle"];


HASH_SET(_rackData,"name",_displayName);
HASH_SET(_rackData,"allowed",_allowed);
HASH_SET(_rackData,"mountedRadio",_mountedRadio);
HASH_SET(_rackData,"isRadioRemovable",_isRadioRemovable);
HASH_SET(_rackData,"vehicle",_vehicle);