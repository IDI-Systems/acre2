#include "script_component.hpp"

NO_DEDICATED;

ADDPFH(DFUNC(_processQueue), 0, []);

"ACREc" addPublicVariableEventHandler { (_this select 1) call FUNC(onDataChangeEvent); };
"ACREjipc" addPublicVariableEventHandler { (_this select 1) call FUNC(clientHandleJipData); };


[] call FUNC(syncData);
