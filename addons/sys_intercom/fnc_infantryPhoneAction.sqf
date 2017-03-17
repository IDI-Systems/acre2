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
 * [cursorTarget] call acre_sys_intercom_infantryPhoneAction
 *
 * Public: No
 */
#include "script_component.hpp"

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
    _position = _target selectionPosition (getText _positionConfig); // Convert to coordinates for sys_core vehicleCrewPFH checks
};
if (isArray _positionConfig) then {
    _position = getArray _positionConfig;
};

// Configure what intercom networks the infantry phone has access to
private _infantryPhoneIntercom = getArray (configFile >> "CfgVehicles" >> _type >> "acre_infantryPhoneIntercom");

// Set by default to have access to all intercom networks if none was specified
if (count _infantryPhoneIntercom ==  0) then {
    if (getNumber (configFile >> "CfgVehicles" >> _type >> "acre_hasCrewIntercom") == 1) then {
        _infantryPhoneIntercom = ["crew"];
    };
    if (getNumber (configFile >> "CfgVehicles" >> _type >> "acre_hasPassengerIntercom") == 1) then {
        _infantryPhoneIntercom pushBack "passenger";
    };
};

_target setVariable [QGVAR(infantryPhoneIntercom), _infantryPhoneIntercom, true];

private _infantryPhoneAction = [
    QGVAR(infantryPhone),
    localize LSTRING(infantryPhone),
    ICON_RADIO_CALL,
    {true},
    {
         // Only manually check distance if under main node (not a custom position on hull)
         // Main interaction node is not shown on destroyed vehicle, so we only check that if not main node
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
    {_this call FUNC(isInfantryPhoneSpeakerAvailable)},
    {_this call FUNC(infantryPhoneChildrenActions)},
    [],
    [0, 0, 0],
    2,
    [false, true, false, false, false]
] call ace_interact_menu_fnc_createAction;
[_type, 1, ["ACE_SelfActions"], _infantryPhoneSpeakerAction] call ace_interact_menu_fnc_addActionToClass;
