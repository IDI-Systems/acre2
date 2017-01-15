/*
 * Author: ACRE2Team
 * Sets up the per frame event handler for monitoring the local player inventory for changes.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_core_fnc_monitorRadios
 *
 * Public: No
 */
#include "script_component.hpp"

GVAR(oldUniqueItemList) = [];
GVAR(forceRecheck) = false;
GVAR(requestingNewId) = false;
ACRE_SERVER_GEAR_DESYNCED = false;
ACRE_SERVER_GEAR_DESYNC_CHECK = false;

ACRE_SERVER_GEAR_DESYNC_CHECK_STAGE = 0;

ACRE_SERVER_GEAR_DESYNC_TIME = diag_tickTime;
ACRE_SERVER_GEAR_DESYNC_REQUESTCOUNT = 0;
ACRE_SERVER_DESYNCED_PLAYERS = [];

LOG("Monitor Inventory Starting");
DFUNC(monitorRadios_PFH) = {
    if (!alive acre_player) exitWith {};
    if ((side group acre_player) == sideLogic) exitWith {};

    private _weapons = [acre_player] call EFUNC(lib,getGear);

    // Handle ItemRadioAcreFlagged - This is a dummy ItemRadio that allows the player to continue using ingame text chat.

    if (!ACRE_HOLD_OFF_ITEMRADIO_CHECK && {!("ItemRadio" in _weapons)} && {!("ItemRadioAcreFlagged" in _weapons)}) then {
        acre_player linkItem "ItemRadioAcreFlagged"; // Only ItemRadio/ItemRadioAcreFlagged can be in the linked item slot for Radios.
    } else {
        if (!ACRE_HOLD_OFF_ITEMRADIO_CHECK && {"ItemRadioAcreFlagged" in _weapons} && {!("ItemRadioAcreFlagged" in (assignedItems acre_player))}) then {
            acre_player assignItem "ItemRadioAcreFlagged";
        };
    };

    if ("ItemRadioAcreFlagged" in _weapons) then {
        // Only allow 1 ItemRadioAcreFlagged
        private _flaggedCount = {_x == "ItemRadioAcreFlagged"} count _weapons;

        if (_flaggedCount > 1) then {
            for "_i" from 1 to (_flaggedCount - 1) do {
                [acre_player, "ItemRadioAcreFlagged"] call EFUNC(lib,removeGear);
            };
            acre_player assignItem "ItemRadioAcreFlagged";
        };
    };

    private _currentUniqueItems = [];
    {
        if (GVAR(requestingNewId)) exitWith { };
        private _radio = _x;
        private _hasUnique = getNumber (configFile >> "CfgWeapons" >> _radio >> "acre_hasUnique");
        if (_hasUnique == 1 || _radio == "ItemRadio") then {

            GVAR(requestingNewId) = true;
            if (_radio == "ItemRadio") then {
                _radio = GVAR(defaultItemRadioType);
                [acre_player, "ItemRadio", _radio] call EFUNC(lib,replaceGear);
            };
            TRACE_1("Getting ID for", _radio);
            if (diag_tickTime-ACRE_SERVER_GEAR_DESYNC_TIME < 60) then {
                ACRE_SERVER_GEAR_DESYNC_REQUESTCOUNT = ACRE_SERVER_GEAR_DESYNC_REQUESTCOUNT + 1;
                if (ACRE_SERVER_GEAR_DESYNC_REQUESTCOUNT > 10 && !ACRE_SERVER_GEAR_DESYNC_CHECK) then {
                    ACRE_SERVER_GEAR_DESYNC_CHECK = true;
                };
            } else {
                ACRE_SERVER_GEAR_DESYNC_TIME = diag_tickTime;
                ACRE_SERVER_GEAR_DESYNC_REQUESTCOUNT = 0;
            };

            ["acre_getRadioId", [acre_player, _radio, QGVAR(returnRadioId)]] call CALLSTACK(CBA_fnc_globalEvent);
        };
        private _isUnique = getNumber (configFile >> "CfgWeapons" >> _radio >> "acre_isUnique");
        if (_isUnique == 1) then {
            if (!([_radio] call EFUNC(sys_data,isRadioInitialized))) then {
                WARNING_1("%1 was found in personal inventory but is uninitialized! Trying to collect new ID.",_radio);
                _baseRadio = BASECLASS(_radio);
                [acre_player, _radio, _baseRadio] call EFUNC(lib,replaceGear);
                _radio = _baseRadio;
            };
            _currentUniqueItems pushBack _radio;
        };
    } forEach _weapons;

    //_dif = (GVAR(oldUniqueItemList) + _currentUniqueItems) - (GVAR(oldUniqueItemList) arrayIntersect _currentUniqueItems); same speed..
    private _dif1 = GVAR(oldUniqueItemList) - _currentUniqueItems;
    private _dif2 = _currentUniqueItems - GVAR(oldUniqueItemList);
    private _dif = _dif1 + _dif2;
    if ((count _dif) > 0) then {
        {
            if (_x in _currentUniqueItems) then {
                [(_currentUniqueItems select 0)] call EFUNC(sys_radio,setActiveRadio);
            } else {
                if (_x == ACRE_ACTIVE_RADIO) then {
                    if (_x == ACRE_BROADCASTING_RADIOID) then {
                        // simulate a key up event to end the current transmission
                        [] call EFUNC(sys_core,handleMultiPttKeyPressUp);
                    };
                    if ((count _currentUniqueItems) > 0) then {
                        [_currentUniqueItems select 0] call EFUNC(sys_radio,setActiveRadio);
                    } else {
                        [""] call EFUNC(sys_radio,setActiveRadio);
                    };
                };
            };
            if (ACRE_HOLD_OFF_ITEMRADIO_CHECK) then {
                ACRE_HOLD_OFF_ITEMRADIO_CHECK = false;
                acre_player assignItem "ItemRadioAcreFlagged";
            };
        } forEach _dif;
    };
    GVAR(oldUniqueItemList) = _currentUniqueItems;
    // if (!("ItemRadioAcreFlagged" in (assignedItems acre_player))) then { acre_player assignItem "ItemRadioAcreFlagged" };

};

[{ACRE_DATA_SYNCED && {(!isNil "ACRE_SERVER_INIT")} && {time >= 1}},{
    ADDPFH(FUNC(monitorRadios_PFH), 0.25, []);
},[]] call CBA_fnc_waitUntilAndExecute;


DFUNC(handleDesyncCheck) = {
    params ["_player", "_isDesynced"];
    if (_player == acre_player) then {
        if (_isDesynced && {"ACRE_TestGearDesyncItem" in (items acre_player)}) then {
            acre_player removeItem "ACRE_TestGearDesyncItem";
            ACRE_SERVER_GEAR_DESYNCED = true;
            ACRE_SERVER_DESYNCED_PLAYERS pushBack _player;
            publicVariable "ACRE_SERVER_GEAR_DESYNCED";
            publicVariable "ACRE_SERVER_DESYNCED_PLAYERS";
        } else {
            ACRE_SERVER_GEAR_DESYNC_CHECK_STAGE = 0;
            ACRE_SERVER_GEAR_DESYNC_CHECK = false;
            ACRE_SERVER_GEAR_DESYNC_REQUESTCOUNT = 0;
            if ("ACRE_TestGearDesyncItem" in (items acre_player)) then {
                acre_player removeItem "ACRE_TestGearDesyncItem";
            };
        };
    };
};

DFUNC(checkServerDesyncBug) = {
    if (ACRE_SERVER_GEAR_DESYNC_CHECK) then {
        switch (ACRE_SERVER_GEAR_DESYNC_CHECK_STAGE) do {
            case 0: {
                [acre_player, "ACRE_TestGearDesyncItem"] call EFUNC(lib,addGear);
                ACRE_SERVER_GEAR_DESYNC_CHECK_STAGE = 1;
            };
            case 1: {
                if ("ACRE_TestGearDesyncItem" in (items acre_player)) then {
                    ACRE_SERVER_GEAR_DESYNC_CHECK_STAGE = 2;
                    ["acre_checkServerGearDesync", [acre_player]] call CALLSTACK(CBA_fnc_globalEvent);
                };
            };
            case 2: {

            };
        };
    };
};

ADDPFH(FUNC(checkServerDesyncBug), 1, []);

DFUNC(hasGearDesync) = {
    if (ACRE_SERVER_GEAR_DESYNCED) then {
        private _message = "ACRE has determined that players in this mission have an inventory that has desynchronized from the server, this is due to a bug in the mission or a bug in Arma 3, NOT ACRE. This message will not dissappear and is a warning that ACRE may no longer be functioning correctly in this mission. The players experiencing the bug are listed below:\n\n";
        {
            _message = _message + format ["%1\n", name _x];
        } forEach ACRE_SERVER_DESYNCED_PLAYERS;
        if (!GVAR(disableDesyncHint)) then {
            hintSilent _message;
        };
        WARNING(_message);
    };
};

ADDPFH(FUNC(hasGearDesync), 10, []);
