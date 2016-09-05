#include "script_component.hpp"

private["_iconcontrol", "_display", "_button"];
_button = GET_STATE("pressedButton");
_iconcontrol = 1000;
_display = uiNamespace getVariable [QUOTE(GVAR(currentDisplay)), nil];
if(!isNil "_display") then {
	_knobImageStr = QUOTE(PATHTOF(Data\knobs\prc117f_ui_keys_default.paa));
	(_display displayCtrl _iconcontrol) ctrlSetText _knobImageStr;
	SET_STATE("pressedButton",-1);
};