#include "script_component.hpp"
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
 * ["ACRE_VRC110_ID_1","initializeRack",["ACRE_VRC110_ID_1","Dash",true,["inside"],[["cargo", 1],["ffv", [2]]],false,[],vehicle1],(acre_sys_data_radioData getVariable "ACRE_VRC110_ID_1")] call acre_sys_rack_fnc_initializeRack
 *
 * Public: No
 */

params ["_rackId", "", "_eventData", "_rackData"];
_eventData params ["_componentName", "_displayName", "_shortName", "_isRadioRemovable", "_allowed", "_disabled", "_mountedRadio", "_defaultComponents", "_intercoms", "_vehicle"];


HASH_SET(_rackData,"name",_displayName);
HASH_SET(_rackData,"shortName",_shortName);
HASH_SET(_rackData,"allowed",_allowed);
HASH_SET(_rackData,"disabled",_disabled);
HASH_SET(_rackData,"mountedRadio",_mountedRadio);
HASH_SET(_rackData,"isRadioRemovable",_isRadioRemovable);
HASH_SET(_rackData,"wiredIntercoms",_intercoms);
HASH_SET(_rackData,"vehicle",_vehicle);

//Only run on server as initializeRack is called globally.
if (isServer && {count _defaultComponents > 0}) then {
    private _connectedComponents = ([_rackId] call EFUNC(sys_components,getAllConnectors));
    private _componentClass = configFile >> "CfgAcreComponents" >> BASE_CLASS_CONFIG(_rackId);
    private _freeConnectors = [];
    private _usedConnectors = [];

    {
        _x params ["_displayName", "_connectorType"];
        private _connectorData = _connectedComponents select _forEachIndex;
        private _icon = "";

        if (!isNil "_connectorData") then { // Comomponent attached.
            _usedConnectors pushBack [_forEachIndex, _connectorType];
        } else { // No Component attached.
            _freeConnectors pushBack [_forEachIndex, _connectorType];
        };
    } forEach (getArray (_componentClass >> "connectors"));

    {
        private _componentName = _x;
        private _componentCfg = configFile >> "CfgAcreComponents" >> _componentName;
        if (getNumber (_componentCfg >> "simple") == 1) then { // only attaach simple components.
            private _connectorType = getNumber (_componentCfg >> "connector");
            // Is there a free_componentIdx component
            private _attributes = HASH_CREATE;
            private _freeComponentIdx = -1;
            private _freeConnectorsIdx = -1;
            {
                if (_x select 1 == _connectorType) exitWith {
                    _freeComponentIdx = _x select 0;
                    _freeConnectorsIdx = _forEachIndex;
                };
            } forEach _freeConnectors;

            if (_freeComponentIdx != -1) then {
                [_rackId, _freeComponentIdx, _componentName, _attributes, false] call EFUNC(sys_components,attachSimpleComponent);
                _usedConnectors pushBack (_freeConnectors deleteAt _freeConnectorsIdx);
                //Add to used index.
            } else { // Try using a used index.
                private _usedComponentIdx = -1;
                {
                    if (_x select 1 == _connectorType) exitWith {
                        _usedComponentIdx = _x select 0;
                    };
                } forEach _usedConnectors;
                if (_usedComponentIdx != -1) then {
                    [_rackId, _usedComponentIdx, _componentName, _attributes, true] call EFUNC(sys_components,attachSimpleComponent);
                };
            };
        };
    } forEach _defaultComponents;
};
