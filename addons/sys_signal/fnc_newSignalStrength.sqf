/*
 * Author: AUTHOR
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



private ["_isPersistant",
            "_resolution", "_baseCOnfig", "_realRadioTx", "_realRadioRx", "_sinadRating", "_gainData",
            "_transmitterPosATL",
            "_receiverPosATL", "_vector", "_polar", "_2dDis",
            "_lastTransmitterPos", "_lastReceiverPos", "_pE", "_pEadd", "_types", "_checkDistance",
            "_transmitterNearObjects", "_receiverNearObjects", "_dis", "_pos", "_bb", "_avg", "_height",
            "_los", "_backVector", "_ituLoss", "_steps", "_remainder", "_highest", "_isRising", "_lastAlt",
            "_l", "_C0", "_lambda", "_aA", "_Lfs", "_Ptx", "_Ltx", "_Lrx", "_Lm", "_Lb", "_Sl", "_Slp",
            "_bottom", "_Snd"];
/*
DEBUG TIME
*/
_startTime = diag_tickTime;


/*
Parameters
*/
params["_receiver","_transmitter","_f","_mW","_receiverClass","_transmitterClass"];

_resolution         = 25;


/*
Radio class information
*/
_baseConfig = inheritsFrom (configFile >> "CfgWeapons" >> _transmitterClass);
_realRadioTx = configName ( _baseConfig );


_baseConfig = inheritsFrom (configFile >> "CfgWeapons" >> _receiverClass);
_realRadioRx = configName ( _baseConfig );

_sinadRating = getNumber (configFile >> "CfgAcreComponents" >> _realRadioRx >> "sinadRating");

/*
Antenna Gain Information
*/
_gainData = [_receiver, _receiverClass, _transmitter, _transmitterClass, _f] call EFUNC(sys_antenna,getAntennaInfo);

if((count _gainData) == 0) exitWith { [0, -999]; }; // no antenna someplace!

_gainData params ["_receiverGain","_transmitterGain","","","_receiverPos","_transmitterPos"];

/*
Vectors from transmitter to receiver
*/
_transmitterPosATL = ASLtoATL _transmitterPos;
_receiverPosATL = ASLtoATL _receiverPos;
if((_transmitterPos distance _receiverPos) == 0) then {
    _receiverPos set[2, (_receiverPos select 2)+0.1];
};

_vector = [_transmitterPos, _receiverPos] call FUNC(vectorXtoY);
_polar = _vector call FUNC(v2p);
_2dDis = [_transmitterPos, _receiverPos] call CALLSTACK(LIB_fnc_distance2D);
_3dDis = (_transmitterPos distance _receiverPos);

(_vector vectorMultiply _resolution) params ["_x","_y","_z"];

_transmitterPos params ["_nx","_ny","_nz"];

/*
Object oclusion calculations
*/
_lastTransmitterPos = _transmitter getVariable [QUOTE(GVAR(lastTransmitterPos)), [-10000,-10000,-10000]];
_lastReceiverPos = _receiver getVariable [QUOTE(GVAR(lastReceiverPos)), [-10000,-10000,-10000]];

_pE = 4; // Base Path Loss Exponent
_pEaddTx = 0;
_pEaddRx = 0;
if((_lastTransmitterPos distance _transmitterPosATL) > 1 || (_lastReceiverPos distance _receiverPos) > 1) then {
    #ifdef DEBUG_MODE_FULL
        // if(isNil "MARKERCOUNT") then {
            // MARKERCOUNT = 0;
        // };
        // for "_x" from 0 to MARKERCOUNT do {
            // deleteMarkerLocal format["m%1", _x];
        // };
        // MARKERCOUNT = 0;
    #endif
    _types = ["Building", "House"];
    _checkDistance = ((_transmitterPosATL distance _receiverPosATL) min 75);

    _transmitterNearObjects = _transmitter getVariable [QUOTE(GVAR(transmitterNearObjects)), []];
    if((_lastTransmitterPos distance _transmitterPosATL) > 10 || (count _transmitterNearObjects) == 0) then {
        _transmitter setVariable [QUOTE(GVAR(lastTransmitterPos)), _transmitterPosATL];
        _transmitterNearObjects = nearestObjects [_transmitterPosATL, _types, _checkDistance];
        _transmitter setVariable [QUOTE(GVAR(transmitterNearObjects)), _transmitterNearObjects];
    };

    _receiverNearObjects = _receiver getVariable [QUOTE(GVAR(receiverNearObjects)), []];
    if((_lastReceiverPos distance _receiverPosATL) > 10 || (count _receiverNearObjects) == 0) then {
        _receiver setVariable [QUOTE(GVAR(lastReceiverPos)), _receiverPosATL];
        _receiverNearObjects = nearestObjects [_receiverPosATL, _types, _checkDistance];
        _receiver setVariable [QUOTE(GVAR(receiverNearObjects)), _receiverNearObjects];
    };

    {
        _dis = _transmitterPosATL distance _x;
        _pos = [_transmitterPosATL, _dis, (_polar select 1)] call CALLSTACK(LIB_fnc_relPos);
        _bb = boundingBox _x;
        _avg = (abs((_bb select 0) select 0))+((_bb select 1) select 0)+(abs((_bb select 0) select 1))+((_bb select 1) select 1);
        _avg = _avg/4;
        _height = ((_bb select 1) select 2);
        if(_height > 2) then {
            #ifdef DEBUG_MODE_FULL
                _marker = createMarkerLocal [format["m%1", MARKERCOUNT], (getPos _x)];
                _marker setMarkerTypeLocal "Dot";
                MARKERCOUNT = MARKERCOUNT + 1;
                _marker2 = createMarkerLocal [format["m%1", MARKERCOUNT], _pos];
                MARKERCOUNT = MARKERCOUNT + 1;
                _marker2 setMarkerTypeLocal "Dot";
                _marker2 setMarkerColorLocal "ColorPink";
                MARKERCOUNT = MARKERCOUNT + 1;
            #endif
            _posTest = (getPosASL _x);
            _altHeight = getTerrainHeightASL [(_posTest select 0), (_posTest select 1)];
            _height = _altHeight+_height;
            _los = (_dis*(_vector select 2))+(_transmitterPos select 2);
            if((_pos distance _x) <= _avg && _los <= _height) then {
                _pEaddTx = _pEaddTx + (_avg/8);
                #ifdef DEBUG_MODE_FULL
                    _marker setMarkerColorLocal "ColorGreen";
                #endif
            };
        };
    } forEach _transmitterNearObjects;

    _backVector = [_receiverPos, _transmitterPos] call FUNC(vectorXtoY);
    {
        if(!(_x in _transmitterNearObjects)) then {
            _dis = _receiverPosATL distance _x;
            _pos = [_receiverPosATL, _dis, ((_polar select 1) + 180) mod 360] call CALLSTACK(LIB_fnc_relPos);
            _bb = boundingBox _x;
            _avg = (abs((_bb select 0) select 0))+((_bb select 1) select 0)+(abs((_bb select 0) select 1))+((_bb select 1) select 1);
            _avg = _avg/4;
            _height = ((_bb select 1) select 2);
            if(_height > 2) then {
                #ifdef DEBUG_MODE_FULL
                    _marker = createMarkerLocal [format["m%1", MARKERCOUNT], (getPos _x)];
                    _marker setMarkerTypeLocal "Dot";
                    MARKERCOUNT = MARKERCOUNT + 1;
                    _marker2 = createMarkerLocal [format["m%1", MARKERCOUNT], _pos];
                    MARKERCOUNT = MARKERCOUNT + 1;
                    _marker2 setMarkerTypeLocal "Dot";
                    _marker2 setMarkerColorLocal "ColorYellow";
                    MARKERCOUNT = MARKERCOUNT + 1;
                #endif
                _posTest = (getPosASL _x);
                _altHeight = getTerrainHeightASL [(_posTest select 0), (_posTest select 1)];
                _height = _altHeight+_height;
                _los = (_dis*(_backVector select 2))+(_receiverPos select 2);
                if((_pos distance _x) <= _avg && _los <= _height) then {
                    _pEaddRx = _pEaddRx + (_avg/8);
                    #ifdef DEBUG_MODE_FULL
                        _marker setMarkerColorLocal "ColorGreen";
                    #endif
                };
            };
        };
    } forEach _receiverNearObjects;

    _transmitter setVariable [QUOTE(GVAR(pEaddTx)), _pEaddTx];
    _transmitter setVariable [QUOTE(GVAR(pEaddRx)), _pEaddRx];

} else {
    _pEaddTx = _transmitter getVariable [QUOTE(GVAR(pEaddTx)), 0];
    _pEaddRx = _transmitter getVariable [QUOTE(GVAR(pEaddRx)), 0];
};

_ituLoss = 0; // base loss level (based on empirical testing...)
_pE = _pE + (_pEaddTx + _peAddRx);

/*
Terrain Profile Generation
*/
_steps = floor(_2dDis/_resolution);
_remainder = _2dDis-(_steps*_resolution);
_highest = [];
_isRising = false;
_lastAlt = -10000;
_lastHighest = -10000;
for "_i" from 1 to _steps do {
    _alt = (getTerrainHeightASL [_nx, _ny]);
    if(_alt > _lastAlt) then {
        _isRising = true;
    } else {
        if(_isRising) then {
            _isRising = false;
            if(abs(_lastHighest - _lastAlt) >= 5) then {
                _lastHighest = _lastAlt;
                PUSH(_highest, ARR_4(_i*_resolution, _lastAlt, _nz-_z, ARR_3(_nx-_x, _ny-_y, 0)));
            };
        };
    };
    _nx = _nx + _x;
    _ny = _ny + _y;
    _nz = _nz + _z;
    _lastAlt = _alt;
};




/*
Terrain loss (ITU Model)
*/
{
    _l = [(_x select 2), (_x select 1), (_x select 0)/1000, (_2dDis - (_x select 0))/1000, _f/1000] call FUNC(ITULoss);
    #ifdef DEBUG_MODE_FULL
        _marker2 = createMarkerLocal [format["m%1", MARKERCOUNT], (_x select 3)];
        MARKERCOUNT = MARKERCOUNT + 1;
        _marker2 setMarkerTypeLocal "Dot";
        _marker2 setMarkerColorLocal "ColorGreen";
        _marker2 setMarkerTextLocal format["pos: %1 dif: %2 loss: %3dBm", [(_x select 3) select 0, (_x select 3) select 1, (_x select 1)], (_x select 2)-(_x select 1), _l];
    #endif
    if(_l > 12) then {
        _ituLoss = _ituLoss + (_l*GVAR(terrainScaling));
        #ifdef DEBUG_MODE_FULL
            _marker2 setMarkerColorLocal "ColorRed";
        #endif
    };
    if(_ituLoss > 120) exitWith {};
} forEach _highest;
if(_ituLoss < 32) then {
    _ituLoss = _ituLoss + (32-_ituLoss);
};
/*
Free Space Path Loss model
*/
// _C0 = 299792458;
// _lambda = _C0/(_f*1000*1000);
// _aA = ((_pE^2)*(pi^2)*(_3dDis^2))/(_lambda*_lambda);
// _Lfs = 10*(log _aA);

_Lfs = -27.55 + 20*log(_f) + 20*log(_3dDis);

/*
Transmitter Power (mW to dBm)
*/
_Ptx = 10 * (log (_mW/1000)) + 30;

/*
Transmitter/Receiver cable/internal loss.
*/
_Ltx = 3; // Transmitter
_Lrx = 3; // Receiver

/*
Loss from fading, obstruction, noise, etc (including ITU model)
*/
_Lm = _ituLoss + ((random 1) - 0.5);

/*
Total Link Budget
*/
_Lb = _Ptx + _transmitterGain - _Ltx - _Lfs - _Lm + _receiverGain - _Lrx;

/*
Signal percentage variables
*/
_Sl                 = (abs _sinadRating)/2;
_Slp                   = 0.075;

/*
Signal Percentage equation
*/
_bottom = _sinadRating - (_Sl*_Slp);
_Snd = abs ((_bottom - (_Lb max _bottom))/_Sl);
_Px = 100 min (0 max (_Snd*100)); // Bracketed percentage value.
_Px = _Px/100;

// _Px = 1-(((_Lb/_sinadRating) max 0) min 1);

/*
DEBUG
*/
_total = diag_tickTime - _startTime;
#ifdef DEBUG_MODE_FULL
    GVAR(showSignalHint) = true;

#endif
if(GVAR(showSignalHint)) then {
    COMPAT_hintSilent format["Strength: %1%9 @ %2Mhz\nRx: %3dBm @ %4mW\nAlt: %5m\nDis2D: %6m Dis3D: %7\nTxG: %10 RxG: %11\nAvg Time: %8",
                                format["%1%2 ADJ: %3", _Px*100, "%", ((_Px*100)-(_Slp*100)) max 0],
                                _f,
                                _Lb,
                                _mW,
                                ((_gainData select 5) select 2),
                                _2dDis,
                                (_transmitterPos distance _receiverPos),
                                (_total),
                                "%",
                                (_gainData select 1),
                                (_gainData select 0)
                              ];
    #ifdef DEBUG_MODE_FULL
        diag_log text format["----------------------------- ACRE SYS_SIGNAL FULL REPORT -----------------------------"];
        diag_log text format["TRANSMISSION INFORMATION:"];
        diag_log text format["    RADIO TX: %1", _realRadioTx];
        diag_log text format["    RADIO RX: %1", _realRadioRx];
        diag_log text format["    SENSITIVITY: %1dBm", _sinadRating];
        diag_log text format["    FREQUENCY: %1MHz", _f];
        diag_log text format["    TX POWER: %1mW (%2dBm)", _mW, _Ptx];
        diag_log text format["    TX GAIN: %1dBi", _transmitterGain];
        diag_log text format["    RX GAIN: %1dBi", _receiverGain];
        diag_log text format["    TX POS: %1", _transmitterPos];
        diag_log text format["    RX POS: %1", _receiverPos];
        diag_log text format["    2D DISTANCE: %1m", _2dDis];
        diag_log text format["    3D DISTANCE: %1m", _3dDis];
        diag_log text format["    HEIGHT DIFFERENCE (TX TO RX): %1m", (_transmitterPos select 2) - (_receiverPos select 2)];
        diag_log text format["SIGNAL LOSS INFORMATION:"];
        diag_log text format["    ITU LOSS: %1dBm", _ituLoss];
        diag_log text format["    OCLUSION LOSS TX: %1dBm", _pEaddTx];
        diag_log text format["    OCLUSION LOSS RX: %1dBm", _pEaddRx];
        diag_log text format["    FREE SPACE PATH LOSS: %1dBm", _Lfs];
        diag_log text format["    TOTAL QUALITY: %1%2 REL SINAD: %3%4", _Px*100, "%", ((_Px*100)-(_Slp*100)) max 0, "%"];



        diag_log text format[" "];
    #endif
};
// Return
[_Px, _Lb]
