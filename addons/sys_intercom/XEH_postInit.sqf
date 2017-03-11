#include "script_component.hpp"

// Exit if ACE3 not loaded
if (!isClass (configFile >> "CfgPatches" >> "ace_interact_menu")) exitWith {};

[QGVAR(infPhoneEventCalling), {[FUNC(infantryPhoneRingingPFH), 1, _this] call CBA_fnc_addPerFrameHandler}] call CBA_fnc_addEventHandler;

if (!hasInterface) exitWith {};

["Tank", "init", FUNC(intercomActions), nil, nil, true] call CBA_fnc_addClassEventHandler;
["Car_F", "init", FUNC(intercomActions), nil, nil, true] call CBA_fnc_addClassEventHandler;

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
