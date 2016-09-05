//fnc_interactEvent.sqf
#include "script_component.hpp"

private _params = ["CfgAcreInteractInterface"];
_params append _this;
_params call FUNC(acreEvent);