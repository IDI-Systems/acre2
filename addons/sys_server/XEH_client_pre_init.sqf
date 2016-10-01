#include "script_component.hpp"

NO_DEDICATED;

PREP(clientGCRadio);
PREP(cloneRadioData);
PREP(updateIdObjects);


DGVAR(objectIdRelationTable) = HASH_CREATE;
DGVAR(pendingIdRelationUpdates) = [];

DFUNC(addComponentCargo) = {
    params["_container","_type",["_preset","default"],["_callBack",""],["_failCallBack",""]];

    [QGVAR(doAddComponentCargo), [_container, _type, _preset, acre_player, _callBack, _failCallBack]] call CALLSTACK(CBA_fnc_globalEvent);

};
