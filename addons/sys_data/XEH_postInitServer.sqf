#include "script_component.hpp"

LOG("ENTER");

ACRE_DATA_SYNCED = true;
"ACREs" addPublicVariableEventHandler {
    (_this select 1) call FUNC(serverPropDataEvent);
    (_this select 1) call FUNC(onDataChangeEvent);
};

"ACREjips" addPublicVariableEventHandler {
    (_this select 1) call FUNC(serverHandleJip);
};
