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
 * [ARGUMENTS] call acre_ace_interact_fnc_generateConnectorActions
 *
 * Public: No
 */

params ["_target","","_params"];
_params params ["_parentComponent","_connectorIndex","_connectorType","_parentType",["_connectedType",-1],["_childDisplayName",""]];

private _actions = [];

switch (_connectorType) do {
    case ACRE_CONNECTOR_CONN_32PIN: {
        if (_connectedType != -1) then { // something connected.
            private _name = format ["Unplug %1", _childDisplayName];

            private _action = ["acre_con_action", _name, "", {
                params ["_target", "", "_params"];
                _params params ["_parentComponentId", "_parentConnector"];
                [_parentComponentId, _parentConnector] call EFUNC(sys_components,detachComponent);
            }, {true}, {}, [_parentComponent, _connectorIndex]] call ace_interact_menu_fnc_createAction;
            _actions pushBack [_action, [], _target];
        } else {
            //TODO Allow linking radios?
            if (_parentType == ACRE_COMPONENT_RACK) then {
                private _radioList = ([] call EFUNC(api,getCurrentRadioList)) - [_parentComponent]; // Can't connect to self.
                {
                    private _radioID = _x;
                    private _connectors = getArray (configFile >> "CfgAcreComponents" >> BASE_CLASS_CONFIG(_radioID) >> "connectors");
                    private _connectorRadioIdx = -1;
                    {
                        _x params ["_connectorName","_connectorRadioType"];
                        if (ACRE_CONNECTOR_CONN_32PIN == _connectorRadioType) then {
                            _connectorRadioIdx = _forEachIndex;
                        };
                    } forEach _connectors;
                    if (_connectorRadioIdx != -1) then {
                        private _baseClass = BASE_CLASS_CONFIG(_radioID);
                        private _name = format ["Connect to %1",getText (configFile >> "CfgAcreComponents" >> _baseClass >> "name")];
                        private _icon = getText (configFile >> "CfgWeapons" >> _baseClass >> "picture");
                        private _action = [format ["acre_con_rack_%1_action", _forEachIndex], _name, _icon, {
                            params ["_target","","_params"];
                            _params params ["_parentComponent","_connectorIndex","_radioId","_connectorRadioIdx"];
                            [_parentComponent, _connectorIndex, _radioId, _connectorRadioIdx, HASH_CREATE] call EFUNC(sys_components,attachComplexComponent);
                        }, {true}, {}, [_parentComponent, _connectorIndex, _radioId, _connectorRadioIdx]] call ace_interact_menu_fnc_createAction;
                        _actions pushBack [_action, [], _target];
                    };
                } forEach _radioList;
            };
            if (_parentType == ACRE_COMPONENT_RADIO) then {
                private _rackList = ([vehicle _target, _target] call EFUNC(sys_rack,getAccessibleVehicleRacks)) - [_parentComponent]; // Can't connect to self.
                {
                    private _rackId = _x;
                    private _baseClass = BASE_CLASS_CONFIG(_rackId);
                    private _connectors = getArray (configFile >> "CfgAcreComponents" >> _baseClass >> "connectors");
                    private _connectorRackIdx = -1;
                    {
                        _x params ["_connectorName","_connectorRadioType"];
                        if (ACRE_CONNECTOR_CONN_32PIN == _connectorRadioType) then {
                            _connectorRackIdx = _forEachIndex;
                        };
                    } forEach _connectors;

                    if (_connectorRackIdx != -1) then {
                        private _name = format ["Connect to %1",getText (configFile >> "CfgAcreComponents" >> _baseClass >> "name")];
                        private _icon = "\idi\acre\addons\ace_interact\data\icons\rack.paa";
                        private _action = [format ["acre_con_radio_%1_action", _forEachIndex], _name, _icon, {
                            params ["_target","","_params"];
                            _params params ["_parentComponent","_connectorIndex","_rackId","_connectorRackIdx"];
                            [_parentComponent, _connectorIndex, _rackId, _connectorRackIdx, HASH_CREATE] call EFUNC(sys_components,attachComplexComponent);
                        }, {true}, {}, [_rackId, _connectorRackIdx, _parentComponent, _connectorIndex]] call ace_interact_menu_fnc_createAction;
                        _actions pushBack [_action, [], _target];
                    };
                } forEach _rackList;
            };
        };
    };
};


_actions;
