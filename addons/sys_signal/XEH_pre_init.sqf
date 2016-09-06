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
PREP(getSignal);
PREP(handleSignalReturn);

DGVAR(showSignalHint) = false;
DGVAR(terrainScaling) = 1;
DGVAR(omnidirectionalRadios) = 0;

ACRE_SIGNAL_TEST_LINES = [];
ACRE_SIGNAL_TEST_ICONS = [];

FUNC(handleEndTransmission) = {
    _data = _this select 2;
    _transmitterClass = _data select 0;
    missionNamespace setVariable [_transmitterClass + "_running_count", 0];
    missionNamespace setVariable [_transmitterClass + "_best_signal", -992];
    missionNamespace setVariable [_transmitterClass + "_best_ant", ""];
    nil;
};

_drawLines = {
    {
        _line = _x;
        _line params ["_pos1","_pos",["_color",[1,0,0,1]]];
        
        if(_pos1 isEqualType objNull) then {
            _pos1 = getPosASL _pos1;
        };
        
        if(_pos2 isEqualType objNull) then {
            _pos2 = getPosASL _pos2;
        };
        
        drawLine3D [ASLtoATL _pos1, ASLtoATL _pos2, _color];
        
    } forEach ACRE_SIGNAL_TEST_LINES;
    {
        drawIcon3D ["\a3\ui_f\data\IGUI\Cfg\Cursors\selectover_ca.paa", [1,1,1,1], _x select 0, 0.75, 0.75, 0, format["%1", _x select 1], 0.5, 0.025, "TahomaB"];
    
    } forEach ACRE_SIGNAL_TEST_ICONS;
};

[_drawLines, 0, []] call CBA_fnc_addPerFrameHandler;

ADDON = true;
