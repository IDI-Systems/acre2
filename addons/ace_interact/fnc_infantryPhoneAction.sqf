/*
 * Author: ACRE2Team
 * Adds an action for using vehicle intercom externally.
 *
 * Arguments:
 * 0: Vehicle with an intercom action <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_ace_interact_infantryPhoneAction
 *
 * Public: No
 */
#include "script_component.hpp"

// Exit if ACE3 not loaded
if (!isClass (configFile >> "CfgPatches" >> "ace_interact_menu")) exitWith {};

params ["_target"];

private _type = typeOf _target;

// Exit if object has no infantry phone
if (getNumber (configFile >> "CfgVehicles" >> _type >> "ACRE" >> "CVC" >> "hasInfantryPhone") != 1) exitWith {};

// Exit if class already initialized
if (_type in GVAR(initializedInfantryPhone)) exitWith {};

GVAR(initializedInfantryPhone) pushBack _type;

// Add action
TRACE_1("Adding Infantry Phone Action",_type);

private _positionConfig = configFile >> "CfgVehicles" >> _type >> "ACRE" >> "CVC" >> "infantryPhonePosition";
private _position = [0, 0, 0]; // Default to main action point
if (isText _positionConfig) then {
    _position = _target selectionPosition (getText _positionConfig); // Convert to coordinates for sys_core vehicleCrewPFH checks
};
if (isArray _positionConfig) then {
    _position = getArray _positionConfig;
};

private _infantryPhoneAction = [
    "ACRE_InfantryPhone",
    localize LSTRING(infantryPhone),
    "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa",
    {true},
    {
         // Only manually check distance if under main node (not a custom position on hull)
        if !((_this select 2) isEqualTo [0, 0, 0]) exitWith {true};
        _player distance _target < INFANTRYPHONE_MAXDISTANCE_DEFAULT
    },
    {_this call FUNC(infantryPhoneChildrenActions)},
    _position,
    _position,
    INFANTRYPHONE_MAXDISTANCE_HULL // Works for main actions only, used when custom position is defined
] call ace_interact_menu_fnc_createAction;

// Put inside main actions if no other position was found above
if (_position isEqualTo [0, 0, 0]) then {
    [_type, 0, ["ACE_MainActions"], _infantryPhoneAction] call ace_interact_menu_fnc_addActionToClass;
    _target setVariable [QEGVAR(sys_core,infantryPhoneInfo), [_position, INFANTRYPHONE_MAXDISTANCE_DEFAULT]];
} else {
    [_type, 0, [], _infantryPhoneAction] call ace_interact_menu_fnc_addActionToClass;
    _target setVariable [QEGVAR(sys_core,infantryPhoneInfo), [_position, INFANTRYPHONE_MAXDISTANCE_HULL]];
};
