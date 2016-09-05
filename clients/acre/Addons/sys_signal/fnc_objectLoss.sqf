//fnc_objectLoss.sqf
#include "script_component.hpp"

private ["_pEaddRx", "_intersects", "_n", "_bb", "_x", "_avg", "_height", "_dis"];

params["_pos1", "_pos2", "_f"];

_pEaddRx = 0;

_intersects = lineIntersectsWith [_pos1, _pos2, objNull, objNull, true];
if(count _intersects > 0) then {
    _n = 0;
    {
        _typeString = typeOf _x;
        if(_typeString != "") then {
            _bb = boundingBox _x;
            _avg = (abs((_bb select 0) select 0))+((_bb select 1) select 0)+(abs((_bb select 0) select 1))+((_bb select 1) select 1);
            
            
            _height = ((_bb select 1) select 2);
            _avg = (_avg*_height);
            if(_avg > 8) then {
                _avg = _avg*0.001;
                _n = _n + 1;
                _pEaddRx = _pEaddRx + _avg;
            };
        };
    } forEach _intersects;
    if(_n > 0) then {
        _dis = (_intersects select 0) distance (_intersects select ((count _intersects)-1));
        _dis = _dis max 0.1;
        // acre_player sideChat format["PE: %1dB", _pEaddRx];
        // diag_log text format["20*log(%1)+%2*log(%3)+%4-28", _f, _n, _dis, _pEaddRx];
        _pEaddRx = 20*log(_f)+_n*log(_dis)+_pEaddRx-28;
    };
};
_pEaddRx;
