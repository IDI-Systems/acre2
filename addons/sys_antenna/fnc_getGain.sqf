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

private ["_frequencyLower", "_frequencyUpper",
            "_azimuthLbF", "_azimuthUbF", "_zenithLbF", "_zenithUpF", "_antennas", "_antennaClass",
            "_lowerGains", "_upperGains", "_upperFLg", "_upperFUg", "_lowerFLg", "_loweFUg"];
params["_class", "_azimuth", "_zenith", "_f",["_polarization",-1]];

_zenith = abs _zenith;

TRACE_1("fnc_getGain params",_this);


TRACE_1("GETTING ANTENNA CLASS", _class);

_frequencyLower = _f - (_f mod 10);
_frequencyUpper = _frequencyLower + 10;

_antennaClass = (configFile >> "CfgAcreComponents" >> _class);
_lowerGainsCache = format ["%1_gain_%2mhz", _antennaClass, _frequencyLower];
if(HASH_HASKEY(GVAR(antennaCache), _lowerGainsCache)) then {
    _lowerGains = HASH_GET(GVAR(antennaCache), _lowerGainsCache);
} else {
    _lowerGains = getArray(_antennaClass >> "Gain" >> (format["gain_%1mhz", _frequencyLower]));
    HASH_SET(GVAR(antennaCache), _lowerGainsCache, _lowerGains);
};

_higherGainsCache = format ["%1_gain_%2mhz", _antennaClass, _frequencyUpper];
if(HASH_HASKEY(GVAR(antennaCache), _higherGainsCache)) then {
    _upperGains = HASH_GET(GVAR(antennaCache), _higherGainsCache);
} else {
    _upperGains = getArray(_antennaClass >> "Gain" >> (format["gain_%1mhz", _frequencyLower]));
    HASH_SET(GVAR(antennaCache), _higherGainsCache, _upperGains);
};

_sizeAz = (count _lowerGains);
_sizeZen = (count (_lowerGains select 0))-1;

_spacingAz = 360/_sizeAz;
_spacingZen = 90/_sizeZen;

_azimuthLb = _azimuth-(_azimuth mod _spacingAz);
_azimuthLbi = _azimuthLb/_spacingAz;
_azimuthUbi = (_azimuthLbi+1) mod _sizeAz;
_azimuthUb = (_azimuthLb + _spacingAz) mod 360;

TRACE_2("", _azimuthLbi, _azimuthLb);

_zenithLb = _zenith-(_zenith mod _spacingZen);
TRACE_1("", _zenith);
_zenithLbi = _zenithLb/_spacingZen;

_zenithUbi = (_zenithLbi+1) min _sizeZen;
_zenithLbi = (_sizeZen)-_zenithLbi;
_zenithUbi = (_sizeZen)-_zenithUbi;
_zenithUb = (_zenithLb + _spacingZen) min 90;
TRACE_1("", _zenithLbi);
if(_polarization == -1) then {
    _polarization = getNumber(_antennaClass >> "polarization");
};


TRACE_2("", count _lowerGains, _lowerGains);
TRACE_2("", count _upperGains, _upperGains);

if((count _lowerGains) == 0) exitWith {
    [-35, _polarization]
};
if((count _upperGains) == 0) exitWith {
    [-35, _polarization]
};
_LF_LA_LZ = ((_lowerGains select _azimuthLbi) select _zenithLbi) select _polarization;
_LF_LA_UZ = ((_lowerGains select _azimuthLbi) select _zenithUbi) select _polarization;
TRACE_1("", ((_lowerGains select _azimuthLbi) select _zenithLbi));
TRACE_1("", _LF_LA_UZ);

if(_LF_LA_LZ == -999) then { _LF_LA_LZ = -35; };
if(_LF_LA_UZ == -999) then { _LF_LA_UZ = -35; };
_LF_LA_Z = [_zenith, _zenithLb, _zenithUb, _LF_LA_LZ, _LF_LA_UZ] call FUNC(interp);
TRACE_1("", _LF_LA_Z);
_LF_UA_LZ = ((_lowerGains select _azimuthUbi) select _zenithLbi) select _polarization;
_LF_UA_UZ = ((_lowerGains select _azimuthUbi) select _zenithUbi) select _polarization;
if(_LF_UA_LZ == -999) then { _LF_UA_LZ = -35; };
if(_LF_UA_UZ == -999) then { _LF_UA_UZ = -35; };

_LF_UA_Z = [_zenith, _zenithLb, _zenithUb, _LF_UA_LZ, _LF_UA_UZ] call FUNC(interp);
TRACE_1("", _LF_UA_Z);
_UF_LA_LZ = ((_upperGains select _azimuthLbi) select _zenithLbi) select _polarization;
_UF_LA_UZ = ((_upperGains select _azimuthLbi) select _zenithUbi) select _polarization;
if(_UF_LA_LZ == -999) then { _UF_LA_LZ = -35; };
if(_UF_LA_UZ == -999) then { _UF_LA_UZ = -35; };

_UF_LA_Z = [_zenith, _zenithLb, _zenithUb, _UF_LA_LZ, _UF_LA_UZ] call FUNC(interp);
TRACE_1("", _UF_LA_Z);
_UF_UA_LZ = ((_upperGains select _azimuthUbi) select _zenithLbi) select _polarization;
_UF_UA_UZ = ((_upperGains select _azimuthUbi) select _zenithUbi) select _polarization;
if(_UF_UA_LZ == -999) then { _UF_UA_LZ = -35; };
if(_UF_UA_UZ == -999) then { _UF_UA_UZ = -35; };

_UF_UA_Z = [_zenith, _zenithLb, _zenithUb, _UF_UA_LZ, _UF_UA_UZ] call FUNC(interp);
TRACE_1("", _UF_UA_Z);
_UF_G = [_azimuth, _azimuthLb, _azimuthUb, _LF_LA_Z, _LF_UA_Z] call FUNC(interp);

_LF_G = [_azimuth, _azimuthLb, _azimuthUb, _UF_LA_Z, _UF_UA_Z] call FUNC(interp);

_G = [_f, _frequencyLower, _frequencyUpper, _UF_G, _LF_G] call FUNC(interp);

[_G, _polarization]
