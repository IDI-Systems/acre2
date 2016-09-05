/*
	Copyright © 2016,International Development & Integration Systems, LLC
	All rights reserved.
	http://www.idi-systems.com/

	For personal use only. Military or commercial use is STRICTLY
	prohibited. Redistribution or modification of source code is 
	STRICTLY prohibited.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
	"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
	LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
	COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
	INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES INCLUDING,
	BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
	CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
	LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
	ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
	POSSIBILITY OF SUCH DAMAGE.
*/
//XEH_pre_init.sqf
#include "script_component.hpp"



NO_DEDICATED;
ADDON = false;

DFUNC(onMapClick) = {
    if(_this select 1 != 0) exitWith {};
    with uiNamespace do {
        _mapCtrl = (GVAR(mapDisplay) displayCtrl 51);
        _clickPos = _mapCtrl ctrlMapScreenToWorld [_this select 2, _this select 3];
        _clickPos set[2, 0];
        _foundArea = nil;
        {
            _startPos = _x select 2;
            _endPos = _x select 3;
            if(_clickPos select 0 >= _startPos select 0 && _clickPos select 1 >= _startPos select 1 &&
                _clickPos select 0 <= _endPos select 0 && _clickPos select 1 <= _endPos select 1) exitWith {
                    _foundArea = _x;
            };
        } forEach GVAR(completedAreas);
        if(isNil "_foundArea") exitWith {
            GVAR(sampleData) = [];
        };
        _id = _foundArea select 0;
        _sampleSize = _foundArea select 1;
        _startPos = _foundArea select 2;
        _endPos = _foundArea select 3;
        
        _size = _endPos vectorDiff _startPos;
        
        _offset = _clickPos vectorDiff _startPos;
        _indexOffset = [floor ((_offset select 0)/_sampleSize), floor ((_offset select 1)/_sampleSize)];
        _extents = [floor ((_size select 0)/_sampleSize), floor ((_size select 1)/_sampleSize)];
        
        if(_indexOffset select 0 < _extents select 0 && _indexOffset select 1 < _extents select 1) then {
            // player sideChat format["found: %1", _indexOffset];
            
            _args = [_id, _indexOffset select 0, _indexOffset select 1, _extents select 0, _extents select 1];
            _result = [];
            with missionNamespace do {
                _result = ["signal_map_get_sample_data", _args] call acre_sys_core_fnc_callExt;
            };
            GVAR(sampleData) = [];
            if(!isNil "_result") then {
                if((count _result) > 0) then {
                    // player sideChat format["res: %1", _result select 2];
                    GVAR(sampleData) pushBack _result;
                };
            };
        };
    };
};

DFUNC(drawSignalMaps) = {
    with uiNamespace do {
        _mapCtrl = (GVAR(mapDisplay) displayCtrl 51);
        _pos1 = _mapCtrl ctrlMapWorldToScreen [4096,0,0];
        _pos2 = _mapCtrl ctrlMapWorldToScreen [0,4096,0];
        
        _width = (_pos1 select 0)-(_pos2 select 0);
        _height = (_pos1 select 1)-(_pos2 select 1);
        {
            _tile = GVAR(mapTiles) select _forEachIndex;
            _filename = _x select 0;
            _startPos = _x select 2;
            
            
            
            
            _mapStartPos = _mapCtrl ctrlMapWorldToScreen _startPos;
            
            
            _signalMapPos = [(_mapStartPos select 0), (_mapStartPos select 1)-_height, _width, _height];
            
            _tile ctrlSetPosition _signalMapPos;
            _tile ctrlShow true;
            _tile ctrlSetText "userconfig\" + _filename + ".paa";
            _tile ctrlCommit 0;
        } forEach GVAR(completedAreas);
        {
            _sample = _x;
            // player sideChat format["%1 %2", _x select 0, _x select 1];
            _txPos = _sample select 0;
            _rxPos = _sample select 1;
            drawLine3D [ASLtoATL _txPos, ASLtoATL _rxPos, [0, 1, 0, 1]];
            _reflections = _sample select 3;
            {
                _reflection = _x;
                if(count _reflection == 0) exitWith {};
                _point = _reflection select 0;
                drawLine3D [ASLtoATL _txPos, ASLtoATL _point, [1, 0, 0, 1]];
                drawLine3D [ASLtoATL _point, ASLtoATL _rxPos, [0, 0, 1, 1]];
            } forEach _reflections;
        } forEach GVAR(sampleData);
        
    };
};

DFUNC(drawSignalSamples) = {
    with uiNamespace do {
        _mapCtrl = _this select 0;
        {
            _sample = _x;
            // player sideChat format["%1 %2", _x select 0, _x select 1];
            _txPos = _sample select 0;
            _rxPos = _sample select 1;
            _mapCtrl drawArrow [_txPos, _rxPos, [0, 1, 0, 1]];
            _reflections = _sample select 3;
            {
                _reflection = _x;
                if(count _reflection == 0) exitWith {};
                _point = _reflection select 0;
                _mapCtrl drawLine [_txPos, _point, [1, 0, 0, 1]];
                _mapCtrl drawArrow [_point, _rxPos, [0, 0, 1, 1]];
                _mapCtrl drawIcon [
                    '\a3\ui_f\data\IGUI\Cfg\Actions\clear_empty_ca.paa',
                    [0,0,1,1],
                    _point,
                    5,
                    5,
                    0,
                    format["%1, %2, %3", deg(_reflection select 2), _reflection select 3, _reflection select 4],
                    0,
                    0.05,
                    'EtelkaNarrowMediumPro',
                    "center"
                ];
            } forEach _reflections;
        } forEach GVAR(sampleData);
    };
};

DFUNC(doProcess) = {
    with uiNamespace do {
        
        _txAntennaName = GVAR(txAntennaListBox) lbData (lbCurSel GVAR(txAntennaListBox));
        GVAR(txAntennaListBoxValue) = lbCurSel GVAR(txAntennaListBox);
        
        GVAR(txHeightValue) = parseNumber (ctrlText GVAR(txHeight));
        
        _txDir = [1, (parseNumber (ctrlText GVAR(txDir)))*-1, 0] call cba_fnc_polar2vect;
        GVAR(txDirValue) = (parseNumber (ctrlText GVAR(txDir)));
        
        _rxAntennaName = GVAR(rxAntennaListBox) lbData (lbCurSel GVAR(rxAntennaListBox));
        GVAR(rxAntennaListBoxValue) = lbCurSel GVAR(rxAntennaListBox);
        
        GVAR(rxHeightValue) = parseNumber (ctrlText GVAR(rxHeight));
        
        _sampleSize = floor (parseNumber (ctrlText GVAR(sampleSize)));
        if(_sampleSize < 1) exitWith {
            hint format["The sample size must be equal to or larger than 1."];
        };
        GVAR(sampleSizeValue) = _sampleSize;
        
        _frequency = parseNumber (ctrlText GVAR(txFreq));
        if(_frequency < 30) exitWith {
            hint format["The frequency must be equal to or larger than 30MHz."];
        };
        GVAR(txFreqValue) = _frequency;
        
        _power = parseNumber (ctrlText GVAR(txPower));
        if(_power <= 0) exitWith {
            hint format["The Tx power must be larger than 0mW."];
        };
        GVAR(txPowerValue) = _power;
        
        _lowerSensitivity = parseNumber (ctrlText GVAR(rxSensitivity));
        _upperSensitivity = parseNumber (ctrlText GVAR(rxSensitivityUpper));
        
        if(_lowerSensitivity > _upperSensitivity) exitWith {
            hint format["The upper sensitivity must be larger than the lower sensitivity."];
        };
        
        GVAR(rxSensitivityValue) = _lowerSensitivity;
        GVAR(rxSensitivityUpperValue) = _upperSensitivity;
        
        if(isNil QUOTE(GVAR(txPosition))) exitWith {
            hint format["Please set the Tx position."];
        };
        
        if(count GVAR(rxAreas) == 0) exitWith {
            hint format["Please set at least one Rx area."];
        };
        GVAR(completedAreas) = [];
        GVAR(areaProgress) = 0;
        
        
    
        GVAR(ctrlGroup) ctrlShow false;
        GVAR(ctrlGroup) ctrlCommit 0;
        GVAR(overlayMessageGrp) = GVAR(mapDisplay) ctrlCreate ["RscControlsGroupNoScrollbars", 13119];
        GVAR(signal_debug) pushBack GVAR(overlayMessageGrp);
        GVAR(overlayMessageGrp) ctrlSetPosition [safezoneX + safezoneW - 0.5, safezoneY + safezoneH - 1, 0.5, 0.75];
        GVAR(overlayMessageGrp) ctrlCommit 0;
        ctrlSetFocus GVAR(overlayMessageGrp);
        CTRLOVERLAY(_bg, "RscBackground");
        _bg ctrlSetPosition [0, 0, 0.5, 0.75];
        _bg ctrlCommit 0;
        
        CTRLOVERLAY(GVAR(chunkProgressText), "RscStructuredText");
        GVAR(chunkProgressText) ctrlSetPosition [0.0, 0.25, 0.5, 0.045];
        GVAR(chunkProgressText) ctrlCommit 0;
        
        CTRLOVERLAY(GVAR(progressBar), "RscProgress");
        GVAR(progressBar) ctrlSetPosition [0.025, 0.3, 0.45, 0.045];
        GVAR(progressBar) ctrlCommit 0;
        GVAR(progressBar) progressSetPosition 0;
        
        CTRLOVERLAY(GVAR(areaProgressText), "RscStructuredText");
        GVAR(areaProgressText) ctrlSetPosition [0.0, 0.35, 0.5, 0.045];
        GVAR(areaProgressText) ctrlSetStructuredText (parseText format["<t align='center'>Processing Area: %1 of %2</t>", GVAR(areaProgress)+1, (count GVAR(rxAreas))]);
        GVAR(areaProgressText) ctrlCommit 0;
        
        CTRLOVERLAY(GVAR(progressBarArea), "RscProgress");
        GVAR(progressBarArea) ctrlSetPosition [0.025, 0.4, 0.45, 0.045];
        GVAR(progressBarArea) ctrlCommit 0;
        GVAR(progressBarArea) progressSetPosition 0;
        GVAR(currentId) = format["%1_%2_%3_signalmap", worldName, floor diag_tickTime, _sampleSize];
        GVAR(currentArgs) = [];
        {
            _args = [
                format["%1_%2", GVAR(currentId), _forEachIndex],
                _sampleSize,
                +((_x select 0) select 0),
                +((_x select 0) select 1),
                +GVAR(txPosition),
                +_txDir,
                GVAR(txHeightValue),
                GVAR(rxHeightValue),
                _txAntennaName,
                _rxAntennaName,
                _frequency,
                _power,
                _lowerSensitivity,
                _upperSensitivity
            ];
            GVAR(currentArgs) pushBack +_args;
            with missionNamespace do {
                [
                    "signal_map",
                    _args,
                    true,
                    {
                        with uiNamespace do {
                            diag_log text format["Completed area: %1", GVAR(areaProgress)];
                            GVAR(completedAreas) pushBack +(GVAR(currentArgs) select GVAR(areaProgress));
                            _marker = (GVAR(rxAreas) select GVAR(areaProgress)) select 1;
                            _marker setMarkerBrushLocal "Border";
                            // _marker setMarkerAlphaLocal 0;
                            
                            
                            GVAR(areaProgress) = GVAR(areaProgress) + 1;
                            GVAR(progressBarArea) progressSetPosition (GVAR(areaProgress)/(count GVAR(rxAreas)));
                            if(GVAR(areaProgress)/(count GVAR(rxAreas)) != 1) then {
                                GVAR(areaProgressText) ctrlSetStructuredText (parseText format["<t align='center'>Processing Area: %1 of %2</t>", GVAR(areaProgress)+1, (count GVAR(rxAreas))]);
                            } else {
                                GVAR(areaProgressText) ctrlSetStructuredText (parseText "<t align='center'>Finished</t>");
                            };
                        };
                    },
                    []
                ] call acre_sys_core_fnc_callExt;
            };
            
        } forEach GVAR(rxAreas);
        with missionNamespace do {
            _fnc = {
                with uiNamespace do {
                    if(GVAR(areaProgress) != (count GVAR(rxAreas))) then {
                        _res = [1,1];
                        with missionNamespace do {
                            _res = ["signal_map_progress", ""] call acre_sys_core_fnc_callExt;
                        };
                        diag_log text format["res: %1", _res];
                        _p = (_res select 0)/(_res select 1);
                        GVAR(progressBar) progressSetPosition _p;
                        if(_p != 1) then {
                            GVAR(chunkProgressText) ctrlSetStructuredText (parseText format["<t align='center'>%1/%2</t>", _res select 0, _res select 1]);
                        } else {
                            GVAR(chunkProgressText) ctrlSetStructuredText (parseText "<t align='center'>Processing PNG to PAA...</t>");
                        };
                    } else {
                        GVAR(chunkProgressText) ctrlSetStructuredText (parseText "<t align='center'>Finished</t>");
                        {
                            (_x select 1) setMarkerAlphaLocal 0;
                        } forEach GVAR(rxAreas);
                        CTRLOVERLAY(GVAR(modifyButton), "RscButton");
                        GVAR(modifyButton) ctrlSetPosition [0.05, 0.055*10, 0.4, 0.045];
                        GVAR(modifyButton) ctrlSetBackgroundColor [0,0,0,0.25];
                        GVAR(modifyButton) ctrlSetText "Modify";
                        GVAR(modifyButton) ctrlSetEventHandler ["MouseButtonUp", QUOTE([] call FUNC(modify))];
                        GVAR(modifyButton) ctrlCommit 0;
                        
                        CTRLOVERLAY(GVAR(clearButton), "RscButton");
                        GVAR(clearButton) ctrlSetPosition [0.05, 0.055*11, 0.4, 0.045];
                        GVAR(clearButton) ctrlSetBackgroundColor [0,0,0,0.25];
                        GVAR(clearButton) ctrlSetText "Clear";
                        GVAR(clearButton) ctrlSetEventHandler ["MouseButtonUp", QUOTE([] call FUNC(clear))];
                        GVAR(clearButton) ctrlCommit 0;
                        
                        with missionNamespace do {
                            [(_this select 1)] call cba_fnc_removePerFrameHandler;
                        };
                    };
                };
            };
            [_fnc, 0.1, []] call cba_fnc_addPerFrameHandler;
        };
    };
};

DFUNC(modify) = {
    [] spawn {
        sleep 0.1;
        [] call FUNC(clearOverlayMessage);
    };
    with uiNamespace do {
        {
            (_x select 1) setMarkerAlphaLocal 1;
        } forEach GVAR(rxAreas);
    };
};

DFUNC(clear) = {
    with uiNamespace do {
        {
            deleteMarker (_x select 1);
        } forEach GVAR(rxAreas);
        GVAR(rxAreas) = [];
        {
            _tile = GVAR(mapTiles) select _forEachIndex;
            _tile ctrlSetText "";
            _tile ctrlShow false;
            _tile ctrlCommit 0;
        } forEach GVAR(completedAreas);
        GVAR(completedAreas) = [];
        GVAR(txPosition) = nil;
        deleteMarker QGVAR(txPosMarker);
        lbClear GVAR(rxAreaList);
        GVAR(rxAreaList) ctrlCommit 0;
        GVAR(sampleData) = [];
    };
    [] call FUNC(modify);
};

DFUNC(showOverlayMessage) = {
    with uiNamespace do {
        GVAR(ctrlGroup) ctrlShow false;
        GVAR(ctrlGroup) ctrlCommit 0;
        GVAR(overlayMessageGrp) = GVAR(mapDisplay) ctrlCreate ["RscControlsGroupNoScrollbars", 13119];
        GVAR(signal_debug) pushBack GVAR(overlayMessageGrp);
        GVAR(overlayMessageGrp) ctrlSetPosition [safezoneX + safezoneW - 0.5, safezoneY + safezoneH - 1, 0.5, 0.75];
        GVAR(overlayMessageGrp) ctrlCommit 0;
        ctrlSetFocus GVAR(overlayMessageGrp);
        CTRLOVERLAY(_bg, "RscBackground");
        _bg ctrlSetPosition [0, 0, 0.5, 0.75];
        _bg ctrlCommit 0;
        CTRLOVERLAY(_customText, "RscStructuredText");
        _customText ctrlSetPosition [0, 0.3, 0.5, 0.75/2];
        _customText ctrlSetStructuredText (parseText (_this select 0));
        _customText ctrlCommit 0;
    };
};

DFUNC(clearOverlayMessage) = {
    with uiNamespace do {
        GVAR(ctrlGroup) ctrlShow true;
        GVAR(ctrlGroup) ctrlCommit 0;
        ctrlDelete GVAR(overlayMessageGrp);
    };
};

DFUNC(onAreaLBChange) = {
    with uiNamespace do {
        if((count GVAR(rxAreas)) > 0) then {
            {
                (_x select 1) setMarkerColorLocal "ColorYellow";
                (_x select 1) setMarkerBrushLocal "DiagGrid";
                (_x select 1) setMarkerAlphaLocal 0.5;
                
            } forEach GVAR(rxAreas);
            ((GVAR(rxAreas) select (_this select 1)) select 1) setMarkerColorLocal "ColorRed";
            ((GVAR(rxAreas) select (_this select 1)) select 1) setMarkerBrushLocal "Solid";
            ((GVAR(rxAreas) select (_this select 1)) select 1) setMarkerAlphaLocal 1;
            
            
        };
    };
};

DFUNC(addRxAreaStart) = {
    if(_this select 1 == 0) then {
        ["<t align='center'>Click on the map to set the start of a Rx sampling area.</t>"] call FUNC(showOverlayMessage);
        GVAR(rxSetEH) = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["MouseButtonDown", QUOTE(_this call DFUNC(setRxAreaBegin))];
    };
};

DFUNC(setRxAreaBegin) = {
    if(_this select 1 == 0) then {
        [] call FUNC(clearOverlayMessage);
        ["<t align='center'>Now, click elsewhere on the map to set the end of the Rx sampling area.</t>"] call FUNC(showOverlayMessage);
        _ctrl = _this select 0;
        _ctrl ctrlRemoveEventHandler ["MouseButtonDown", GVAR(rxSetEH)];
        
        _x = _this select 2;
        _y = _this select 3;
        _pos = ((findDisplay 12) displayCtrl 51) ctrlMapScreenToWorld [_x, _y];
        _pos set[2, 0];
        with uiNamespace do {
            GVAR(rxAreaStart) = _pos;
            deleteMarkerLocal QGVAR(rxAreaStartMarker);
            _marker = createMarkerLocal [QGVAR(rxAreaStartMarker), _pos];
            _marker setMarkerTypeLocal "mil_dot_noshadow";
            _marker setMarkerTextLocal "Rx Area Begin";
            _marker setMarkerColorLocal "ColorRed";
        };
        GVAR(rxSetEH) = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["MouseButtonDown", QUOTE(_this call FUNC(setRxAreaEnd))];
    };
};
#define TILE_SIZE 4000
DFUNC(setRxAreaEnd) = {
    if(_this select 1 == 0) then {
        _ctrl = _this select 0;
        _ctrl ctrlRemoveEventHandler ["MouseButtonDown", GVAR(rxSetEH)];
        [] call FUNC(clearOverlayMessage);
        _x = _this select 2;
        _y = _this select 3;
        _pos = ((findDisplay 12) displayCtrl 51) ctrlMapScreenToWorld [_x, _y];
        _pos set[2, 0];
        with uiNamespace do {
            GVAR(rxAreaEnd) = _pos;
            deleteMarkerLocal QGVAR(rxAreaStartMarker);
            
            _size = GVAR(rxAreaEnd) vectorDiff GVAR(rxAreaStart);
    
            if(_size select 0 < 0) then {
                _temp_start = +GVAR(rxAreaStart);
                _temp_end = +GVAR(rxAreaEnd);
                
                GVAR(rxAreaStart) = [(GVAR(rxAreaStart) select 0) + (_size select 0), GVAR(rxAreaStart) select 1, 0];
                GVAR(rxAreaEnd) = [_temp_start select 0, GVAR(rxAreaEnd) select 1, 0];
                _size = GVAR(rxAreaEnd) vectorDiff GVAR(rxAreaStart);
            };
            
            if(_size select 1 < 0) then {
                _temp_start = +GVAR(rxAreaStart);
                _temp_end = +GVAR(rxAreaEnd);
                
                GVAR(rxAreaStart) = [GVAR(rxAreaStart) select 0, (GVAR(rxAreaStart) select 1) + (_size select 1), 0];
                GVAR(rxAreaEnd) = [GVAR(rxAreaEnd) select 0, _temp_start select 1, 0];
                _size = GVAR(rxAreaEnd) vectorDiff GVAR(rxAreaStart);
            };
            
            _width = _size select 0;
            _height = _size select 1;
            
            
            _sampleSize = floor (parseNumber (ctrlText GVAR(sampleSize)));
            
            if(_width < _sampleSize || _height < _sampleSize) exitWith {
                hintSilent "Indvidual Rx areas must be larger than the sample size in both directions!";
            };
            
            _xTiles = ceil (_width / TILE_SIZE);
            _yTiles = ceil  (_height / TILE_SIZE);
            
            
            
            for "_x" from 0 to _xTiles-1 do {
                _xScale = ((_width / TILE_SIZE)-(_x)) min 1;
                diag_log text format["x: %1", _xScale];
                for "_y" from 0 to _yTiles-1 do {
                    _yScale = ((_height / TILE_SIZE)-(_y)) min 1;
                    
                    _start = [(GVAR(rxAreaStart) select 0) + (TILE_SIZE * _x), (GVAR(rxAreaStart) select 1) + (TILE_SIZE * _y), 0];
                    _end = [(_start select 0) + (TILE_SIZE * _xScale), (_start select 1) + (TILE_SIZE * _yScale), 0];
                    
                    _markerPos = [(_start select 0) + ((TILE_SIZE * _xScale) / 2), (_start select 1) + ((TILE_SIZE * _yScale) / 2)];
                    
                    _marker = createMarkerLocal [format["rxarea_%1", (count GVAR(rxAreas))], _markerPos];
                    _marker setMarkerSizeLocal [(TILE_SIZE * _xScale) / 2, (TILE_SIZE * _yScale) / 2];
                    _marker setMarkerShapeLocal "RECTANGLE";
                    _marker setMarkerColorLocal "ColorRed";
                    
                    
                    
                    GVAR(rxAreas) pushBack [[+_start, +_end], _marker];
                    
                    GVAR(rxAreaList) lbAdd format["%1: [%2, %3]", (count GVAR(rxAreas)), _markerPos select 0, _markerPos select 1];
                    GVAR(rxAreaList) lbSetData [(count GVAR(rxAreas)) - 1, str ((count GVAR(rxAreas)) - 1)];
                    GVAR(rxAreaList) lbSetCurSel ((count GVAR(rxAreas)) - 1);
                    GVAR(rxAreaList) ctrlCommit 0;
                };
            };
        };
    };
};


DFUNC(setTxPositionStart) = {
    if(_this select 1 == 0) then {
        ["<t align='center'>Click on the map to set the Tx Position</t>"] call FUNC(showOverlayMessage);
        GVAR(txSetPosEH) = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["MouseButtonDown", QUOTE(_this call FUNC(setTxPositionEnd))];
    };
};

DFUNC(setTxPositionEnd) = {
    if(_this select 1 == 0) then {
        [] call FUNC(clearOverlayMessage);
        _ctrl = _this select 0;
        _ctrl ctrlRemoveEventHandler ["MouseButtonDown", GVAR(txSetPosEH)];
        
        _x = _this select 2;
        _y = _this select 3;
        _pos = ((findDisplay 12) displayCtrl 51) ctrlMapScreenToWorld [_x, _y];
        _pos set[2, (getTerrainHeightASL _pos)];
        with uiNamespace do {
            GVAR(txPositionTxt) ctrlSetText format["%1,%2,%3", (_pos select 0) call FUNC(formatNumber), (_pos select 1) call FUNC(formatNumber), (_pos select 2) call FUNC(formatNumber)];
            GVAR(txPositionTxt) ctrlCommit 0;
            GVAR(txPosition) = _pos;
            deleteMarkerLocal QGVAR(txPosMarker);
            _marker = createMarkerLocal [QGVAR(txPosMarker), _pos];
            _marker setMarkerTypeLocal "mil_dot_noshadow";
            _marker setMarkerTextLocal "Tx Pos";
            _marker setMarkerColorLocal "ColorGreen";
        };
    };
};

DFUNC(drawMenu) = {
    with uiNamespace do {
        GVAR(debugIdc) = 13121;
       
        
        GVAR(completedAreas) = [];
        GVAR(currentArgs) = [];
        GVAR(areaProgress) = 0;
        FUNC(formatNumber) = {
            private ["_ext", "_str", "_d"];
            _ext = abs _this - (floor abs _this);
            _str = "";
            for "_i" from 1 to 8 do {
                _d = floor (_ext*10);
                _str = _str + (str _d);
                _ext = (_ext*10)-_d;
            };
            format["%1%2.%3", ["","-"] select (_this < 0), (floor (abs _this)), _str];
        };

        { diag_log text format["clean up: %1", _x]; ctrlDelete _x; } forEach GVAR(signal_debug);
        

        GVAR(signal_debug) = [];
        
        GVAR(mapTiles) = [];
        for "_i" from 1 to 50 do {
            _tile = GVAR(mapDisplay) ctrlCreate ["RscPicture", 120101+_i];
            GVAR(mapTiles) pushBack _tile;
            GVAR(signal_debug) pushBack _tile;
        };

        GVAR(ctrlGroup) = GVAR(mapDisplay) ctrlCreate ["RscControlsGroupNoScrollbars", 13120];
        GVAR(signal_debug) pushBack GVAR(ctrlGroup);

        GVAR(ctrlGroup) ctrlSetBackgroundColor [1,1,0,1];
        GVAR(ctrlGroup) ctrlSetForegroundColor [1,1,0,1];

        GVAR(ctrlGroup) ctrlSetPosition [safezoneX + safezoneW - 0.5, safezoneY + safezoneH - 1, 0.5, 0.75];
        GVAR(ctrlGroup) ctrlCommit 0;

        CTRL(_background, "RscBackground");
        

        //_background ctrlSetBackgroundColor [0.8,0.75,0.35,0.75];

        _background ctrlSetPosition [0, 0, 0.5, 0.75];
        _background ctrlCommit 0;
        
        CTRL(GVAR(txAntennaListBox), "RscCombo");
        
        GVAR(txAntennaListBox) ctrlSetPosition [0.15, 0, 0.35, 0.045];
        _components = configFile >> "CfgAcreComponents";
        _c = 0;
        for "_i" from 0 to (count _components) - 1 do {
            _component = _components select _i;
            _type = getNumber(_component >> "type");
            if(_type == ACRE_COMPONENT_ANTENNA) then {
                if(getText(_component >> "binaryGainFile") != "") then {
                    GVAR(txAntennaListBox) lbAdd (getText(_component >> "name"));
                    GVAR(txAntennaListBox) lbSetData [_c, (configName _component)];
                    diag_log text format["d: %1", GVAR(txAntennaListBox) lbData _c];
                    _c = _c + 1;
                };
            };
        };
        GVAR(txAntennaListBox) lbSetCurSel (uiNamespace getVariable [QGVAR(txAntennaListBoxValue), 0]);
        GVAR(txAntennaListBox) ctrlCommit 0;
        
        CTRL(_txAntText, "RscText");
        _txAntText ctrlSetPosition [0.0, 0, 0.35, 0.045];
        _txAntText ctrlSetText "Tx Antenna: ";
        _txAntText ctrlCommit 0;
        
        CTRL(GVAR(txHeight), "RscEdit");
        GVAR(txHeight) ctrlSetPosition [0.15, 0.055, 0.1, 0.045];
        GVAR(txHeight) ctrlSetBackgroundColor [0,0,0,0.25];
        GVAR(txHeight) ctrlSetText str (uiNamespace getVariable [QGVAR(txHeightValue), 2]);
        GVAR(txHeight) ctrlCommit 0;
        
         CTRL(_txHeightTxt, "RscText");
        _txHeightTxt ctrlSetPosition [0.0, 0.055, 0.35, 0.045];
        _txHeightTxt ctrlSetText "Tx Height: ";
        _txHeightTxt ctrlCommit 0;
        
        CTRL(GVAR(txDir), "RscEdit");
        GVAR(txDir) ctrlSetPosition [0.35, 0.055, 0.1, 0.045];
        GVAR(txDir) ctrlSetBackgroundColor [0,0,0,0.25];
        GVAR(txDir) ctrlSetText str (uiNamespace getVariable [QGVAR(txDirValue), 0]);
        GVAR(txDir) ctrlCommit 0;
        
         CTRL(_txDirTxt, "RscText");
        _txDirTxt ctrlSetPosition [0.26, 0.055, 0.35, 0.045];
        _txDirTxt ctrlSetText "Tx Dir: ";
        _txDirTxt ctrlCommit 0;
        
        
        CTRL(GVAR(rxAntennaListBox), "RscCombo");
        
        GVAR(rxAntennaListBox) ctrlSetPosition [0.15, 0.055*2, 0.35, 0.045];
        _components = configFile >> "CfgAcreComponents";
        _c = 0;
        for "_i" from 0 to (count _components) - 1 do {
            _component = _components select _i;
            _type = getNumber(_component >> "type");
            if(_type == ACRE_COMPONENT_ANTENNA) then {
                if(getText(_component >> "binaryGainFile") != "") then {
                    GVAR(rxAntennaListBox) lbAdd (getText(_component >> "name"));
                    GVAR(rxAntennaListBox) lbSetData [_c, (configName _component)];
                    _c = _c + 1;
                };
            };
        };
        GVAR(rxAntennaListBox) lbSetCurSel (uiNamespace getVariable [QGVAR(rxAntennaListBoxValue), 0]);
        GVAR(rxAntennaListBox) ctrlCommit 0;
        
        CTRL(_rxAntText, "RscText");
        _rxAntText ctrlSetPosition [0.0, 0.055*2, 0.35, 0.045];
        _rxAntText ctrlSetText "Rx Antenna: ";
        _rxAntText ctrlCommit 0;
        
        CTRL(GVAR(rxHeight), "RscEdit");
        GVAR(rxHeight) ctrlSetPosition [0.15, 0.055*3, 0.1, 0.045];
        GVAR(rxHeight) ctrlSetBackgroundColor [0,0,0,0.25];
        GVAR(rxHeight) ctrlSetText str (uiNamespace getVariable [QGVAR(rxHeightValue), 2]);
        GVAR(rxHeight) ctrlCommit 0;
        
         CTRL(_rxHeightTxt, "RscText");
        _rxHeightTxt ctrlSetPosition [0.0, 0.055*3, 0.35, 0.045];
        _rxHeightTxt ctrlSetText "Rx Height: ";
        _rxHeightTxt ctrlCommit 0;
        
        CTRL(GVAR(sampleSize), "RscEdit");
        GVAR(sampleSize) ctrlSetPosition [0.42, 0.055*3, 0.07, 0.045];
        GVAR(sampleSize) ctrlSetBackgroundColor [0,0,0,0.25];
        GVAR(sampleSize) ctrlSetText str (uiNamespace getVariable [QGVAR(sampleSizeValue), 50]);
        GVAR(sampleSize) ctrlCommit 0;
        
         CTRL(_txSampleSizeTxt, "RscText");
        _txSampleSizeTxt ctrlSetPosition [0.26, 0.055*3, 0.35, 0.045];
        _txSampleSizeTxt ctrlSetText "Sample Size: ";
        _txSampleSizeTxt ctrlCommit 0;
        
        CTRL(GVAR(txFreq), "RscEdit");
        GVAR(txFreq) ctrlSetPosition [0.15, 0.055*4, 0.2, 0.045];
        GVAR(txFreq) ctrlSetBackgroundColor [0,0,0,0.25];
        GVAR(txFreq) ctrlSetText str (uiNamespace getVariable [QGVAR(txFreqValue), 65]);
        GVAR(txFreq) ctrlCommit 0;
        
        CTRL(_rxHeightTxt, "RscText");
        _rxHeightTxt ctrlSetPosition [0.0, 0.055*4, 0.35, 0.045];
        _rxHeightTxt ctrlSetText "Frequency: ";
        _rxHeightTxt ctrlCommit 0;
        
        CTRL(_rxHeightTxt, "RscText");
        _rxHeightTxt ctrlSetPosition [0.35, 0.055*4, 0.35, 0.045];
        _rxHeightTxt ctrlSetText "MHz";
        _rxHeightTxt ctrlCommit 0;
        
        CTRL(GVAR(txPower), "RscEdit");
        GVAR(txPower) ctrlSetPosition [0.15, 0.055*5, 0.2, 0.045];
        GVAR(txPower) ctrlSetBackgroundColor [0,0,0,0.25];
        GVAR(txPower) ctrlSetText str (uiNamespace getVariable [QGVAR(txPowerValue), 4000]);
        GVAR(txPower) ctrlCommit 0;
        
        CTRL(_rxHeightTxt, "RscText");
        _rxHeightTxt ctrlSetPosition [0.0, 0.055*5, 0.35, 0.045];
        _rxHeightTxt ctrlSetText "Tx Power: ";
        _rxHeightTxt ctrlCommit 0;
        
        CTRL(_rxHeightTxt, "RscText");
        _rxHeightTxt ctrlSetPosition [0.35, 0.055*5, 0.35, 0.045];
        _rxHeightTxt ctrlSetText "mW";
        _rxHeightTxt ctrlCommit 0;
        
        CTRL(GVAR(rxSensitivity), "RscEdit");
        GVAR(rxSensitivity) ctrlSetPosition [0.15, 0.055*6, 0.2, 0.045];
        GVAR(rxSensitivity) ctrlSetBackgroundColor [0,0,0,0.25];
        GVAR(rxSensitivity) ctrlSetText str (uiNamespace getVariable [QGVAR(rxSensitivityValue), -116]);
        GVAR(rxSensitivity) ctrlCommit 0;
        
        CTRL(_rxHeightTxt, "RscText");
        _rxHeightTxt ctrlSetPosition [0.0, 0.055*6, 0.35, 0.045];
        _rxHeightTxt ctrlSetText "Sensitivity: ";
        _rxHeightTxt ctrlCommit 0;
        
        CTRL(_rxHeightTxt, "RscText");
        _rxHeightTxt ctrlSetPosition [0.35, 0.055*6, 0.35, 0.045];
        _rxHeightTxt ctrlSetText "dBm (min)";
        _rxHeightTxt ctrlCommit 0;
        
        CTRL(GVAR(rxSensitivityUpper), "RscEdit");
        GVAR(rxSensitivityUpper) ctrlSetPosition [0.15, 0.055*7, 0.2, 0.045];
        GVAR(rxSensitivityUpper) ctrlSetBackgroundColor [0,0,0,0.25];
        GVAR(rxSensitivityUpper) ctrlSetText str (uiNamespace getVariable [QGVAR(rxSensitivityUpperValue), -50]);
        GVAR(rxSensitivityUpper) ctrlCommit 0;
        
        CTRL(_rxHeightTxt, "RscText");
        _rxHeightTxt ctrlSetPosition [0.0, 0.055*7, 0.35, 0.045];
        _rxHeightTxt ctrlSetText "Sensitivity: ";
        _rxHeightTxt ctrlCommit 0;
        
        CTRL(_rxHeightTxt, "RscText");
        _rxHeightTxt ctrlSetPosition [0.35, 0.055*7, 0.35, 0.045];
        _rxHeightTxt ctrlSetText "dBm (max)";
        _rxHeightTxt ctrlCommit 0;
        
        CTRL(GVAR(setTxPosButton), "RscButton");
        GVAR(setTxPosButton) ctrlSetPosition [0.05, 0.055*8, 0.4, 0.045];
        GVAR(setTxPosButton) ctrlSetBackgroundColor [0,0,0,0.25];
        GVAR(setTxPosButton) ctrlSetText "Set Tx Position";
        GVAR(setTxPosButton) ctrlSetEventHandler ["MouseButtonUp", QUOTE(_this call FUNC(setTxPositionStart))];
        GVAR(setTxPosButton) ctrlCommit 0;
        
        CTRL(GVAR(txPositionTxt), "RscEdit");
        GVAR(txPositionTxt) ctrlSetPosition [0.15, 0.055*9, 0.35, 0.045];
        GVAR(txPositionTxt) ctrlSetBackgroundColor [0,0,0,0.25];
        GVAR(txPositionTxt) ctrlSetText "";
        GVAR(txPositionTxt) ctrlCommit 0;
        
        CTRL(_rxHeightTxt, "RscText");
        _rxHeightTxt ctrlSetPosition [0.0, 0.055*9, 0.35, 0.045];
        _rxHeightTxt ctrlSetText "Tx Position: ";
        _rxHeightTxt ctrlCommit 0;
        
        CTRL(GVAR(addRxAreaButton), "RscButton");
        GVAR(addRxAreaButton) ctrlSetPosition [0.05, 0.055*10, 0.4, 0.045];
        GVAR(addRxAreaButton) ctrlSetBackgroundColor [0,0,0,0.25];
        GVAR(addRxAreaButton) ctrlSetText "Add Rx Area";
        GVAR(addRxAreaButton) ctrlSetEventHandler ["MouseButtonUp", QUOTE(_this call FUNC(addRxAreaStart))];
        GVAR(addRxAreaButton) ctrlCommit 0;
        
        CTRL(GVAR(rxAreaList), "RscCombo");
        
        GVAR(rxAreaList) ctrlSetPosition [0.05, 0.055*11, 0.3, 0.045];
        _components = configFile >> "CfgAcreComponents";
        _i = 0;
        {
            GVAR(rxAreaList) lbAdd format["%1: %2", _forEachIndex + 1, (_x select 0)];
            GVAR(rxAreaList) lbSetData [_i, str _forEachIndex];
            _i = _i + 1;
        } forEach GVAR(rxAreas);
        GVAR(rxAreaList) ctrlAddEventHandler ["LBSelChanged", QUOTE(_this call FUNC(onAreaLBChange))];
        GVAR(rxAreaList) lbSetCurSel 0;
        GVAR(rxAreaList) ctrlCommit 0;
        
        CTRL(GVAR(addRxAreaButton), "RscButton");
        GVAR(addRxAreaButton) ctrlSetPosition [0.355, 0.055*11, 0.095, 0.045];
        GVAR(addRxAreaButton) ctrlSetBackgroundColor [0,0,0,0.25];
        GVAR(addRxAreaButton) ctrlSetText "Delete";
        GVAR(addRxAreaButton) ctrlSetEventHandler ["MouseButtonUp", QUOTE(_this call FUNC(deleteRxArea))];
        GVAR(addRxAreaButton) ctrlCommit 0;
        
        CTRL(GVAR(addRxAreaButton), "RscButton");
        GVAR(addRxAreaButton) ctrlSetPosition [0.05, 0.055*12.5, 0.4, 0.045];
        GVAR(addRxAreaButton) ctrlSetBackgroundColor [0,0,0,0.25];
        GVAR(addRxAreaButton) ctrlSetText "Process";
        GVAR(addRxAreaButton) ctrlSetEventHandler ["MouseButtonUp", QUOTE(_this call FUNC(doProcess))];
        GVAR(addRxAreaButton) ctrlCommit 0;
        
    };
};

DFUNC(deleteRxArea) = {
    with uiNamespace do {
        _index = lbCurSel GVAR(rxAreaList);
        _areaIndex = parseNumber (GVAR(rxAreaList) lbData _index);
        GVAR(rxAreaList) lbDelete _index;
        _deleted = GVAR(rxAreas) deleteAt _areaIndex;
        deleteMarker (_deleted select 1);
    };
};

DFUNC(open) = {
    if(isNil QGVAR(startDrawing)) then {
        with uiNamespace do {
            GVAR(mapDisplay) = (findDisplay 12);
            _mapCtrl = (GVAR(mapDisplay) displayCtrl 51);
            _mapCtrl ctrlAddEventHandler ["MouseButtonDown", QUOTE(_this call FUNC(onMapClick))];
            _mapCtrl ctrlAddEventHandler ["draw", QUOTE(_this call DFUNC(drawSignalSamples))];
        };
        GVAR(startDrawing) = true;
        [{ _this call FUNC(drawSignalMaps); }, 0, []] call cba_fnc_addPerFrameHandler;
    };
    [] call FUNC(drawMenu);
};
with uiNamespace do {
    GVAR(completedAreas) = [];
    GVAR(currentArgs) = [];
    GVAR(rxAreas) = [];
    GVAR(areaProgress) = 0;
    GVAR(txPosition) = nil;
};

ADDON = true;