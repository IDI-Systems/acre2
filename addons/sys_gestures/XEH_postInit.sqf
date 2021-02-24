#include "script_component.hpp"
if (is3DEN || {!hasInterface || {!(GVAR(enabled))}}) exitWith {};
if (!isClass (configFile >> "CfgPatches" >> "ace_common")) exitWith {}; // No ACE exit

if (GVAR(stopADS)) then {
    GVAR(disallowedViews) = ["GROUP"];
};

["acre_startedSpeaking", {call FUNC(startedSpeaking)}] call CBA_fnc_addEventHandler;
["acre_stoppedSpeaking", {call FUNC(stoppedSpeaking)}] call CBA_fnc_addEventHandler;

["unit", {
    params ["", "_oldUnit"];
    _oldUnit call FUNC(stopGesture);
}, true] call CBA_fnc_addPlayerEventHandler;

acre_player addEventHandler ["GetInMan", {
    params ["_unit"];

    _unit call FUNC(stopGesture);
}];

acre_player addEventHandler ["WeaponDeployed", {
    params ["_unit", "_isDeployed"];

    if (_isDeployed) then {
        _unit call FUNC(stopGesture);
    };
}];
