#include "script_component.hpp"
private["_radioLists","_returnValue"];

//Emulate behaviour of the handleMultiPttKeyPress algorithm

_radioLists = [+ ACRE_ASSIGNED_PTT_RADIOS, [] call EFUNC(sys_data,getPlayerRadioList)] call EFUNC(sys_data,sortRadioList);


_returnValue = (_radioLists select 1);

_returnValue