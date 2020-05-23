#include "script_component.hpp"

#include "XEH_PREP.hpp"

if (!hasInterface) exitWith {};

#ifdef USE_DEBUG_EXTENSIONS
// Load extension before first use
"acre_dynload" callExtension format["load:%1", "idi\acre\acre_x64.dll"];
private _list = "acre_dynload" callExtension "list";
INFO_1("USE_DEBUG_EXTENSIONS enabled %1",_list);;
#endif

["init", []] call FUNC(callExt);
