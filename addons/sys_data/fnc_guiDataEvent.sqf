//fnc_guiDataEvent.sqf
#include "script_component.hpp"

private _params = ["CfgAcreDataInterface", acre_sys_radio_currentRadioDialog];
//_params pushBack acre_sys_radio_currentRadioDialog;
_params append _this;
_params call FUNC(acreEvent);

