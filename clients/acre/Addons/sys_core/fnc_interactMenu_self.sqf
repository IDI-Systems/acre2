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
 
#include "script_component.hpp"

TRACE_1("Enter", _this);

private ["_menuDef", "_target", "_params", "_menuName", "_menuRsc", "_menus", "_aliveStatus"];


_aliveStatus = [] call FUNC(getAlive);
if(_aliveStatus == 0) exitWith { };

// go to the dead menu if they are in spectator mode.
if(ACRE_IS_SPECTATOR) exitWith {
    _this call FUNC(interactMenu_deadMenu)
};
LOG("HIT?!");

// _this==[_target, _menuNameOrParams]
_target = _this select 0;
_params = _this select 1;

_menuName = "";
_menuRsc = "popup";

if (typeName _params == typeName []) then {
    if (count _params < 1) exitWith {diag_log format["Error: Invalid params: %1, %2", _this, __FILE__];};
    _menuName = _params select 0;
    _menuRsc = if (count _params > 1) then {_params select 1} else {_menuRsc};
} else {
    _menuName = _params;
};
//-----------------------------------------------------------------------------

_menus = [
    [
        ["main", "ACRE Menu", _menuRsc],
        [
            ["Lower Headset",
                { [] call FUNC(toggleHeadset) },
                "", "", "", -1,
                1, (GVAR(lowered) == 0 && ( (count ([] call EFUNC(sys_data,getPlayerRadioList))) > 0 ))],
            ["Raise Headset",
                { [] call FUNC(toggleHeadset) },
                "", "", "", -1,
                1, (GVAR(lowered) == 1 && ( (count ([] call EFUNC(sys_data,getPlayerRadioList))) > 0 ))]
        ]
    ]
];


//-----------------------------------------------------------------------------
_menuDef = [];
{
    if (_x select 0 select 0 == _menuName) exitWith {_menuDef = _x};
} forEach _menus;

if (count _menuDef == 0) then {
    hintC format ["Error: Menu not found: %1\n%2\n%3", str _menuName, if (_menuName == "") then {_this}else{""}, __FILE__];
    diag_log format ["Error: Menu not found: %1, %2, %3", str _menuName, _this, __FILE__];
};

_menuDef // return value
