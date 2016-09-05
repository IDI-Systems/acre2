//fnc_updateIdObjects.sqf
#include "script_component.hpp"

private _update = _this;
if(ACRE_DATA_SYNCED) then {
    {
        HASH_SET(GVAR(objectIdRelationTable), _x select 0, _x select 1);
    } forEach _update;
} else {
    PUSH(GVAR(pendingIdRelationUpdates), _update);
};
