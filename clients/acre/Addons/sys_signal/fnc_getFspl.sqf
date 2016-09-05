//fnc_getFspl.sqf
#include "script_component.hpp"

private ["_Lfs", "_Ptx", "_Rp"];
params["_distance", "_f", "_mW", "_ratio"];

_Lfs = -27.55 + 20*log(_f) + 20*log(_distance);
_Ptx = 10 * (log ((_mW*_ratio)/1000)) + 30;
_Rp = _Ptx - _Lfs;
_Rp;
