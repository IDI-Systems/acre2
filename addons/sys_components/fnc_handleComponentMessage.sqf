#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handler for recieving a component message.
 *
 * Arguments:
 * 0: Component ID <STRING>
 * 1: Event name <STRING>
 * 2: Data <ARRAY>
 * 3: Component data <HASH>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_PRC343_ID_1","sendMessage","hello",acre_sys_data_radioData getVariable "ACRE_PRC343_ID_1"] call acre_sys_components_fnc_handleComponentMessage
 *
 * Public: No
 */

params ["", "", "_data", "", "", ""];

_data params ["_componentId", "_childConnector", "_parentConnector", "_attributes"];
//_childConnector - this is the connector on this event's device
//_parentConnector -  this is the connector on the device being connected
