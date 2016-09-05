#include "script_component.hpp"
params["_iconId", "_toggle"];

_display = uiNamespace getVariable QUOTE(GVAR(currentDisplay));
_type = ctrlType (_display displayCtrl _iconId);

if((count _this) > 2) then {
    _newPosition = _this select 2;
    (_display displayCtrl _iconId) ctrlSetPosition _toggle;
};

//if(_type == 8) then {
//    (_display displayCtrl _iconId) progressSetPosition 0.85;
//};

(_display displayCtrl _iconId) ctrlShow _toggle;
(_display displayCtrl _iconId) ctrlCommit 0;