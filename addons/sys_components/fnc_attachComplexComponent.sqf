/*
 * Author: ACRE2Team
 * Attaches a complex component to a complex component.
 *
 * Arguments:
 * 0: Component ID to attach to <STRING>
 * 1: Connector to use - Index on component it is being attached to <NUMBER>
 * 2: Component ID of child component <STRING>
 * 3: Attributes - These are passed on to the attachComponent event <HASH>
 * 4: Force - If set to false it will not replace any existing components already attached to the connector. (default:false) <BOOLEAN>
 *
 * Return Value:
 * Successful <BOOLEAN>
 *
 * Example:
 * ["ACRE_PRC152_ID_1",0,"ACRE_PRC152_ID_2",[],false] call acre_sys_components_fnc_attachComplexComponent;
 *
 * Public: No
 */
#include "script_component.hpp"

params["_parentComponentId", "_parentConnector", "_childComponentId", "_childConnector", "_attributes", ["_force",false]];

private _return = false;
private _baseClass = getText(configFile >> "CfgWeapons" >> _parentComponentId >> "acre_baseClass");
if (_baseClass == "") then { _baseClass = getText(configFile >> "CfgVehicles" >> _parentComponentId >> "acre_baseClass"); };
private _parentComponentClass = configFile >> "CfgAcreComponents" >> _baseClass;
private _baseClass = getText(configFile >> "CfgWeapons" >> _childComponentId >> "acre_baseClass");
if (_baseClass == "") then { _baseClass = getText(configFile >> "CfgVehicles" >> _childComponentId >> "acre_baseClass"); };
private _childComponentClass = configFile >> "CfgAcreComponents" >> _baseClass;

private _componentSimple = getNumber (_parentComponentClass >> "simple");
if (_componentSimple == 1) exitWith {
    WARNING_1("%1 is not a complex component!",_parentComponentId);
    false
};

private _componentSimple = getNumber (_childComponentClass >> "simple");
if (_componentSimple == 1) exitWith {
    WARNING_1("%1 is not a complex component!",_childComponentId);
    false
};

private _parentConnectorType = ((getArray(_parentComponentClass >> "connectors")) select _parentConnector) select 1;
private _childConnectorType = ((getArray(_childComponentClass >> "connectors")) select _childConnector) select 1;

if(_parentConnectorType == _childConnectorType) then {
    private _exit = false;
    private _parentComponentData = HASH_GET(acre_sys_data_radioData, _parentComponentId);

    if(!isNil "_parentComponentData") then {
        private _parentConnectorData = HASH_GET(_parentComponentData, "acre_radioConnectionData");
        if(!isNil "_parentConnectorData") then {
            if(count _parentConnectorData > _parentConnector) then {
                private _test = _parentConnectorData select _parentConnector;
                if(!isNil "_test") then {
                    if(_force) then {
                        [_parentComponentId, _parentConnector] call FUNC(detachComponent);
                    } else {
                        _exit = true;
                    };
                };
            };
        };

        private _childComponentData = HASH_GET(acre_sys_data_radioData,_childComponentId);
        if(!isNil "_childComponentData") then {
            private _childConnectorData = HASH_GET(_childComponentData, "acre_radioConnectionData");
            if(!isNil "_childConnectorData") then {
                if(count _childConnectorData > _childConnector) then {
                    private _test = _childConnectorData select _childConnector;
                    if(!isNil "_test") then {
                        if(_force) then {
                            [_childComponentId, _childConnector] call FUNC(detachComponent);
                        } else {
                            _exit = true;
                        };
                    };
                };
            };
            if(!_exit) then {
                [_parentComponentId, "attachComponent", [_childComponentId, _parentConnector, _childConnector, _attributes]] call EFUNC(sys_data,dataEvent);
                [_childComponentId, "attachComponent", [_parentComponentId, _childConnector, _parentConnector, _attributes]] call EFUNC(sys_data,dataEvent);
                _return = true;
            };
        };
    };
};
_return;
