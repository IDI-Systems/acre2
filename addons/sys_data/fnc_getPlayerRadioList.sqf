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
#include "script_component.hpp"

private _radioList = [];

if (alive acre_player) then {
    private _weapons = [acre_player] call EFUNC(sys_core,getGear);
    _radioList = _weapons select {_x call EFUNC(sys_radio,isUniqueRadio)};

    // Remove those radios that are being actively used by other players.
    private _externalRadiosInUse = _radioList select {_x call EFUNC(sys_external,isExternalRadioUsed)};
    _radioList = _radioList - _externalRadiosInUse;

    // External radios not in the inventory of the player
    {
        _radioList pushBackUnique _x;
    } forEach ACRE_ACTIVE_EXTERNAL_RADIOS;

    if (ACRE_ACTIVE_RADIO != "") then {
        _radioList pushBackUnique ACRE_ACTIVE_RADIO;
    };
} else {
    _radioList = ACRE_SPECTATOR_RADIOS;
};

_radioList
