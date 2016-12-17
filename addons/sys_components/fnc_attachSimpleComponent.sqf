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
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_parentComponentId", "_parentConnector", "_childComponentType", "_attributes", ["_force",false]];

private _return = false;
private _parentComponentClass = configFile >> "CfgAcreComponents" >> (getText(configFile >> "CfgWeapons" >> _parentComponentId >> "acre_baseClass"));
private _childComponentClass = configFile >> "CfgAcreComponents" >> _childComponentType;

private _componentSimple = getNumber (_childComponentClass >> "simple");
if (_componentSimple == 0) exitWith {
    WARNING_1("%1 is not a simple component!",_childComponentType);
    false
};

private _parentConnectorType = ((getArray(_parentComponentClass >> "connectors")) select _parentConnector) select 1;
private _childConnectorType = getNumber (_childComponentClass >> "connector");
if (_parentConnectorType == _childConnectorType) then {
    private _exit = false;
    private _parentComponentData = HASH_GET(acre_sys_data_radioData, _parentComponentId);

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
    };

    if (!_exit) then {
        [_parentComponentId, "attachComponent", [_childComponentType, _parentConnector, 0, _attributes]] call EFUNC(sys_data,dataEvent);
        _return = true;
    };
};
_return;
