#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Find all antennas connected to the specified radio.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 *
 * Return Value:
 * Antenna data <ARRAY>
 *
 * Example:
 * ["ACRE_PRC343_ID_1"] call acre_sys_components_fnc_findAntenna
 *
 * Public: No
 */

params ["_radioId"];

private _foundAntennas = [];
private _searchedComponents = [];
private _searchFunction = {
    params ["_componentParentId"];
    PUSH(_searchedComponents, _componentParentId);
    private _componentData = HASH_GET(EGVAR(sys_data,radioData),_componentParentId);

    if (!isNil "_componentData") then {
        private _connectorData = HASH_GET(_componentData, "acre_radioConnectionData");
        if (!isNil "_connectorData") then {
            {
                private _connector = _x;
                private _connectorIndex = _forEachIndex;
                if (!isNil "_connector") then {
                    _connector params ["_connectedComponent", "", "_attributes"];
                    private _componentClass = configFile >> "CfgAcreComponents" >> _connectedComponent;
                    private _componentSimple = getNumber (_componentClass >> "simple");
                    if (_componentSimple == 1) then {
                        private _componentType = getNumber (_componentClass >> "type");
                        if (_componentType == ACRE_COMPONENT_ANTENNA) then {
                            private _componentObject = _componentParentId;
                            if (IS_STRING(_componentParentId)) then {
                                if (HASH_HASKEY(_attributes, "worldObject")) then {
                                    _componentObject = HASH_GET(_attributes, "worldObject");
                                } else {
                                    _componentObject = [_componentParentId] call EFUNC(sys_radio,getRadioObject);
                                };
                            };
                            private _objectType = typeOf _componentObject;
                            private _antennaPos = getPosASL _componentObject;
                            if !(_objectType isKindOf "CAManBase") then {
                                _antennaPos = _antennaPos vectorAdd [0, 0, (boundingCenter _componentObject) select 2];
                            };
                            private _antennaDir = vectorDir _componentObject;
                            private _antennaDirUp = vectorUp _componentObject;
                            private _configPath = configFile >> "CfgVehicles" >> _objectType;
                            if (isArray (_configPath >> "acre_antennaMemoryPoints")) then {
                                private _memoryPoints = getArray (_configPath >> "acre_antennaMemoryPoints");
                                _memoryPoints = _memoryPoints select (((count _memoryPoints) - 1) min _connectorIndex);
                                _antennaPos = ATLtoASL (_componentObject modelToWorld (_componentObject selectionPosition (_memoryPoints select 0)));
                            } else {
                                if (getText (_configPath >> "acre_antennaPosFnc") != "") then {
                                    _antennaPos = [_componentObject, _connectorIndex] call (missionNamespace getVariable (getText (_configPath >> "acre_antennaPosFnc")));
                                };
                            };
                            if (isArray (_configPath >> "acre_antennaMemoryPointsDir")) then {
                                private _memoryPoints = getArray (_configPath >> "acre_antennaMemoryPointsDir");
                                _memoryPoints = _memoryPoints select (((count _memoryPoints) - 1) min _connectorIndex);
                                _antennaDir = ATLtoASL(_componentObject modelToWorld (_componentObject selectionPosition (_memoryPoints select 0))) vectorFromTo
                                    ATLtoASL(_componentObject modelToWorld (_componentObject selectionPosition (_memoryPoints select 1)));
                                _antennaDirUp = ATLtoASL(_componentObject modelToWorld (_componentObject selectionPosition (_memoryPoints select 2))) vectorFromTo
                                    ATLtoASL(_componentObject modelToWorld (_componentObject selectionPosition (_memoryPoints select 3)));

                            } else {
                                if (getText (_configPath >> "acre_antennaDirFnc") != "") then {
                                    private _antennaDirResults = [_componentObject, _connectorIndex] call (missionNamespace getVariable (getText (_configPath >> "acre_antennaDirFnc")));
                                    _antennaDir = _antennaDirResults select 0;
                                    _antennaDirUp = _antennaDirResults select 1;
                                };
                            };
                            private _antennaPos2 = _antennaPos vectorAdd (_antennaDirUp vectorMultiply (getNumber (_componentClass >> "height")));
                            private _foundAntenna = [_connectedComponent, _componentObject, _antennaPos2, _antennaDir];
                            PUSH(_foundAntennas, _foundAntenna);
                        };
                    } else {
                        if !(_connectedComponent in _searchedComponents) then {
                            [_connectedComponent] call _searchFunction;
                        };
                    };
                };
            } forEach _connectorData;
        };
    };
};

private _rackId = [_radioId] call EFUNC(sys_rack,getRackFromRadio);
if (_rackId != "") then {
    [_rackId] call _searchFunction;
} else {
    [_radioId] call _searchFunction;
};

_foundAntennas;
