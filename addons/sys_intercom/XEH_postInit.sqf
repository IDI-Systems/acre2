#include "script_component.hpp"
#include "\a3\ui_f\hpp\defineDIKCodes.inc"

private _addClassEH = {
    ["Tank", "init", FUNC(initVehicleIntercom), nil, nil, true] call CBA_fnc_addClassEventHandler;
    ["Car_F", "init", FUNC(initVehicleIntercom), nil, nil, true] call CBA_fnc_addClassEventHandler;
    ["Air", "init", FUNC(initVehicleIntercom), nil, nil, true] call CBA_fnc_addClassEventHandler;
    ["Boat_F", "init", FUNC(initVehicleIntercom), nil, nil, true] call CBA_fnc_addClassEventHandler;
};

if (didJIP) then {
    // Give some time for synchronisation
    [{params ["_callFnc"]; [] call _callFnc;}, [_addClassEH], 3] call CBA_fnc_waitAndExecute;
} else {
    [] call _addClassEH;
};

// =================================== End Vehicle Initialisation

if (!hasInterface) exitWith {};

// Keybinds - Intercom
["ACRE2", "IntercomPTTKey", [localize LSTRING(intercomPttKey), localize LSTRING(intercomPttKey_description)], {
    [ACTION_INTERCOM_PTT] call FUNC(handlePttKeyPress)
}, {
    [ACTION_INTERCOM_PTT] call FUNC(handlePttKeyPressUp)
}] call CBA_fnc_addKeybind;

["ACRE2", "IntercomBroadcastKey", [localize LSTRING(intercomBroadcastKey), localize LSTRING(intercomBroadcastKey_description)], {
    [ACTION_BROADCAST] call FUNC(handlePttKeyPress)
}, {
    [ACTION_BROADCAST] call FUNC(handlePttKeyPressUp)
}] call CBA_fnc_addKeybind;

["ACRE2", "PreviousIntercom", [localize LSTRING(previousIntercomKey), localize LSTRING(previousIntercomKey_description)], "", {
    [-1, true] call FUNC(switchIntercomFast)
}, [DIK_COMMA, [true, false, false]]] call CBA_fnc_addKeybind;

["ACRE2", "NextIntercom", [localize LSTRING(nextIntercomKey), localize LSTRING(nextIntercomKey_description)], "", {
    [1, true] call FUNC(switchIntercomFast)
}, [DIK_COMMA, [false, true, false]]] call CBA_fnc_addKeybind;

["ACRE2", "AddPreviousIntercom", [localize LSTRING(addPreviousIntercomKey), localize LSTRING(addPreviousIntercomKey_description)], "", {
    [-1, false] call FUNC(switchIntercomFast)
}, [DIK_COMMA, [true, false, true]]] call CBA_fnc_addKeybind;

["ACRE2", "AddNextIntercom", [localize LSTRING(addNextIntercomKey), localize LSTRING(addNextIntercomKey_description)], "", {
    [1, false] call FUNC(switchIntercomFast)
}, [DIK_COMMA, [false, true, true]]] call CBA_fnc_addKeybind;

["ACRE2", QGVAR(openGui), localize LSTRING(openGui), {
    [-1] call FUNC(openGui)
}, "", [DIK_TAB, [true, true, false]]] call CBA_fnc_addKeybind;

// Intercom configuration
["vehicle", {
    params ["_player", "_newVehicle"];
    [FUNC(enterVehicle), [_newVehicle, _player]] call CBA_fnc_execNextFrame; // Make sure vehicle info UI is created
}, true] call CBA_fnc_addPlayerEventHandler;

// Hide display when entering a feature camera
["featureCamera", {
    params ["_player", "_featureCamera"];
    if (_featureCamera isEqualTo "") then {
        [vehicle _player, _player] call FUNC(updateVehicleInfoText); // Show & Update
    } else {
        [false] call EFUNC(sys_gui,showVehicleInfo); // Hide
    };
}, true] call CBA_fnc_addPlayerEventHandler;

[QGVAR(giveInfantryPhone), {
    params ["_vehicle", "_unit", "_action", "_message", ["_intercomNetwork", INTERCOM_DISCONNECTED]];
    [[ICON_RADIO_CALL], [_message]] call CBA_fnc_notify;
    [_vehicle, _unit, _action, _intercomNetwork] call FUNC(updateInfantryPhoneStatus);
}] call CBA_fnc_addEventHandler;

#ifdef DRAW_INFANTRYPHONE_INFO
addMissionEventHandler ["Draw3D", {
    private _target = cursorObject;
    private _config = configOf _target;
    if (getNumber (_config >> "acre_hasInfantryPhone") != 1) exitWith {};

    private _positionConfig = _config >> "acre_infantryPhonePosition";
    private _position = [0, 0, 0]; // Default to main action point
    if (isText _positionConfig) then { _position = _target worldToModelVisual (_target selectionPosition (getText _positionConfig)) };
    if (isArray _positionConfig) then { _position = getArray _positionConfig };
    drawIcon3D ["", [0.5, 0.5, 1, 1], _target modelToWorldVisual _position, 0.5, 0.5, 0, format ["%1 = %2", typeOf _target, _position], 0.5, 0.025, "TahomaB"];

    private _positionDynamic = _target getVariable ["acre_infantryPhone_positionDynamic", []];
    if (_positionDynamic isNotEqualTo []) then {
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
