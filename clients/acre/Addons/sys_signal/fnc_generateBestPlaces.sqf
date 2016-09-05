//fnc_generateBestPlaces.sqf
#include "script_component.hpp"

private ["_startTime", "_i", "_basePlaces", "_reflectPos", "_x", "_bestPlaces", "_bestAlt", "_bestPlace", "_testPos", "_alt", "_add", "_forEachIndex", "_endTime", "_rPos", "_offset", "_bestAngle", "_bestPos", "_c", "_normal"];
GVAR(reflections) = [];
for "_i" from 1 to 4 do {
    _basePlaces = _basePlaces + (selectBestPlaces [(getPos acre_player), 30000, "(hills max 0.6) - sea", 200, 1000]);
};
GVAR(runningGenerator) = true;
_fnc = {
    _params = _this select 0;
    _places = _params select 0;
    _index = _params select 1;
    
    _startTime = diag_tickTime;
    while {diag_tickTime-_startTime > 0.003} do {
        if(_index <= (count _places)-1) then {
            _x = _places select _index;
            _reflectPos = _x select 0;
            _bestPlaces = selectBestPlaces [_reflectPos, 500, "(hills max 0.8) - sea", 25, 300];
            _bestAlt = 0;
            _bestPlace = [];
            {
                _testPos = _x select 0;
                _alt = getTerrainHeightASL _testPos;
                if(_alt > _bestAlt) then {
                    _bestAlt = _alt;
                    _testPos set[2, _alt];
                    _bestPlace = _testPos;
                };
            } forEach _bestPlaces;
            if(count _bestPlace > 0) then {
                // diag_log text format["best: %1", _bestPlace];
                _add = true;
                {
                    if((_x select 0) vectorDistanceSqr _bestPlace < 20000) exitWith {
                        if((_x select 0) select 2 < _bestPlace select 2) then {
                            GVAR(reflections) set[_forEachIndex, [_bestPlace, []]];
                        };
                        _add = false;
                    };
                } forEach GVAR(reflections);
                if(_add) then {
                    GVAR(reflections) pushBack [_bestPlace, []];
                };
            };
            _index = _index + 1;
        } else {
            [(_this select 1)] call EFUNC(sys_sync,perFrame_remove);
            
            _fnc = {
                _params = _this select 0;
                _places = _params select 0;
                _index = _params select 1;
                
                _startTime = diag_tickTime;
                while {diag_tickTime-_startTime > 0.003} do {
                    if(_index <= (count _places)-1) then {
                        _rPos = _x select 0;
                        // ADDICON(ASLtoATL _rPos, _rPos);
                        _bestPlaces = [];
                        for "_i" from 0 to 17 do {
                            _offset = _i*20;
                            _bestAngle = 1;
                            _bestPos = [];
                            for "_c" from 0 to 9 do {
                                // diag_log text format["rpos: %1", _rPos];
                                _testPos = [_rPos, _c*5, _offset] call bis_fnc_relPos;
                                _normal = surfaceNormal _testPos;
                                if((_normal select 2) < _bestAngle) then {
                                    _bestPos = _testPos;
                                    _bestAngle = _normal select 2;
                                };
                            };
                            if((count _bestPos) > 0) then {
                                _bestPos set[2, getTerrainHeightASL _bestPos];
                                // ADDICON(ASLtoATL _bestPos, _bestPos);
                                _bestPlaces pushBack _bestPos;
                            };
                        };
                        _x set[1, _bestPlaces];
                    };
                };
            };
        };
    };
    _params set[1, _index];
    
};


