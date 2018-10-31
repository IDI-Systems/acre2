#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Adds an action for using vehicle intercom externally.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_intercom_fnc_infantryPhoneAction
 *
 * Public: No
 */

params ["_target"];

private _type = typeOf _target;

// Exit if object has no infantry phone
if (getNumber (configFile >> "CfgVehicles" >> _type >> "acre_hasInfantryPhone") != 1) exitWith {};

// Exit if class already initialized
if (_type in GVAR(initializedInfantryPhone)) exitWith {};
GVAR(initializedInfantryPhone) pushBack _type;

// Add action
TRACE_1("Adding Infantry Phone Action",_type);

private _positionConfig = configFile >> "CfgVehicles" >> _type >> "acre_infantryPhonePosition";
private _position = [0, 0, 0]; // Default to main action point
if (isText _positionConfig) then {
    _position = _target selectionPosition (getText _positionConfig); // Convert to coordinates for sys_core intercomPFH checks
};
if (isArray _positionConfig) then {
    _position = getArray _positionConfig;
};

private _infantryPhoneAction = [
    QGVAR(infantryPhone),
    localize LSTRING(infantryPhone),
    ICON_RADIO_CALL,
    {true},
    {
        // Only manually check distance if under main node (not a custom position on hull)
        // Main interaction node is not shown on destroyed vehicle, so we only check that if not main node
        //USES_VARIABLES ["_target", "_player"];
        if !((_this select 2) isEqualTo [0, 0, 0]) exitWith {alive _target};
        _player distance _target < PHONE_MAXDISTANCE_DEFAULT
    },
    {_this call FUNC(infantryPhoneChildrenActions)},
    _position,
    _position,
    PHONE_MAXDISTANCE_HULL // Works for main actions only, used when custom position is defined
] call ace_interact_menu_fnc_createAction;

// Put inside main actions if no other position was found above
if (_position isEqualTo [0, 0, 0]) then {
    [_type, 0, ["ACE_MainActions"], _infantryPhoneAction] call ace_interact_menu_fnc_addActionToClass;
    _target setVariable [QGVAR(infantryPhoneInfo), [_position, PHONE_MAXDISTANCE_DEFAULT]];
} else {
    [_type, 0, [], _infantryPhoneAction] call ace_interact_menu_fnc_addActionToClass;
    _target setVariable [QGVAR(infantryPhoneInfo), [_position, PHONE_MAXDISTANCE_HULL]];
};

// Passenger actions
private _infantryPhoneSpeakerAction = [
    QGVAR(infantryPhoneSpeaker),
    localize LSTRING(infantryPhone),
    ICON_RADIO_CALL,
    {true},
    {
        private _intercomNames = _target getVariable [QGVAR(intercomNames), []];
        private _intercomAvailable = false;
        // Find if at least one intercom is available
        {
            if ([_target, acre_player, _forEachIndex] call FUNC(isInfantryPhoneSpeakerAvailable)) exitWith {_intercomAvailable = true};
        } forEach _intercomNames;
        _intercomAvailable
    },
    {_this call FUNC(infantryPhoneChildrenActions)},
    [],
    [0, 0, 0],
    2,
    [false, true, false, false, false]
] call ace_interact_menu_fnc_createAction;
[_type, 1, ["ACE_SelfActions"], _infantryPhoneSpeakerAction] call ace_interact_menu_fnc_addActionToClass;
