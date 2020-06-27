#include "script_component.hpp"

if (!hasInterface) exitWith {};

[DFUNC(_processQueue), 0, []] call CBA_fnc_addPerFrameHandler;

"ACREc" addPublicVariableEventHandler { (_this select 1) call FUNC(onDataChangeEvent); };
"ACREjipc" addPublicVariableEventHandler { (_this select 1) call FUNC(clientHandleJipData); };


[] call FUNC(syncData);
