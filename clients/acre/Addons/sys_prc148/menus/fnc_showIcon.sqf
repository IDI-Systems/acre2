//fnc_showIcon.sqf
#include "script_component.hpp"

private ["_ctrl"];
params["_display", "_icon", "_show"];

_ctrl = _display displayCtrl _icon;

_ctrl ctrlShow _show;
_ctrl ctrlCommit 0;
