//fnc_guiInteractEvent.sqf
#include "script_component.hpp"

private _params = ["CfgAcreInteractInterface", acre_sys_radio_currentRadioDialog];
//_params pushBack acre_sys_radio_currentRadioDialog;
_params append _this;
_params call FUNC(acreEvent);