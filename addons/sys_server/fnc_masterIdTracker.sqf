/*
 * Author: ACRE2Team
 * Searches all containers periodically to keep track of ACRE items with unique IDs.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_server_fnc_masterIdTracker
 *
 * Public: No
 */
#include "script_component.hpp"

TRACE_1("Enter", "");

if(diag_tickTime > GVAR(nextSearchTime)) then {
    GVAR(doFullSearch) = true;
};

// Short-scan checks that radios are with their last associated object.
if (!GVAR(doFullSearch)) then {
    //private _start = diag_tickTime;
    private _shortSearchList = HASH_KEYS(GVAR(masterIdTable))-GVAR(unacknowledgedIds);
    {
        private _uniqueId = _x;
        private _mainObject = HASH_GET(GVAR(masterIdTable), _uniqueId) select 0;
        // diag_log text format["main object: %1", _mainObject];
        if(isNil "_mainObject") exitWith { GVAR(doFullSearch) = true; };
        private _objects = [_mainObject];
        private _allContainers = (everyContainer _mainObject);
        {
            _objects pushBack (_x select 1);
        } forEach _allContainers;

        private _found = false;
        {
            private _object = _x;
            private _items = [];
            if(_object isKindOf "Man") then {
                _items = [_object] call EFUNC(lib,getGear);
            } else {
                _items = itemCargo _object;
                _items = _items select {(_x select [0, 4]) == "ACRE" || _x == "ItemRadio" || _x == "ItemRadioAcreFlagged"};
            };

            {
                if (_uniqueId == _x) exitWith {_found = true};
            } forEach _items;
            if (_found) exitWith {};
        } forEach _objects;
        if(!_found) exitWith { GVAR(doFullSearch) = true; };
    } forEach _shortSearchList;
};

TRACE_2("Enter masterIdTracker", GVAR(doFullSearch), GVAR(nextSearchTime) );
if(GVAR(doFullSearch)) then {
    GVAR(doFullSearch) = false;

    TRACE_1("Spawned master container search", "");

    private _idTable = HASH_CREATE;
    private _idList = [];
    private _duplicateIdTable = HASH_CREATE;
    private _searchObjects = allPlayers + allUnits + allDead + vehicles + (allMissionObjects "WeaponHolder"); // search players first

    private _searchedObjects = [];
    private _cfgWeapons = configFile >> "CfgWeapons";
    {
        private _mainObject = _x;
        if(_searchedObjects pushBackUnique _mainObject != -1) then { // If not already searched
            private _objects = [_mainObject];
            private _allContainers = (everyContainer _mainObject);
            {
                _objects pushBack (_x select 1);
            } forEach _allContainers;
            {
                private _object = _x;
                private _items = [];
                if(_object isKindOf "Man") then {
                    _items = [_object] call EFUNC(lib,getGear);
                } else {
                    _items = itemCargo _object;
                    _items = _items select {(_x select [0, 4]) == "ACRE"}; /* || _x == "ItemRadio" || _x == "ItemRadioAcreFlagged" // Only interested in unique IDs*/
                };

                {
                    private _item = _x;
                    if(getNumber(_cfgWeapons >> _item >> "acre_isUnique") == 1) then {
                        if (_idList pushBackUnique _item != -1) then { // Add to ID list and this condition returns true if it was not present in the _idList.
                            HASH_SET(_idTable, _item, ARR_2(_mainObject, _object));
                        } else { // Already present in _idList
                            private _duplicateIdList = [];
                            if(!HASH_HASKEY(_duplicateIdTable, _item)) then {
                                HASH_SET(_duplicateIdTable, _item, _duplicateIdList);
                            } else {
                                HASH_GET(_duplicateIdTable, _item);
                            };
                            _duplicateIdList pushBack [_mainObject, _object];
                        };
                    };
                } forEach _items;
            } forEach _objects;
        };
    } forEach _searchObjects;
    {
        private _key = _x;
        if(HASH_HASKEY(GVAR(masterIdTable), _key)) then {
            HASH_SET(_idTable, _key, HASH_GET(GVAR(masterIdTable), _key));
        } else {
            #ifdef DEBUG_MODE_FULL
                acre_player sideChat format["%1 ACRE WARNING: Unacknowledged key not found in masterIdTable (%2)", diag_tickTime, _key];
            #endif
            diag_log text format["%1 ACRE WARNING: Unacknowledged key not found in masterIdTable (%2)", diag_tickTime, _key];
        };
    } forEach GVAR(unacknowledgedIds);

    {
        private _key = _x;
        private _duplicates = HASH_GET(_duplicateIdTable, _key);
        private _firstFound = HASH_GET(_idTable, _key);

        private _players = allPlayers;
        // firstFound is always a player if a player has the item.
        if((_firstFound select 0) in _players) then {
            private _baseRadio = configName (inheritsFrom (_cfgWeapons >> _key));
            //Only collect firstFound if there are non-player objects with IDs as well.
            if ({!((_x select 0) in _players)} count _duplicates > 0) then {
                [(_firstFound select 0), _baseRadio, "acre_sys_radio_returnRadioId", _key] call FUNC(onGetRadioId);
                diag_log text format["%1 ACRE WARNING: Duplicate radio ID found attemping replace of (%2,%3)", diag_tickTime, name (_firstFound select 0), _key];
            };

            // Replace all duplicates that other players have.
            {
               private _data = _x;
               if((_data select 0) in _players) then {
                   [(_data select 0), _baseRadio, "acre_sys_radio_returnRadioId", _key] call FUNC(onGetRadioId);
                   diag_log text format["%1 ACRE WARNING: Duplicate radio ID found attemping replace of (%2,%3)", diag_tickTime, name (_data select 0), _key];
               };
           } forEach _duplicates;
        };
    } forEach HASH_KEYS(_duplicateIdTable);
    private _unaccountedForIds = HASH_KEYS(GVAR(masterIdTable)) - HASH_KEYS(_idTable) - GVAR(unacknowledgedIds);
    {
        #ifdef DEBUG_MODE_FULL
            acre_player sideChat "Collecting Unaccounted";
            TRACE_1("Collecting", _x);
        #endif
        [_x] call FUNC(collect);
    } forEach _unaccountedForIds;
    private _toUpdate = [];
    {
        private _key = _x;
        if(!(_key in GVAR(unacknowledgedIds))) then {
            private _value = HASH_GET(_idTable, _key);

            if(HASH_HASKEY(GVAR(masterIdTable), _key)) then {
                private _currentEntry = HASH_GET(GVAR(masterIdTable), _key);
                if(!(_value isEqualTo _currentEntry)) then {
                    _toUpdate pushBack [_key, _value];
                };
            } else {
                #ifdef DEBUG_MODE_FULL
                    acre_player sideChat format["%1 ACRE WARNING: Id object relation created independently of unique ID creation process (%2)", diag_tickTime, _key];
                #endif
                diag_log text format["%1 ACRE WARNING: Id object relation created independently of unique ID creation process (%2)", diag_tickTime, _key];
                _toUpdate pushBack [_key, _value];
            };
        };
    } forEach HASH_KEYS(_idTable);
    if((count _toUpdate) > 0) then {
        #ifdef DEBUG_MODE_FULL
            TRACE_1("calling updateIdObjects", _toUpdate);
            acre_player sideChat "Calling updateIdObjects";
        #endif
        ["acre_updateIdObjects", _toUpdate] call CALLSTACK(LIB_fnc_globalEvent);
    };
    GVAR(masterIdTable) = _idTable;
    GVAR(nextSearchTime) = diag_tickTime + 10;

    TRACE_1("COMPLETE crate search", GVAR(nextSearchTime));

};
//private _end = diag_tickTime;
