#include "script_component.hpp"

ADDON = false;

PREP(getRadioState);
// new data functions
PREP(getRadioPresetName);
PREP(acreEvent);
PREP(transEvent);
PREP(physicalEvent);
PREP(processSysEvent);
PREP(processRadioEvent);
PREP(dataEvent);
PREP(interactEvent);
PREP(guiDataEvent);
PREP(guiInteractEvent);
PREP(handleSetData);
PREP(_processQueue);
PREP(onDataChangeEvent);
PREP(handleGetData);
PREP(openGui);
PREP(closeGui);
PREP(handleSetRadioState);
PREP(handleSetRadioStateEvent);
PREP(handleGetRadioState);
PREP(clearRadioData);
PREP(isRadioInitialized);
PREP(assignRadioPreset);
PREP(getPresetData);
PREP(registerRadioPreset);
PREP(getScratchData);
PREP(setScratchData);
PREP(createEventMsgId);
PREP(serverHandleJip);
PREP(clientHandleJipData);
PREP(syncData);
PREP(sendDataEvent);
PREP(serverPropDataEvent);
PREP(getRemoteRadioList);
PREP(getPlayerRadioList);
PREP(sortRadioList);
PREP(stateEvent);
PREP(handleSetChannel);
PREP(addHighPriorityId);
PREP(removeHighPriorityId);
PREP(noApiFunction);
PREP(noApiSystemFunction);


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

#define IS_SERIALIZEDHASH(array) (IS_ARRAY(array) && {(count array) > 0} && {IS_STRING((array select 0))} && {(array select 0) == "ACRE_HASH"})

DFUNC(_hashSerialize) = {
    private _hash = _this;
    private _keys = [];
    private _vals = [];
    private _vars = allVariables _hash;
    {
        _val = HASH_GET(_hash, _x);
        if(!isNil "_val") then {
            _keys pushBack _x;
            if(IS_ARRAY(_val)) then {
                _val = _val call FUNC(_arraySerialize);
            };
            if(IS_HASH(_val)) then {
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
        if(IS_HASH(_x)) then {
            _ret pushBack (_x call FUNC(_hashSerialize));
        } else {
            if(IS_ARRAY(_x)) then {
                _ret pushBack (_x call FUNC(_arraySerialize));
            } else {
                _ret pushBack _x;
            };
        };
    } forEach _this;
    _ret;
};

DFUNC(serialize) = {
    private ["_ret"];
    if(IS_HASH(_this)) then {
        _ret = _this call FUNC(_hashSerialize);
    } else {
        if(IS_ARRAY(_this)) then {
            _ret = _this call FUNC(_arraySerialize);
        } else {
            _ret = _this;
        };
    };
    _ret;
};

DFUNC(_hashDeserialize) = {
    params ["","_keys","_vals"];

    private _hash = HASH_CREATE;
    {
        private _val = _vals select _forEachIndex;
        if(IS_SERIALIZEDHASH(_val)) then {
            _val = _val call FUNC(_hashDeserialize);
        } else {
            if(IS_ARRAY(_val)) then {
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
        if(IS_SERIALIZEDHASH(_x)) then {
            _ret pushBack (_x call FUNC(_hashDeserialize));
        } else {
            if(IS_ARRAY(_x)) then {
                _ret pushBack (_x call FUNC(_arrayDeserialize));
            } else {
                _ret pushBack _x;
            };
        };
    } forEach _this;
    _ret;
};

DFUNC(deserialize) = {
    private ["_ret"];
    if(IS_SERIALIZEDHASH(_this)) then {
        _ret = _this call FUNC(_hashDeserialize);
    } else {
        if(IS_ARRAY(_this)) then {
            _ret = _this call FUNC(_arrayDeserialize);
        } else {
            _ret = _this;
        };
    };
    _ret;
};

ADDON = true;
