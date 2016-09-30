#include "script_component.hpp"

// Lib - @todo put into functions in sys_core and rename to component sys_core across the board

ADDON = false;
ACRE_STACK_TRACE = [];
ACRE_STACK_DEPTH = 0;
ACRE_CURRENT_FUNCTION = "";
INFO("Library loaded.")

EFUNC(lib,getGear) = {
    params["_unit"];
    if (isNull _unit) exitWith {[]};
    // diag_log text format["Assigned Items: %1", (assignedItems _unit)];
    private _gear = (weapons _unit) + (items _unit) + (assignedItems _unit);
    _gear = _gear select {(_x select [0, 4]) == "ACRE" || _x == "ItemRadio" || _x == "ItemRadioAcreFlagged"}; // We are only interested in ACRE gear.
    // The below is really slow and tends to worsen performance.
    //_gear = _gear select {(_x call EFUNC(api,getBaseRadio)) in (call EFUNC(api,getAllRadios) select 0) || {_x == "ItemRadio"} || {_x == "ItemRadioAcreFlagged"}};
    _gear;
};

EFUNC(lib,replaceGear) = {
    params["_unit", "_itemToReplace", "_itemReplaceWith"];

    private _uniform = (uniformContainer _unit);
    if (!isNull _uniform && {_itemToReplace in (itemCargo _uniform)}) exitWith {
        _unit removeItem _itemToReplace;
        _uniform addItemCargoGlobal [_itemReplaceWith, 1]; // circumvent limit
    };

    private _vest = (vestContainer _unit);
    if (!isNull _vest && {_itemToReplace in (itemCargo _vest)}) exitWith {
        _unit removeItem _itemToReplace;
        _vest addItemCargoGlobal [_itemReplaceWith, 1]; // circumvent limit
    };

    private _backpack = (backpackContainer _unit);
    if (!isNull _backpack && {_itemToReplace in (itemCargo _backpack)}) exitWith {
        _unit removeItem _itemToReplace;
        _backpack addItemCargoGlobal [_itemReplaceWith, 1]; // circumvent limit
    };

    private _assignedItems = assignedItems _unit;
    if(_itemToReplace in _assignedItems) then {
        _unit unassignItem _itemToReplace;
    };

    private _weapons = weapons _unit;
    if(_itemToReplace in _weapons) exitWith {
        _unit removeWeapon _itemToReplace;
        _unit addWeapon _itemReplaceWith;
    };

    _unit removeItem _itemToReplace;
    if (_unit canAdd _itemReplaceWith) then {
        _unit addItem _itemReplaceWith;
    } else {
        if (!isNull _uniform) exitWith { _uniform addItemCargoGlobal [_itemReplaceWith, 1];};
        if (!isNull _vest) exitWith { _vest addItemCargoGlobal [_itemReplaceWith, 1];};
        if (!isNull _backpack) exitWith { _backpack addItemCargoGlobal [_itemReplaceWith, 1];};
        INFO("Unable to add '%1' to inventory.",_itemReplaceWith);
        hintSilent format ["ACRE2: Unable to add '%1' to your inventory.", _itemReplaceWith];
    };
};

EFUNC(lib,removeGear) = {
    params["_unit", "_item"];

    /*_weapons = weapons _unit;
    _uniformItems = uniformItems _unit;
    _vestItems = vestItems _unit;
    _backpackItems = backpackitems _unit;*/
    private _assignedItems = assignedItems _unit;

    if(_item in _assignedItems) then {
        _unit unassignitem _item;
    };
    _unit removeItem _item;
    _unit removeWeapon _item;
    // _gearCheck = [_unit] call FUNC(getGear);
    // if(_item in _gearCheck) then {

    // };
};

EFUNC(lib,addGear) = {
    params["_unit", "_item",["_gearContainer",""]];

    if( _gearContainer != "") then {
        switch _gearContainer do {
            case 'vest': {
                _unit addItemToVest _item;
            };
            case 'uniform': {
                _unit addItemToUniform _item;
            };
            case 'backpack': {
                _unit addItemToBackpack _item;
            };
        };
    } else {
        if (_unit canAdd _item) then {
            _unit addItem _item;
        } else {
            // Attempt to force add Item.
            private _uniform = (uniformContainer _unit);
            if (!isNull _uniform) exitWith { _uniform addItemCargoGlobal [_item, 1];};
            private _vest = (vestContainer _unit);
            if (!isNull _vest) exitWith { _vest addItemCargoGlobal [_item, 1];};
            private _backpack = (backpackContainer _unit);
            if (!isNull _backpack) exitWith { _backpack addItemCargoGlobal [_item, 1];};
        };
    };
};

ACRE_DUMPSTACK_FNC = {
    diag_log text format["ACRE CALL STACK DUMP: %1:%2(%3) DEPTH: %4", _this select 0, _this select 1, ACRE_CURRENT_FUNCTION, ACRE_STACK_DEPTH];
    for "_x" from ACRE_STACK_DEPTH-1 to 0 step -1 do {
        _stackEntry = ACRE_STACK_TRACE select _x;
        _stackEntry params ["_callTickTime", "_callFileName", "_callLineNumb", "_callFuncName", "_nextFuncName", "_nextFuncArgs"];

        if(_callFuncName == "") then {
            _callFuncName = "<root>";
        };

        diag_log text format["%8%1:%2 | %3:%4(%5) => %6(%7)",
            _x+1,
            _callTickTime,
            _callFileName,
            _callLineNumb,
            _callFuncName,
            _nextFuncName,
            _nextFuncArgs,
            toString [9]
            ];
    };
};

EFUNC(lib,getCompartment) = {
    params["_unit"];
    private _vehicle = (vehicle _unit);
    private _compartment = "";
    if(_vehicle != _unit) then {
        private _defaultCompartment = "Compartment1";
        private _cfg = configFile >> "CfgVehicles" >> typeOf _vehicle;
        private _assignedRole = assignedVehicleRole _unit;
        if((_assignedRole select 0) == "Driver") then {
            _compartment = getText(_cfg >> "driverCompartments");
            if(_compartment == "") then {
                _compartment = _defaultCompartment;
            };
        } else {
            if((_assignedRole select 0) == "Turret") then {
                private _turretPath = _assignedRole select 1;
                private _turret = [_vehicle, _turretPath] call CBA_fnc_getTurret;
                _compartment = getText(_turret >> "gunnerCompartments");
                if(_compartment == "") then {
                    _compartment = getText(_cfg >> "driverCompartments");
                    if(_compartment == "") then {
                        _compartment = _defaultCompartment;
                    };
                };
            } else {
                if((_assignedRole select 0) == "Cargo") then {
                    private _cargoCompartments = getArray(_cfg >> "cargoCompartments");
                    if((count _cargoCompartments) > 0) then {
                        private _index = -1;
                        // if((productVersion select 3) < 126064) then {
                            // _index = (count _attenuateCargo)-1; // wait for command to get cargo index
                        // } else {
                            _index = _vehicle getCargoIndex _unit;
                        // };
                        if(_index > -1) then {
                            if(_index > (count _cargoCompartments)-1) then {
                                _index = (count _cargoCompartments)-1;
                            };

                            _compartment = _cargoCompartments select _index;
                        } else {
                            _compartment = _defaultCompartment;
                        };
                    } else {
                        _compartment = _defaultCompartment;
                    };
                };
            };
        };
    };
    if(!(typeName _compartment == "STRING")) then {
        _compartment = _defaultCompartment;
    };
    _compartment;
};

EFUNC(lib,fastHashCreate) = {
    if(count FAST_HASH_POOL > 0) exitWith {
        private _ret = (FAST_HASH_POOL deleteAt 0);
        FAST_HASH_CREATED_HASHES_NEW pushBack _ret;
        _ret;
    };
    private _ret = createLocation ["AcreHashType", [-10000,-10000,-10000], 0, 0];
    _ret setText "acre_hash";
    FAST_HASH_CREATED_HASHES_NEW pushBack _ret;
    _ret;
};

EFUNC(lib,fastHashCopyArray) = {
    private _newArray = [];
    {
        if(IS_HASH(_x)) then {
            _newArray pushBack (_x call EFUNC(lib,fastHashCopy));
        } else {
            if(IS_ARRAY(_x)) then {
                _newArray pushBack (_x call EFUNC(lib,fastHashCopyArray));
            } else {
                _newArray pushBack _x;
            };
        };
    } forEach _this;
    _newArray;
};

EFUNC(lib,fastHashCopy) = {
    private _return = [];
    if(IS_ARRAY(_this)) then {
        _return = _this call EFUNC(lib,fastHashCopyArray);
    } else {
        _return = (call EFUNC(lib,fastHashCreate));
        {
            private _el = (_this getVariable _x);
            private _eln = _x;
            if(IS_ARRAY(_el)) then {
                _return setVariable [_eln, (_el call EFUNC(lib,fastHashCopyArray))];
            } else {
                if(IS_HASH(_el)) then {
                    _return setVariable [_eln, (_el call EFUNC(lib,fastHashCopy))];
                } else {
                    _return setVariable [_eln, _el];
                };
            };
        } forEach (allVariables _this);
    };
    _return;
};

EFUNC(lib,fastHashKeys) = {
    private _keys = [];
    {
        if(!(isNil {_this getVariable _x})) then {
            _keys pushBack _x;
        };
    } forEach (allVariables _this);
    _keys;
};
/*
EFUNC(lib,fastHashSerialize) = {
    params ["_hash"];
    private _array = ["ACRE_FAST_HASH",[],[]];
    _keys = _array select 1;
    _vals = _array select 2;
    _allVars = (allVariables _hash) - FAST_HASH_DEFAULT_KEYS;
    {
        _keys pushBack _x;
        _vals pushBack (_hash getVariable [_x, nil]);
    } forEach _allVars;
    _array;
};

EFUNC(lib,fastHashDeSerialize) = {
    params ["_array"];
    private _hash = HASH_CREATE;
    _keys = _array select 1;
    _vals = _array select 2;
    {
        HASH_SET(_hash, _x, (_vals select _forEachIndex));
    } forEach _keys;
    _hash;
};
*/
if(isNil "FAST_HASH_POOL") then {
    FAST_HASH_POOL = [];
    for "_i" from 1 to 50000 do {
        _newHash = createLocation ["AcreHashType", [-10000,-10000,-10000], 0, 0];
        _newHash setText "acre_hash";
        FAST_HASH_POOL pushBack _newHash;
    };
};
FAST_HASH_TO_DELETE = [];

private _fnc_hashMonitor = {
    if((count FAST_HASH_TO_DELETE) > 0) then {
        _init_time = diag_tickTime;
        while {((diag_tickTime - _init_time)*1000) < 2.0 && count FAST_HASH_TO_DELETE > 0} do {
            _hash = FAST_HASH_TO_DELETE deleteAt 0;
            deleteLocation _hash;
            _newHash = createLocation ["AcreHashType", [-10000,-10000,-10000], 0, 0];
            _newHash setText "acre_hash";
            FAST_HASH_POOL pushBack _newHash;
        };
    };
    if((count FAST_HASH_POOL) <= ((count FAST_HASH_CREATED_HASHES)*0.1)) then {
        for "_i" from 1 to 10 do {
            _newHash = createLocation ["AcreHashType", [-10000,-10000,-10000], 0, 0];
            _newHash setText "acre_hash";
            FAST_HASH_POOL pushBack _newHash;
        };
    };
};
[_fnc_hashMonitor, 0.33, []] call cba_fnc_addPerFrameHandler;
FAST_HASH_CREATED_HASHES = [];
FAST_HASH_VAR_STATE = (allVariables missionNamespace);
FAST_HASH_VAR_LENGTH = count FAST_HASH_VAR_STATE;
FAST_HASH_GC_INDEX = 0;
FAST_HASH_GC_FOUND_OBJECTS = [];
FAST_HASH_GC_FOUND_ARRAYS = [];
FAST_HASH_GC_CHECK_OBJECTS = [];
FAST_HASH_CREATED_HASHES_NEW = [];
FAST_HASH_GC_IGNORE = ["fast_hash_gc_found_objects","fast_hash_gc_found_arrays","fast_hash_created_hashes","fast_hash_gc_check_objects","fast_hash_created_hashes_new","fast_hash_var_state","fast_hash_pool","fast_hash_to_delete"];
FAST_HASH_GC_ORPHAN_CHECK_INDEX = 0;
private _garbageCollector = {

    if(count FAST_HASH_CREATED_HASHES_NEW < ((count FAST_HASH_CREATED_HASHES)*0.1)/2) exitWith {};
    // diag_log text format["---------------------------------------------------"];
    private _init_time = diag_tickTime;
    while {diag_tickTime - _init_time < 0.001 && {FAST_HASH_GC_INDEX < FAST_HASH_VAR_LENGTH}} do {
        private _var_name = FAST_HASH_VAR_STATE select FAST_HASH_GC_INDEX;
        private _x = missionNamespace getVariable [_var_name, nil];

        FAST_HASH_GC_INDEX = FAST_HASH_GC_INDEX + 1;
        if(!(_var_name in FAST_HASH_GC_IGNORE)) then {
            if(IS_HASH(_x)) then {

                FAST_HASH_GC_FOUND_OBJECTS pushBack _x;
            } else {
                if(IS_ARRAY(_x)) then {
                    // diag_log text format["pushBack: %1: %2", _var_name, _x];
                    FAST_HASH_GC_FOUND_ARRAYS pushBack _x;
                };
            };
        };
    };
    // diag_log text format["GC Objects Left: %1", FAST_HASH_VAR_LENGTH - FAST_HASH_GC_INDEX];

    _init_time = diag_tickTime;
    while {diag_tickTime - _init_time < 0.001 && {(count FAST_HASH_GC_FOUND_ARRAYS) > 0}} do {
        private _array = FAST_HASH_GC_FOUND_ARRAYS deleteAt 0;
        {
            if(IS_HASH(_x)) then {
                // diag_log text format["pushBack: %1", _name];
                FAST_HASH_GC_FOUND_OBJECTS pushBack _x;
             } else {
                if(IS_ARRAY(_x)) then {
                    // diag_log text format["pushBack sub-array: %1", _x];
                    FAST_HASH_GC_FOUND_ARRAYS pushBack _x;
                };
             };
        } forEach _array;
    };
    // diag_log text format["GC Arrays Left: %1", (count FAST_HASH_GC_FOUND_ARRAYS)];

    _init_time = diag_tickTime;
    while {diag_tickTime - _init_time < 0.001 && {(count FAST_HASH_GC_FOUND_OBJECTS) > 0}} do {
        _hash = FAST_HASH_GC_FOUND_OBJECTS deleteAt 0;
        FAST_HASH_GC_CHECK_OBJECTS pushBack _hash;
        private _array = allVariables _hash;
        {
            _x = _hash getVariable _x;
            if(IS_HASH(_x)) then {
                FAST_HASH_GC_FOUND_OBJECTS pushBack _x;
             } else {
                if(IS_ARRAY(_x)) then {
                    // diag_log text format["pushBack hash-array: %1", _x];
                    FAST_HASH_GC_FOUND_ARRAYS pushBack _x;
                };
             };
        } forEach _array;
    };
    // diag_log text format["GC Hashes Left: %1", (count FAST_HASH_GC_FOUND_OBJECTS)];

    if(FAST_HASH_GC_INDEX >= FAST_HASH_VAR_LENGTH && {(count FAST_HASH_GC_FOUND_ARRAYS) <= 0} && {(count FAST_HASH_GC_FOUND_OBJECTS) <= 0}) then {
        if(FAST_HASH_GC_ORPHAN_CHECK_INDEX < (count FAST_HASH_CREATED_HASHES)) then {
            _init_time = diag_tickTime;
            while {diag_tickTime - _init_time < 0.001 && {FAST_HASH_GC_ORPHAN_CHECK_INDEX < (count FAST_HASH_CREATED_HASHES)}} do {
                _check = FAST_HASH_CREATED_HASHES select FAST_HASH_GC_ORPHAN_CHECK_INDEX;
                FAST_HASH_GC_ORPHAN_CHECK_INDEX = FAST_HASH_GC_ORPHAN_CHECK_INDEX + 1;
                if(!(_check in FAST_HASH_GC_CHECK_OBJECTS)) then {
                    FAST_HASH_TO_DELETE pushBack _check;
                };
            };
        } else {
            FAST_HASH_VAR_STATE = (allVariables missionNamespace);
            FAST_HASH_CREATED_HASHES = FAST_HASH_GC_CHECK_OBJECTS;
            FAST_HASH_GC_CHECK_OBJECTS = [];
            FAST_HASH_GC_FOUND_ARRAYS = [];
            FAST_HASH_VAR_LENGTH = count FAST_HASH_VAR_STATE;
            FAST_HASH_GC_INDEX = 0;
            FAST_HASH_CREATED_HASHES append FAST_HASH_CREATED_HASHES_NEW;
            FAST_HASH_CREATED_HASHES_NEW = [];
            FAST_HASH_GC_FOUND_OBJECTS = [];
            FAST_HASH_GC_ORPHAN_CHECK_INDEX = 0;
        };
    };

};
[_garbageCollector, 0.25, []] call CBA_fnc_addPerFrameHandler;


ADDON = true;
