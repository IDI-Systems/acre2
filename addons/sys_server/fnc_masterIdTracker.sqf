/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

TRACE_1("Enter", "");

if(diag_tickTime > GVAR(nextSearchTime)) then {
    GVAR(doFullSearch) = true;
};

if (!GVAR(doFullSearch)) then {
    //private _start = diag_tickTime;
    private _shortSearchList = HASH_KEYS(GVAR(masterIdTable))-GVAR(unacknowledgedIds);
    {
        private _uniqueId = _x;
        private _mainObject = HASH_GET(GVAR(masterIdTable), _uniqueId) select 0;
        // diag_log text format["main object: %1", _mainObject];
        if(isNil "_mainObject") exitWith { GVAR(doFullSearch) = true; };
        private _objects = [_mainObject];
        #ifdef PLATFORM_A3
        private _allContainers = (everyContainer _mainObject);
        {
            _objects pushBack (_x select 1);
        } forEach _allContainers;
        #endif
        private _found = false;
        {
            private _object = _x;
            private _items = [];
            if(_object isKindOf "Man") then {
                _items = [_object] call EFUNC(lib,getGear);
            } else {
                #ifdef PLATFORM_A3
                _items = itemCargo _object;
                _items = _items select {(_x select [0, 4]) == "ACRE" || _x == "ItemRadio" || _x == "ItemRadioAcreFlagged"};
                #endif
                #ifdef PLATFORM_A2
                _items = (getWeaponCargo _object) select 0;
                #endif
            };

            {
                if (_uniqueId == _x) exitWith {_found = true};
            } forEach _items;
            if (_found) exitWith {};
        } forEach _objects;
        if(!_found) exitWith { GVAR(doFullSearch) = true; };
    } forEach _shortSearchList;
};

TRACE_3("Enter masterIdTracker", GVAR(doFullSearch), GVAR(fullSearchRunning), GVAR(nextSearchTime) );
if(GVAR(doFullSearch) && !GVAR(fullSearchRunning) ) then {
    // if(GVAR(waitingForIdAck) && (count GVAR(unacknowledgedIds)) <= 0) then {
        // GVAR(waitingForIdAck) = false;
    // };

    GVAR(fullSearchRunning) = true;
    GVAR(doFullSearch) = false;
    //[] spawn {
        TRACE_1("Spawned master container search", "");

        private _ammoHolders = allMissionObjects "WeaponHolder";
        private _idTable = HASH_CREATE;
        private _idList = [];
        private _duplicateIdTable = HASH_CREATE;

        private _searchObjects = playableUnits + ACRE_getAllCuratorObjects + allUnits + allDead + vehicles; // search players, search alive people, then bodies, then onground ammo holders, then vehicles
        _searchObjects append _ammoHolders;
        if(hasInterface) then {
            _searchObjects pushBack acre_player;
        };
        private _searchedObjects = [];
        private _cfgWeapons = configFile >> "CfgWeapons";
        {
            private _mainObject = _x;
            if(_searchedObjects pushBackUnique _mainObject != -1) then { // If not already searched
                //_objects = [_x] + (everyContainer _x); // ok in 1.20 for A3, not so much before
                private _objects = [_mainObject];
                #ifdef PLATFORM_A3
                private _allContainers = (everyContainer _mainObject);
                {
                    _objects pushBack (_x select 1);
                } forEach _allContainers;
                #endif
                {
                    private _object = _x;
                    private _items = [];
                    if(_object isKindOf "Man") then {
                        _items = [_object] call EFUNC(lib,getGear);
                    } else {
                        #ifdef PLATFORM_A3
                        _items = itemCargo _object;
                        _items = _items select {(_x select [0, 4]) == "ACRE" || _x == "ItemRadio" || _x == "ItemRadioAcreFlagged"};
                        #endif
                        #ifdef PLATFORM_A2
                        _items = (getWeaponCargo _object) select 0;
                        #endif
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
            // if the first location is a human then we need to check if the radio exists
            // on anyone else or in any other ammo holders.
            private _players = playableUnits + ACRE_getAllCuratorObjects;
            if(hasInterface) then {
                _players pushBack acre_player;
            };
            if((_firstFound select 0) in _players) then {
                private _baseRadio = configName (inheritsFrom (_cfgWeapons >> _key));
                [(_firstFound select 0), _baseRadio, "acre_sys_radio_returnRadioId", _key] call FUNC(onGetRadioId);
                private _clearRemainder = 0;
                {
                    private _data = _x;
                    if((_data select 0) in _players) then {
                        [(_data select 0), _baseRadio, "acre_sys_radio_returnRadioId", _key] call FUNC(onGetRadioId);
                    } else {
                        _clearRemainder = _clearRemainder + 1;
                    };
                } forEach _duplicates;
                // if there is more than one non-human inventory that a unique ID is in clear it
                // we shouldn't have multiple unique ids in ammo holders.
                if(_clearRemainder > 1) then {
                    #ifdef DEBUG_MODE_FULL
                        acre_player sideChat "Collecting Left over dupes";
                        TRACE_1("Collecting", _key);
                    #endif
                    [_key] call FUNC(collect);
                };
            } else {
                // if it isn't we clear out that unique ID. A unique ID should never exist
                // in more than one place.
                acre_player sideChat "Collecting Multiple Ammo Holders";
                TRACE_1("Collecting", _key);
                [_key] call FUNC(collect);
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
        GVAR(fullSearchRunning) = false;

        TRACE_2("COMPLETE crate search", GVAR(nextSearchTime), GVAR(fullSearchRunning) );
    //};
};
//private _end = diag_tickTime;
