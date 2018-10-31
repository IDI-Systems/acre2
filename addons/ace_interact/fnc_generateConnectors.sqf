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
 * [ARGUMENTS] call acre_ace_interact_fnc_generateConnectors
 *
 * Public: No
 */

if (!GVAR(connectorsEnabled)) exitWith {};

params ["_target","","_params"];
_params params ["_parentComponent","",""];

private _actions = [];
private _connectedComponents = [_parentComponent] call EFUNC(sys_components,getAllConnectors);

private _componentClass = configFile >> "CfgAcreComponents" >> BASE_CLASS_CONFIG(_parentComponent);
private _connectors = getArray (_componentClass >> "connectors");
private _parentType = getNumber (_componentClass >> "type");

{
    _x params ["_displayName", "_connectorType"];
    private _childParams = [_parentComponent, _forEachIndex, _connectorType, _parentType];
    private _connectorData = _connectedComponents select _forEachIndex;
    private _icon = "";

    if (!isNil "_connectorData") then { // Comomponent attached.
        _connectorData params ["_childComponentName"];
        private _config = configFile >> "CfgAcreComponents" >> _childComponentName;
        if (isNull _config) then {
            _config = configFile >> "CfgAcreComponents" >> BASE_CLASS_CONFIG(_childComponentName);
        };
        private _childDisplayName = getText (_config >> "shortName");
        if (_childDisplayName == "") then { _childDisplayName = getText (_config >> "name"); };
        private _type = getNumber (_config >> "type");
        call {
            if (_type == ACRE_COMPONENT_ANTENNA) exitWith {_icon = "\idi\acre\addons\ace_interact\data\icons\antenna.paa";};
            if (_type == ACRE_COMPONENT_RACK) exitWith {_icon = "\idi\acre\addons\ace_interact\data\icons\racks.paa";};
            if (_type == ACRE_COMPONENT_RADIO) exitWith {_icon = getText (configFile >> "CfgWeapons" >> configName (_config) >> "picture");};
        };
        _childParams append [_type, _childDisplayName];
        _displayName = format ["%1 (%2)", _displayName, _childDisplayName];

    } else { // No Component attached.
        _displayName = format ["%1 (None)", _displayName];
    };


    private _action = [format ["acre_connector_%1", _forEachIndex], _displayName, _icon, {1+1;}, {true}, {_this call FUNC(generateConnectorActions);}, _childParams] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];

} forEach _connectors;

_actions;
