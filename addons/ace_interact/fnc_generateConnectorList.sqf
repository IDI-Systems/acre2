#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_ace_interact_fnc_generateConnectorList
 *
 * Public: No
 */

params ["_target","","_params"];
_params params ["_radio","_connectorIndex"];

private _actions = [];
private _connectedComponents = [_radio] call EFUNC(sys_components,getAllConnectedComponents);

private _componentClass = configFile >> "CfgAcreComponents" >> BASE_CLASS_CONFIG(_radio);
private _connectors = getArray (_componentClass >> "connectors");

private _connectorData = _connectedComponents select _connectorIndex;

if (!isNil "_connectorData") then { // Comomponent attached.
    //private _connectorConfigData = _connectors select _connectorIndex;
    _connectorData params ["_connectorIndex","_connectorChildData"];
    _connectorChildData params ["_childComponentName"];
    private _childDisplayName = getText (configFile >> "CfgAcreComponents" >> _childComponentName >> "shortName");

    private _action = [format ["acre_%1_connector_%2_component", _radio, _connectorIndex], _childDisplayName, "", {1 + 1;}, {true}, {}/*, _childParams*/] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

_actions;
