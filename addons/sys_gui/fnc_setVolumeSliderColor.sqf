#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */

disableSerialization;

private _color = [.1,1,.1,.33];
switch (GVAR(VolumeControl_Level)) do
{
    case -2:     {_color = [1,1,1,.33];};
    case -1:     {_color = [.5,1,.5,.33];};
    case 0:     {_color = [.1,1,.1,.33];};
    case 1:     {_color = [1,.5,.5,.33];};
    case 2:     {_color = [1,.1,.1,.33];};
};

private _slider = (GVAR(VolumeControlDialog) select 0) displayCtrl 1900;
_slider ctrlSetActiveColor _color;
_slider ctrlCommit 0;
