/*
 * Author: ACRE2Team
 * Attachs a complex component to another complex component.
 *
 * Arguments:
 * 0: Parent component Id <STRING>
 * 1: Parent connector Index <NUMBER>
 * 2: Child component Id <STRING>
 * 3: Child connector Index <NUMBER>
 * 4: Attributes of connection <HASH>
 * 5: Force - Permits replacing a pre-existing connection <BOOLEAN>
 *
 * Return Value:
 * Succesful <BOOLEAN>
 *
 * Example:
 * ["ACRE_PRC152_ID_1",2,"ACRE_PRC152_ID_2",2,[],false] call acre_sys_components_fnc_attachComplexComponent
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_parentComponentId", "_parentConnector", "_childComponentId", "_childConnector", "_attributes", ["_force",false]];

private _return = false;

private _parentComponentClass = configFile >> "CfgAcreComponents" >> BASE_CLASS_CONFIG(_parentComponentId);
private _childComponentClass = configFile >> "CfgAcreComponents" >> BASE_CLASS_CONFIG(_childComponentId);

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

if (_parentConnectorType == _childConnectorType) then {
    private _exit = false;
    private _parentComponentData = HASH_GET(EGVAR(sys_data,radioData), _parentComponentId);

    if (!isNil "_parentComponentData") then {
        private _parentConnectorData = HASH_GET(_parentComponentData, "acre_radioConnectionData");
        if (!isNil "_parentConnectorData") then {
            if (count _parentConnectorData > _parentConnector) then {
                private _test = _parentConnectorData select _parentConnector;
                if (!isNil "_test") then {
                    if (_force) then {
                        [_parentComponentId, _parentConnector] call FUNC(detachComponent);
                    } else {
                        _exit = true;
                    };
                };
            };
        };

        private _childComponentData = HASH_GET(EGVAR(sys_data,radioData),_childComponentId);
        if (!isNil "_childComponentData") then {
            private _childConnectorData = HASH_GET(_childComponentData, "acre_radioConnectionData");
            if (!isNil "_childConnectorData") then {
                if (count _childConnectorData > _childConnector) then {
                    private _test = _childConnectorData select _childConnector;
                    if (!isNil "_test") then {
                        if (_force) then {
                            [_childComponentId, _childConnector] call FUNC(detachComponent);
                        } else {
                            _exit = true;
                        };
                    };
                };
            };
            if (!_exit) then {
                [_parentComponentId, "attachComponent", [_childComponentId, _parentConnector, _childConnector, _attributes]] call EFUNC(sys_data,dataEvent);
                [_childComponentId, "attachComponent", [_parentComponentId, _childConnector, _parentConnector, _attributes]] call EFUNC(sys_data,dataEvent);
                _return = true;
            };
        };
    };
};
_return;
