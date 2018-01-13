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

LOG("Monitor Inventory Starting");
DFUNC(monitorRadios_PFH) = {
    if (!alive acre_player || side group acre_player == sideLogic || EGVAR(sys_core,arsenalOpen)) exitWith {};

    private _weapons = [acre_player] call EFUNC(sys_core,getGear);

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
                [acre_player, "ItemRadioAcreFlagged"] call EFUNC(sys_core,removeGear);
            };
            acre_player assignItem "ItemRadioAcreFlagged";
        };
    };

    private _currentUniqueItems = [];
    {
        if (GVAR(requestingNewId)) exitWith { };
        private _radio = _x;
        private _hasUnique = _radio call EFUNC(sys_radio,isBaseClassRadio);
        if (_hasUnique || _radio == "ItemRadio") then {

            GVAR(requestingNewId) = true;
            if (_radio == "ItemRadio") then {
                _radio = GVAR(defaultItemRadioType);
                [acre_player, "ItemRadio", _radio] call EFUNC(sys_core,replaceGear);
            };
            TRACE_1("Getting ID for", _radio);

            ["acre_getRadioId", [acre_player, _radio, QGVAR(returnRadioId)]] call CALLSTACK(CBA_fnc_serverEvent);
        };
        private _isUnique = _radio call EFUNC(sys_radio,isUniqueRadio);
        if (_isUnique) then {
            if (!([_radio] call EFUNC(sys_data,isRadioInitialized))) then {
                WARNING_1("%1 was found in personal inventory but is uninitialized! Trying to collect new ID.",_radio);
                private _baseRadio = BASECLASS(_radio);
                [acre_player, _radio, _baseRadio] call EFUNC(sys_core,replaceGear);
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

        // Update the radio list
        acre_player setVariable [QEGVAR(sys_data,radioIdList), _currentUniqueItems, true];
    };
    GVAR(oldUniqueItemList) = _currentUniqueItems;

    // if (!("ItemRadioAcreFlagged" in (assignedItems acre_player))) then { acre_player assignItem "ItemRadioAcreFlagged" };

};

[{ACRE_DATA_SYNCED && {(!isNil "ACRE_SERVER_INIT")} && {time >= 1}},{
    ADDPFH(FUNC(monitorRadios_PFH), 0.25, []);
},[]] call CBA_fnc_waitUntilAndExecute;
