/*
 * Author: AUTHOR
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
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

params["_parentComponentId", "_parentConnector", "_childComponentId", "_childConnector", "_attributes", ["_force",false]];

private _return = false;
private _parentComponentClass = configFile >> "CfgAcreComponents" >> (getText(configFile >> "CfgWeapons" >> _parentComponentId >> "acre_baseClass"));
private _childComponentClass = configFile >> "CfgAcreComponents" >> (getText(configFile >> "CfgWeapons" >> _childComponentId >> "acre_baseClass"));

private _componentSimple = getNumber(_parentComponentClass >> "simple");
if(_componentSimple == 1) exitWith { diag_log text format["%1 ACRE ERROR: %2 is not a complex component!", diag_tickTime, _parentComponentId]; false; };

private _componentSimple = getNumber(_childComponentClass >> "simple");
if(_componentSimple == 1) exitWith { diag_log text format["%1 ACRE ERROR: %2 is not a complex component!", diag_tickTime, _childComponentId]; false; };

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
