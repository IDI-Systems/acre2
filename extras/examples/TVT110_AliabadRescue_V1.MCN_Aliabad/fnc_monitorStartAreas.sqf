#include "script_component.hpp"


{
	private["_unit", "_marker", "_markers"];
	_unit = _x;
	if({!isNil "_unit"} && {!isNull _unit }) then {
	if(alive _unit) then {
		switch (side _unit) do {
			case east: { 
				_nearest = [0,0,0];
				{
					_marker = markerPos _x;
					if(_unit distance _marker < (_unit distance _nearest)) then {
						_nearest = _marker;
					};
				} forEach GVAR(opforStartAreas);
				
				if((vehicle _unit) != _unit) then { _unit = vehicle _unit; };
				
				_marker = markerPos "opforStartArea";
				if ((_unit distance _marker) < (_unit distance _nearest)) then {
					if ((_unit distance _marker) > 55) then {
						_dir = [_marker, _unit] call BIS_fnc_dirTo;
						_pos = [_marker, 50, _dir] call BIS_fnc_relPos;
						_unit setPosATL _pos;
					};
				} else {
					if ((_unit distance _nearest) > 20) then {
						_dir = [_nearest, _unit] call BIS_fnc_dirTo;
						_pos = [_nearest, 15, _dir] call BIS_fnc_relPos;
						_unit setPosATL _pos;
					}
				};
			};
			case west: {
				_marker = markerPos "bluforStartArea";
				if((vehicle _unit) != _unit) then { _unit = vehicle _unit; };
				
				if ((_unit distance _marker) > 100) then {
					_dir = [_marker, _unit] call BIS_fnc_dirTo;
					_pos = [_marker, 20, _dir] call BIS_fnc_relPos;
					_unit setPosATL _pos;
				}
			};
		};
	};
} forEach allUnits;