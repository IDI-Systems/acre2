#include "script_component.hpp"

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