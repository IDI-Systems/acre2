#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

DGVAR(radioPresets) = HASH_CREATE;
DGVAR(radioData) = HASH_CREATE;
DGVAR(radioPresets) = HASH_CREATE;
DGVAR(assignedRadioPresets) = HASH_CREATE;
DGVAR(currentRadioStates) = HASH_CREATE;
DGVAR(eventQueue) = [];
DGVAR(pendingNetworkEvents) = [];
DGVAR(pendingSyncEvents) = [];
DGVAR(radioScratchData) = HASH_CREATE;
DGVAR(forceHighPriorityIds) = [];

DVAR(ACRE_DATA_SYNCED) = false;

DVAR(ACRE_DEBUG_LASTFRAME) = 0;
DVAR(ACRE_DEBUG_ECOUNT) = 0;
DVAR(ACRE_DEBUG_CTIME) = 0;
DVAR(ACRE_DEBUG_CALLLIST) = [];

DGVAR(serverNetworkIdCounter) = 0;

ACREc = "";
ACREs = "";
ACREjipc = "";
ACREjips = "";

DGVAR(validStates) = HASH_CREATE;

DFUNC(_hashSerialize) = {
    private _hash = _this;
    private _keys = [];
    private _vals = [];
    private _vars = allVariables _hash;
    {
        _val = HASH_GET(_hash, _x);
        if (!isNil "_val") then {
            _keys pushBack _x;
            if (IS_ARRAY(_val)) then {
                _val = _val call FUNC(_arraySerialize);
            };
            if (IS_HASH(_val)) then {
                _val = _val call FUNC(_hashSerialize);
            };
            _vals pushBack _val;
        };
    } forEach _vars;
    ["ACRE_HASH", _keys, _vals];
};

DFUNC(_arraySerialize) = {
    private _ret = [];
    {
        if (IS_HASH(_x)) then {
            _ret pushBack (_x call FUNC(_hashSerialize));
        } else {
            if (IS_ARRAY(_x)) then {
                _ret pushBack (_x call FUNC(_arraySerialize));
            } else {
                _ret pushBack _x;
            };
        };
    } forEach _this;
    _ret;
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
    private _ret = [];
    {
        if (IS_SERIALIZEDHASH(_x)) then {
            _ret pushBack (_x call FUNC(_hashDeserialize));
        } else {
            if (IS_ARRAY(_x)) then {
                _ret pushBack (_x call FUNC(_arrayDeserialize));
            } else {
                _ret pushBack _x;
            };
        };
    } forEach _this;
    _ret;
};

ADDON = true;
