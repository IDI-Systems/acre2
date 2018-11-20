#include "script_component.hpp"

// Exit if ACE3 not loaded
if (!isClass (configFile >> "CfgPatches" >> "ace_interact_menu")) exitWith {};

["Tank", "init", FUNC(initVehicleIntercom), nil, nil, true] call CBA_fnc_addClassEventHandler;
["Car_F", "init", FUNC(initVehicleIntercom), nil, nil, true] call CBA_fnc_addClassEventHandler;
["Air", "init", FUNC(initVehicleIntercom), nil, nil, true] call CBA_fnc_addClassEventHandler;
["Boat_F", "init", FUNC(initVehicleIntercom), nil, nil, true] call CBA_fnc_addClassEventHandler;

if (!hasInterface) exitWith {};

[
    "ACRE2",
    "IntercomPTTKey",
    [(localize LSTRING(intercomPttKey)), (localize LSTRING(intercomPttKey_description))],
    {[ACTION_INTERCOM_PTT] call FUNC(handlePttKeyPress)},
    {[ACTION_INTERCOM_PTT] call FUNC(handlePttKeyPressUp)}
] call cba_fnc_addKeybind;

[
    "ACRE2",
    "IntercomBroadcastKey",
    [(localize LSTRING(intercomBroadcastKey)), (localize LSTRING(intercomBroadcastKey_description))],
    {[ACTION_BROADCAST] call FUNC(handlePttKeyPress)},
    {[ACTION_BROADCAST] call FUNC(handlePttKeyPressUp)}
] call cba_fnc_addKeybind;

["ACRE2", "PreviousIntercom", (localize LSTRING(previousIntercom)), "", { [-1, true] call FUNC(switchIntercomFast) }, [51, [true, false, false]]] call cba_fnc_addKeybind;
["ACRE2", "NextIntercom", (localize LSTRING(nextIntercom)), "", {[1, true] call FUNC(switchIntercomFast)}, [51, [false, true, false]]] call cba_fnc_addKeybind;
["ACRE2", "AddPreviousIntercom", (localize LSTRING(addPreviousIntercom)), "", {[-1, false] call FUNC(switchIntercomFast)}, [51, [true, false, true]]] call cba_fnc_addKeybind;
["ACRE2", "AddNextIntercom", (localize LSTRING(addNextIntercom)), "", {[1, false] call FUNC(switchIntercomFast)}, [51, [false, true, true]]] call cba_fnc_addKeybind;

// Intercom configuration
["vehicle", {
    params ["_player", "_newVehicle"];
    [FUNC(enterVehicle), [_newVehicle, _player]] call CBA_fnc_execNextFrame; // Make sure vehicle info UI is created
}, true] call CBA_fnc_addPlayerEventHandler;

["featureCamera", {
    params ["_player", "_featureCamera"];
    if (_featureCamera isEqualTo "") then {
        [FUNC(enterVehicle), [vehicle _player, _player]] call CBA_fnc_execNextFrame; // Make sure vehicle info UI is created
    };
}, true] call CBA_fnc_addPlayerEventHandler;

player addEventHandler ["seatSwitchedMan", {
    params ["_unit1", "_unit2", "_vehicle"];
    [_vehicle, _unit1] call FUNC(seatSwitched);
}];

[QGVAR(giveInfantryPhone), {
    params ["_vehicle", "_unit", "_action", ["_intercomNetwork", INTERCOM_DISCONNECTED]];
    [_vehicle, _unit, _action, _intercomNetwork] call FUNC(updateInfantryPhoneStatus);
}] call CBA_fnc_addEventHandler;

#ifdef DRAW_INFANTRYPHONE_INFO
addMissionEventHandler ["Draw3D", {
    private _target = cursorObject;
    private _config = configFile >> "CfgVehicles" >> typeOf _target;
    if (getNumber (_config >> "acre_hasInfantryPhone") != 1) exitWith {};

    private _positionConfig = _config >> "acre_infantryPhonePosition";
    private _position = [0, 0, 0]; // Default to main action point
    if (isText _positionConfig) then { _position = _target worldToModelVisual (_target selectionPosition (getText _positionConfig)) };
    if (isArray _positionConfig) then { _position = getArray _positionConfig };
    drawIcon3D ["", [0.5, 0.5, 1, 1], _target modelToWorldVisual _position, 0.5, 0.5, 0, format ["%1 = %2", typeOf _target, _position], 0.5, 0.025, "TahomaB"];

    private _positionDynamic = _target getVariable ["acre_infantryPhone_positionDynamic", []];
    if !(_positionDynamic isEqualTo []) then {
        drawIcon3D ["", [0.75, 0.25, 1, 1], _target modelToWorldVisual _positionDynamic, 0.5, 0.5, 0, format ["%1 = %2", typeOf _target, _positionDynamic], 0.5, 0.025, "TahomaB"];
    };
}];
#endif

#ifdef DRAW_CURSORPOS_INFO
xArrow = "Sign_Arrow_F" createVehicle [0, 0, 0];
addMissionEventHandler ["Draw3D", {
    xIntersects = lineIntersectsSurfaces [AGLToASL positionCameraToWorld [0, 0, 0], AGLToASL positionCameraToWorld [0, 0, 100], player];
    if (count xIntersects == 0) exitWith {xArrow setPosASL [0,0,0]};
    xArrow setPosASL (xIntersects select 0 select 0);
    xArrow setVectorUp (xIntersects select 0 select 1);
    xPosWorld = (xIntersects select 0) select 0;
    xPosModel = cursorObject worldToModel (ASLToAGL xPosWorld); // Enter in watch field and copy to config
}];
#endif
