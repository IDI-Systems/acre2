#include "script_component.hpp"
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
 * [] call acre_sys_server_fnc_masterIdTracker
 *
 * Public: No
 */

TRACE_1("Enter","");

if (diag_tickTime > GVAR(nextSearchTime)) then {
    GVAR(doFullSearch) = true;
};

// Short-scan checks that radios are with their last associated object.
if (!GVAR(doFullSearch)) then {
    //private _start = diag_tickTime;
    private _shortSearchList = HASH_KEYS(GVAR(masterIdTable))-GVAR(unacknowledgedIds);
    {
        private _uniqueId = _x;
        private _mainObject = HASH_GET(GVAR(masterIdTable),_uniqueId) select 0;
        // diag_log text format["main object: %1", _mainObject];
        if (isNil "_mainObject") exitWith { GVAR(doFullSearch) = true; };
        private _objects = [_mainObject];
        _objects append ((everyContainer _mainObject) apply {_x select 1});

        private _found = false;
        {
            private _object = _x;
            private _items = [];
            if (_object isKindOf "Man") then {
                _items = [_object] call EFUNC(sys_core,getGear);
            } else {
                _items = ((getItemCargo _object) select 0) select {(_x select [0, 4]) == "ACRE" || {_x == "ItemRadio"} || {_x == "ItemRadioAcreFlagged"}};
                {
                    _items pushBack _x; // Add rack unique ID
                    private _mountedRadio = [_x] call EFUNC(sys_rack,getMountedRadio);
                    if (_mountedRadio != "") then {
                        _items pushBack _mountedRadio; // Add mounted radio unique ID
                    };
                } forEach (_object getVariable [QEGVAR(sys_rack,vehicleRacks), []]);
            };

            {
                if (_uniqueId == _x) exitWith {_found = true};
            } forEach _items;
            if (_found) exitWith {};
        } forEach _objects;
        if (!_found) exitWith {GVAR(doFullSearch) = true;};
    } forEach _shortSearchList;
};

TRACE_2("Enter masterIdTracker",GVAR(doFullSearch),GVAR(nextSearchTime));
if (GVAR(doFullSearch)) then {
    GVAR(doFullSearch) = false;

    TRACE_1("Spawned master container search","");

    private _idTable = HASH_CREATE;
    private _idList = [];
    private _duplicateIdTable = HASH_CREATE;
    private _searchObjects = [];
    _searchObjects append allPlayers;
    _searchObjects append allUnits;
    _searchObjects append allDead;
    _searchObjects append vehicles;
    _searchObjects append (allMissionObjects "WeaponHolder");

    _searchObjects = _searchObjects arrayIntersect _searchObjects; // Ensure nothing gets searched twice.
    private _cfgWeapons = configFile >> "CfgWeapons";
    {
        private _mainObject = _x;
        private _objects = [_mainObject];
        _objects append ((everyContainer _mainObject) apply {_x select 1});

        {
            private _object = _x;
            private _items = [];
            if (_object isKindOf "Man") then {
                _items = [_object] call EFUNC(sys_core,getGear);
            } else {
                _items = ((getItemCargo _object) select 0) select {(_x select [0, 4]) == "ACRE"}; /* || _x == "ItemRadio" || _x == "ItemRadioAcreFlagged" // Only interested in unique IDs*/
            };

            {
                private _item = _x;
                if (_idList pushBackUnique _item != -1) then { // Add to ID list and this condition returns true if it was not present in the _idList.
                    HASH_SET(_idTable,_item,[ARR_2(_mainObject,_object)]);
                } else { // Already present in _idList
                    private _duplicateIdList = [];
                    if (!HASH_HASKEY(_duplicateIdTable,_item)) then {
                        HASH_SET(_duplicateIdTable,_item,_duplicateIdList);
                    } else {
                        _duplicateIdList = HASH_GET(_duplicateIdTable,_item);
                    };
                    _duplicateIdList pushBack [_mainObject, _object];
                };
            } forEach (_items select {_x call EFUNC(sys_radio,isUniqueRadio)});
        } forEach _objects;
    } forEach _searchObjects;
    // VEHICLE RACKS
    {

        if (getNumber (configOf _x >> "acre_isUnique") == 1) then {
            private _rackId = typeOf _x;
            private _vehicle = _x getVariable [QEGVAR(sys_rack,rackVehicle), objNull];
            private _mainObject = _x;
            if (isNull _vehicle || {!alive _vehicle}) then {
                deleteVehicle _x; // Acre racks should always be attached to something.
            } else {
                _mainObject = _vehicle;
                if (_idList pushBackUnique _rackId != -1) then { // Add to ID list and this condition returns true if it was not present in the _idList.
                    HASH_SET(_idTable,_rackId,[ARR_2(_mainObject,_x)]);
                } else { // Already present in _idList
                    private _duplicateIdList = [];
                    if (!HASH_HASKEY(_duplicateIdTable,_rackId)) then {
                        HASH_SET(_duplicateIdTable,_rackId,_duplicateIdList);
                    } else {
                        _duplicateIdList = HASH_GET(_duplicateIdTable,_rackId);
                    };
                    _duplicateIdList pushBack [_mainObject, _x];
                };
               //Mounted Radio
                private _mountedRadio = [_rackId] call EFUNC(sys_rack,getMountedRadio);
                if (_mountedRadio != "") then { // Radio is mounted.
                    if (getNumber (_cfgWeapons >> _mountedRadio >> "acre_isUnique") == 1) then {
                        if (_idList pushBackUnique _mountedRadio != -1) then { // Add to ID list and this condition returns true if it was not present in the _idList.
                            HASH_SET(_idTable,_mountedRadio,[ARR_2(_mainObject,_x)]);
                        } else { // Already present in _idList
                            private _duplicateIdList = [];
                            if (!HASH_HASKEY(_duplicateIdTable,_mountedRadio)) then {
                                HASH_SET(_duplicateIdTable,_mountedRadio,_duplicateIdList);
                            } else {
                                _duplicateIdList = HASH_GET(_duplicateIdTable,_mountedRadio);
                            };
                            _duplicateIdList pushBack [_mainObject, _x];
                        };
                    };
                };
            };
        };
    } forEach (nearestObjects [[-1000,-1000], ["ACRE_baseRack"], 1, true]);

    {
        private _key = _x;
        if (HASH_HASKEY(GVAR(masterIdTable),_key)) then {
            HASH_SET(_idTable,_key,HASH_GET(GVAR(masterIdTable),_key));
        } else {
            private _time = HASH_GET(GVAR(unacknowledgedTable),_key);

            if (time > _time + 10) then { // Allow 10 seconds before indiciating it is unacknowledged.
                #ifdef DEBUG_MODE_FULL
                    acre_player sideChat format["%1 ACRE WARNING: Unacknowledged key not found in masterIdTable (%2)", diag_tickTime, _key];
                #endif
                WARNING_1("Unacknowledged key not found in masterIdTable (%1)",_key);
                if (time > _time + 60) then { // Free up the ID after if it remains unclaimed after 60 seconds.
                    // Cleanup unacknowledge ID.
                    WARNING_1("Releasing unacknowledged key (%1)",_key);
                    GVAR(unacknowledgedIds) deleteAt (GVAR(unacknowledgedIds) find _key);
                    GVAR(masterIdList) deleteAt (GVAR(masterIdList) find _key);
                    HASH_REM(GVAR(unacknowledgedTable),_key);

                    private _baseRadio = [_key] call EFUNC(sys_radio,getRadioBaseClassname);
                    private _idNumber = getNumber (configFile >> "CfgWeapons" >> _key >> "acre_uniqueId");
                    private _keyIndex = (GVAR(radioIdMap) select 0) find (toLower _baseRadio);
                    if (_keyIndex != -1) then {
                        private _newIds = (GVAR(radioIdMap) select 1) select _keyIndex;
                        _newIds deleteAt (_newIds find _idNumber);
                        (GVAR(radioIdMap) select 1) set [_keyIndex, _newIds];
                    };
                };
            };
        };
    } forEach GVAR(unacknowledgedIds);

    {
        private _key = _x;
        private _duplicates = HASH_GET(_duplicateIdTable,_key);
        private _firstFound = HASH_GET(_idTable,_key);

        private _players = allPlayers;
        // firstFound is always a player if a player has the item.
        if ((_firstFound select 0) in _players) then {
            private _baseRadio = [_key] call EFUNC(sys_radio,getRadioBaseClassname);
            //Only collect firstFound if there are non-player objects with IDs as well.
            if ({!((_x select 0) in _players)} count _duplicates > 0) then {
                [(_firstFound select 0), _baseRadio, QEGVAR(sys_radio,returnRadioId), _key] call FUNC(onGetRadioId);
                WARNING_2("Duplicate radio ID found! Attempting replace of (%1 - %2)",name (_firstFound select 0),_key);
            };

            // Replace all duplicates that other players have.
            {
               private _data = _x;
               if ((_data select 0) in _players) then {
                   [(_data select 0), _baseRadio, QEGVAR(sys_radio,returnRadioId), _key] call FUNC(onGetRadioId);
                   WARNING_2("Duplicate radio ID found! Attempting replace of (%1 - %2)",name (_data select 0),_key);
               };
           } forEach _duplicates;
        };
    } forEach HASH_KEYS(_duplicateIdTable);
    private _unaccountedForIds = HASH_KEYS(GVAR(masterIdTable)) - HASH_KEYS(_idTable) - GVAR(unacknowledgedIds);
    {
        private _radio = _x;

        // GC handle
        if (HASH_HASKEY(GVAR(markedForGC),_radio)) then {
            private _value = HASH_GET(GVAR(markedForGC),_radio);
            _value params ["_timeMessage","_timeGC","_object"];

            if (time > _timeMessage + 20 && {time > _timeGC + 20}) then { // GC
                #ifdef DEBUG_MODE_FULL
                    acre_player sideChat "Collecting Unaccounted";
                    TRACE_1("Collecting",_radio);
                #endif
                [_radio] call FUNC(collect);
            } else {
                HASH_SET(_idTable,_radio,[ARR_2(_object,_object)]);
            };
        } else {
            [_radio] call FUNC(sendIntentToGarbageCollect);
            // Act as if nothing has happened just yet.
            if (HASH_HASKEY(GVAR(masterIdTable),_radio)) then {
                HASH_SET(_idTable,_radio,HASH_GET(GVAR(masterIdTable),_radio));
            };
        };
    } forEach _unaccountedForIds;

    private _toUpdate = [];
    {
        private _key = _x;
        private _value = HASH_GET(_idTable,_key);

        if (HASH_HASKEY(GVAR(masterIdTable),_key)) then {
            private _currentEntry = HASH_GET(GVAR(masterIdTable),_key);
            if (_value isNotEqualTo _currentEntry) then {
                _toUpdate pushBack [_key, _value];
            };
        } else {
            #ifdef DEBUG_MODE_FULL
                acre_player sideChat format["%1 ACRE WARNING: Id object relation created independently of unique ID creation process (%2)", diag_tickTime, _key];
            #endif
            WARNING_1("Id object relation created independently of unique ID creation process (%1)!",_key);
            _toUpdate pushBack [_key, _value];
        };
    } forEach ((HASH_KEYS(_idTable)) - GVAR(unacknowledgedIds));

    if (_toUpdate isNotEqualTo []) then {
        #ifdef DEBUG_MODE_FULL
            TRACE_1("calling updateIdObjects",_toUpdate);
            acre_player sideChat "Calling updateIdObjects";
        #endif
        ["acre_updateIdObjects", _toUpdate] call CALLSTACK(CBA_fnc_globalEvent);
    };
    GVAR(masterIdTable) = _idTable;
    GVAR(nextSearchTime) = diag_tickTime + 10;

    TRACE_1("COMPLETE crate search",GVAR(nextSearchTime));

};
//private _end = diag_tickTime;
