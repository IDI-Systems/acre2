//fnc_stateEvent.sqf
#include "script_component.hpp"

private _params = ["CfgAcreStateInterface"];
_params append _this;
/*_params set[1, _this select 0];
_params set[2, _this select 1];
if((count _this) == 3) then {
    _params set[3, _this select 2];
};*/
// diag_log text format["ACRE STATE EVENT: %1", _params];
private _result = _params call FUNC(acreEvent);
// acre_player sideChat format["d: %1", _result];
_result
