//fnc_doMultiPath.sqf
#include "script_component.hpp"

private ["_testExit", "_losExit", "_returnPos", "_l", "_startIndex", "_endDex", "_startTime", "_i", "_rxAntennaData", "_x", "_rxAntennaClass", "_txAntennaData", "_txAntennaClass", "_rxPos", "_txPos"];

params ["_params"];
_params params ["_returns","_txClass","_rxClass","_filter","_returnSize","_f","_mW","_results","_step","_time","_info","_txAntennas","_rxAntennas"];


_testExit       = false;
_losExit        = false;

if((count _returns) > _returnSize) then {
    if(_step == -1) then {
        _returnPos = [];
        // acre_player sideChat format["p: %1", [_f, _mW, _rxClass, _txClass, _returnPos]];
        _l = [_f, _mW, _rxClass, _txClass, _returnPos] call FUNC(losCalc);
        // acre_player sideChat format["_returnPos: %1", _returnPos];
        ADDICON(ASLtoATL +(_returnPos select 0), "TX " + (str _l) + "dBm");
        ADDLINECOLOR((_returnPos select 0), (_returnPos select 1), C(1,0,0,1));
        _results pushBack [_l, true];
        _params set[4, 0];
        _params set[8, 0];
        if(_l > -110) then {
            _testExit = true;
            _losExit = true;
        };
    } else {
        _step = [_results, _returns, _returnSize, _step, _f, _mW] call FUNC(calculateReflectionsInternal);
        _params set[8, _step];
        if(_step == 3) then {
            _params set[4, _returnSize+1];
            _params set[8, 0];
        };
    };
} else {
    
    
    _startIndex = (count _filter);
    _endDex = (count GVAR(reflections))-1;
    _startTime = diag_tickTime;
    
    for "_i" from _startIndex to _endDex do {
        {
            _rxAntennaData = _x;
            _rxAntennaClass = (_rxAntennaData select 0);
            {
                _txAntennaData = _x;
                _txAntennaClass = (_txAntennaData select 0);
                _rxPos = _rxAntennaData select 2;
                _txPos = _txAntennaData select 2;                    
                [_txPos, _rxPos, _i, _returns, _txAntennaClass, _rxAntennaClass] call FUNC(getReflections);
                if((count _returns) >= MAX_RETURNS) exitWith {};
            } forEach _txAntennas;
            if((count _returns) >= MAX_RETURNS) exitWith {};
        } forEach _rxAntennas;
        // diag_log text format["_returns %1: %2", diag_frameno, _returns];
        _filter pushBack _i;
        if(diag_tickTime - _startTime >= 0.002 || {(count _returns) >= MAX_RETURNS}) exitWith {};
    };
    _testExit = true;
};
if(_testExit && {(_losExit || {(count _filter) >= (count GVAR(reflections))} || {(count _returns) >= MAX_RETURNS && _returnSize >= MAX_RETURNS})}) exitWith {
        
    _info set[2, false];
    _info set[4, +_results];
    _info set[0, []];
    _info set[1, []];
    _info set[3, []];
    
    TEST_end = diag_tickTime;
    // acre_player sideChat format["t: %1 %2", TEST_end-TEST_start, (TEST_end-TEST_start)/((diag_frameno-TEST_startFrame) max 1)];
    false;
};
true;
