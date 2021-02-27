#include "script_component.hpp"
if (is3DEN || {!hasInterface || {!(GVAR(enabled))}}) exitWith {};
if (!isClass (configFile >> "CfgPatches" >> "ace_common")) exitWith {}; // No ACE exit

if (GVAR(stopADS)) then {
    GVAR(disallowedViews) = ["GROUP"];
};

["acre_startedSpeaking", {call FUNC(startedSpeaking)}] call CBA_fnc_addEventHandler;
["acre_stoppedSpeaking", {call FUNC(stoppedSpeaking)}] call CBA_fnc_addEventHandler;

["unit", {
    params ["_newUnit", "_oldUnit"];
    _oldUnit call FUNC(stopGesture);

    // Add EHs one time only (won't be re-added on respawn)
    if (_newUnit getVariable [QGVAR(hasEHS), false]) exitWith {};
    _newUnit setVariable [QGVAR(hasEHS), true];

    _newUnit addEventHandler ["GetInMan", {
        params ["_unit"];
        TRACE_1("GetInMan",_unit);

        _unit call FUNC(stopGesture);
    }];

    _newUnit addEventHandler ["WeaponDeployed", {
        params ["_unit", "_isDeployed"];
        TRACE_2("WeaponDeployed",_unit,_isDeployed);

        if (_isDeployed) then {
            _unit call FUNC(stopGesture);
        };
    }];
}, true] call CBA_fnc_addPlayerEventHandler;
