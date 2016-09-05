//fnc_getElevationXtoY.sqf
#include "script_component.hpp"

private ["_vec", "_mag", "_elev", "_dir"];

params["_p1","_p2"];


_vec = vectorNormalized (_p2 vectorDiff _p1);

//_mag = sqrt (((_vec select 0)^2) + ((_vec select 1)^2) + ((_vec select 2)^2));
// _mag = 1
_elev = asin ((_vec select 2) /*/ _mag*/);
_dir = (360 + ((_vec select 0) atan2 (_vec select 1))) mod 360;

[_elev, _dir]
