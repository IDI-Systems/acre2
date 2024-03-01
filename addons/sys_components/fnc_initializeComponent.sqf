#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Creates a complex component and attaches all the default components.
 *
 * Arguments:
 * 0: Component ID <STRING>
 * 1: Event <STRING>
 * 2: Data <ANY>
 * 3: Radio data <HASH>
 * 4: Event Kind <STRING>
 * 5: Remote <BOOLEAN>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_PRC343_ID_1", "initializeComponent, nil, acre_sys_data_radioData getVariable "ACRE_PRC343_ID_1"] call acre_sys_components_fnc_initializeComponent
 *
 * Public: No
 */

params ["_radioId", "", "", "_radioData", "", ""];

private _parentComponentClass = configFile >> "CfgAcreComponents" >> BASE_CLASS_CONFIG(_radioId);

private _connectorData = HASH_GET(_radioData,"acre_radioConnectionData");
if (isNil "_connectorData") then {
    _connectorData = [];
    HASH_SET(_radioData,"acre_radioConnectionData",_connectorData);
};
{
    // diag_log text format["x: %1", _x];
    _x params ["_connector", "_component"];

    private _attributes = HASH_CREATE;
    private _componentClass = configFile >> "CfgAcreComponents" >> _component;
    if (!isClass _componentClass) exitWith {
        WARNING_1("%1 is not a class type of CfgAcreComponents!",_component);
    };

    private _componentSimple = getNumber(_componentClass >> "simple");
    if(_componentSimple == 1) then {
        private _parentConnectorType = ((getArray(_parentComponentClass >> "connectors")) select _connector) select 1;
        private _childConnectorType = getNumber(_componentClass >> "connector");
        // diag_log text format["%3 _parentConnectorType: %1 _childConnectorType: %2", _parentConnectorType, _childConnectorType, _componentClass];
        if(_parentConnectorType == _childConnectorType) then {
            _connectorData set[_connector, [_component, 0, _attributes]];
            // diag_log text format["init _connectorData: %1", _connectorData];
        };
    } else {
        WARNING_2("Tried to initialize non-simple component attachment %1 on %2",_component,_radioId);
    };
} forEach (getArray(_parentComponentClass >> "defaultComponents"));

_this call EFUNC(sys_data,handleSetData);
