//fnc_countLog.sqf
#include "script_component.hpp"

private ["_count", "_value", "_name", "_values"];
_name = _this select 0;
_count = _this select 1;
_value = _this select 2;
if(!HASH_HASKEY(GVAR(countLogs), _name)) then {
    HASH_SET(GVAR(countLogs), _name, []);
};
_values = HASH_GET(GVAR(countLogs), _name);
if((count _values) >= _count) then {
    _values resize (_count - 1);
};
_values = [_value] + _values;
HASH_SET(GVAR(countLogs), _name, _values);
