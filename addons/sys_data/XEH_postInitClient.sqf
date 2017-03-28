#include "script_component.hpp"

if (!hasInterface) exitWith {};

ADDPFH(DFUNC(_processQueue), 0, []);

"ACREc" addPublicVariableEventHandler { (_this select 1) call FUNC(onDataChangeEvent); };
"ACREjipc" addPublicVariableEventHandler { (_this select 1) call FUNC(clientHandleJipData); };


[] call FUNC(syncData);
