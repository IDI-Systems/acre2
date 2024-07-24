#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

GVAR(radioPresets) = HASH_CREATE;
GVAR(radioData) = HASH_CREATE;
GVAR(radioPresets) = HASH_CREATE;
GVAR(assignedRadioPresets) = HASH_CREATE;
GVAR(currentRadioStates) = HASH_CREATE;
GVAR(eventQueue) = [];
GVAR(pendingNetworkEvents) = [];
GVAR(pendingSyncEvents) = [];
GVAR(radioScratchData) = HASH_CREATE;
GVAR(forceHighPriorityIds) = [];

GVAR(sysEventCache) = HASH_CREATE;
GVAR(radioEventCache) = HASH_CREATE;

DVAR(ACRE_DATA_SYNCED) = false;
DVAR(ACRE_DEBUG_DATA_SYNC) = 0;

DVAR(ACRE_DEBUG_LASTFRAME) = 0;
DVAR(ACRE_DEBUG_ECOUNT) = 0;
DVAR(ACRE_DEBUG_CTIME) = 0;
DVAR(ACRE_DEBUG_CALLLIST) = [];

GVAR(serverNetworkIdCounter) = 0;

ACREc = "";
ACREs = "";
ACREjipc = "";
ACREjips = "";

GVAR(validStates) = HASH_CREATE;

DFUNC(_hashSerialize) = {
    private _hash = _this;
    private _vals = [];
    private _keys = (allVariables _hash) select {
        private _val = HASH_GET(_hash,_x);
        if (!isNil "_val") then {
            if (IS_ARRAY(_val)) then {
                _val = _val call FUNC(_arraySerialize);
            };
            if (IS_HASH(_val)) then {
                _val = _val call FUNC(_hashSerialize);
            };
            _vals pushBack _val;
            true
        } else {
            false
        };
    };
    ["ACRE_HASH", _keys, _vals];
};

DFUNC(_arraySerialize) = {
    _this apply {
        if (IS_HASH(_x)) then {
            (_x call FUNC(_hashSerialize));
        } else {
            if (IS_ARRAY(_x)) then {
                (_x call FUNC(_arraySerialize));
            } else {
                _x;
            };
        };
    };
};

DFUNC(_hashDeserialize) = {
    params ["","_keys","_vals"];

    private _hash = HASH_CREATE;
    {
        private _val = _vals select _forEachIndex;
        if (IS_SERIALIZEDHASH(_val)) then {
            _val = _val call FUNC(_hashDeserialize);
        } else {
            if (IS_ARRAY(_val)) then {
                _val = _val call FUNC(_arrayDeserialize);
            };
        };
        _hash setVariable [_x, _val];
    } forEach _keys;
    _hash;
};

DFUNC(_arrayDeserialize) = {
    _this apply {
        if (IS_SERIALIZEDHASH(_x)) then {
            (_x call FUNC(_hashDeserialize));
        } else {
            if (IS_ARRAY(_x)) then {
                (_x call FUNC(_arrayDeserialize));
            } else {
                _x;
            };
        };
    };
};

ADDON = true;
