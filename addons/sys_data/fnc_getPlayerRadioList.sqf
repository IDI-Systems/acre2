#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Retrieves a list of unique radio IDs that can be accessed by a player. This includes radios in the inventory that are not being
 * used externally and those radios that are used externally.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Array of unique radio IDs <ARRAY>
 *
 * Example:
 * [] call acre_sys_data_fnc_getPlayerRadioList
 *
 * Public: No
 */

private _radioList = [];

if (!ACRE_IS_SPECTATOR) then {
    private _weapons = [acre_player] call EFUNC(sys_core,getGear);
    _radioList = _weapons select {_x call EFUNC(sys_radio,isUniqueRadio) && {!(_x call EFUNC(sys_external,isExternalRadioUsed))}};

    // External radios not in the inventory of the player
    {
        _radioList pushBackUnique _x;
    } forEach ACRE_ACTIVE_EXTERNAL_RADIOS;

    // Radios in the inventory of the player that are being used externally but cannot be used by the player (receive/transmit). They can still be configured, e.g. manpack radios
    {
        _radioList pushBackUnique _x;
    } forEach ACRE_EXTERNALLY_USED_PERSONAL_RADIOS;

    // Radios in the inventory of the player that are being used externally but can still be used by the player, e.g. manpack radios
    {
        _radioList pushBackUnique _x;
    } forEach ACRE_EXTERNALLY_USED_MANPACK_RADIOS;

    // Auxilary radios are for radios not in inventory like racked radios
    {
        _radioList pushBackUnique _x;
    } forEach ACRE_ACCESSIBLE_RACK_RADIOS;

    // Racked radios that cannot be physically accessed but are connected to the same intercom as the player
    {
        _radioList pushBackUnique _x;
    } forEach ACRE_HEARABLE_RACK_RADIOS;

    // If Arsenal is open radios are stashed in var until left
    {
        _radioList pushBackUnique _x;
    } forEach ACRE_ARSENAL_RADIOS;

    // If Arsenal is open radios are stashed in var until left
    {
        _radioList pushBackUnique _x;
    } forEach ACRE_ARSENAL_RADIOS;

    if (ACRE_ACTIVE_RADIO != "") then {
        _radioList pushBackUnique ACRE_ACTIVE_RADIO;
    };
} else {
    _radioList = ACRE_SPECTATOR_RADIOS;
};

_radioList
