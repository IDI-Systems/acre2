#include "script_component.hpp"

NO_DEDICATED;

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREPClient.hpp"
PREP_RECOMPILE_END;

DGVAR(objectIdRelationTable) = HASH_CREATE;
DGVAR(pendingIdRelationUpdates) = [];

DFUNC(addComponentCargo) = {
    params ["_container", "_type", ["_preset", "default"], ["_callBack", ""], ["_failCallBack", ""]];
    [QGVAR(doAddComponentCargo), [_container, _type, _preset, acre_player, _callBack, _failCallBack]] call CALLSTACK(CBA_fnc_globalEvent);
};

ADDON = true;
