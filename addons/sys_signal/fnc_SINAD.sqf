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
#include "script_component.hpp"

private ["_d","_f","_d1","_d2","_hL","_hO","_Oc","_mW","_Gtxl","_Grxl","_N","_Itu","_Sl","_Slp",
            "_A","_C0","_Ptx","_Gtx","_Grx","_Ltx","_Lm","_Lrx","_lambda","_aA","_FSPL","_Lfs",
            "_Ox", "_Lb","_Ss","_bottom","_Snd","_Px"];
_d      = _this select 0; // total distance
_f      = _this select 1; // frequency in Mhz
_d1     = _this select 2; // distance from reciever to terrain feature
_d2     = _this select 3; // distance from transmitter to terrain feature
_hL     = _this select 4; // height of LOS at terrain feature
_hO     = _this select 5; // height of terrain feature
_Oc     = _this select 6;
_mW     = _this select 7; // broadcasting power in milliwats
_Gtx   = _this select 8; // area of transmitting antenna
_Grx   = _this select 9; // area of recieving antenna
_N      = -110;//_this select 10; // sensitivity
_Itu    = _this select 11;

_Sl     = (abs _N)/2;
_Slp    = 0.25;

/**
 * Calculate the ITU Terrain Loss Model
 * This is a calculation using the average terrain height, the frequency,
 * and the size of the first Fresnel zone. It works for any distance and
 * frequency and is considered accurate above 15dB.
 */
DFUNC(ITULoss) = {
    private ["_d1", "_d2", "_f", "_hL", "_hO", "_A", "_F1", "_h", "_Cn"];
    _hL    = _this select 0;
    _hO = (_this select 1) max 0.01;
    _d1    = (_this select 2) max 0.01;
    _d2 = (_this select 3) max 0.01;
    _f    = _this select 4;
    _F1 = 17.3*(sqrt ((_d1*_d2)/((_f)*(_d1+_d2))));
    _h = _hL - _hO;
    _A = 0;
    if((abs _h) < 2.5) then {
        _A = 0;
    } else {
        _Cn = _h/_F1;
        _A = 10 - 20*_Cn;
    };
    _A
};
_A = 0;
_C0 = 300000000;
for "_i" from 1 to (count _Itu)-2 do {
    _x = _Itu select _i;
    if((_x select 3) > 10 && (_x select 2) > 10) then {
        PUSH(_x, _f);
        _add = 0;
        _add = ((_x call FUNC(ITULoss)) max 0);
        _add = _add min 75;
        if(_add <= 10) then {
            _add = 0;
        };
        _A = _A + (_add*GVAR(terrainScaling));
    };
};

_Ptx = 10 * (log (_mW/1000)) + 30;


_Ltx = 3;

_Lm = ((random 1) - 0.5); // Random noise

_Lrx = 3;

_lambda = _C0/(_f*1000*1000);
_aA = (4*4*pi*pi*_d*_d)/(_lambda*_lambda);
_FSPL = 10*(log _aA);
TRACE_1("FSPL", _FSPL);
_Lm = _Lm+(_A max 0) + _Oc;// + ((random .5) - 1);
_Lfs = _FSPL; // Total loss from FPSL and Loss Model

/**
 * This is the Link Budget, or the received power.
 */
_Lb = _Ptx + _Gtx - _Ltx - _Lfs - _Lm + _Grx - _Lrx;
_Ss = _Lb; // Unit in decibels.

_bottom = _N - (_Sl*_Slp);
_Snd = abs ((_bottom - (_Ss max _bottom))/_Sl);



//_logit = format["Ss: %1 Nd: %2 Sx: %3 Snd: %4 Mx: %5", _Ss, _Nd, _Sx, _Snd, _Mx];
//TRACE_1("SIGNAL",_logit);
_Px = 100 min (0 max (_Snd*100)); // Bracketed percentage value.
_Px = _Px/100;
[_Px, _Ss]
