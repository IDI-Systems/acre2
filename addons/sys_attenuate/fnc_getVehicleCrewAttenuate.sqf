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

private["_attenuateClass", "_ret", "_unitRet", "_selfRet", "_unitPositionClass", "_selfPositionClass", "_unitTurnedOut", "_selfTurnedOut"];
params["_vehicle", "_self", "_unit"];

_ret = 0;

_attenuateClass = [_vehicle] call FUNC(getVehicleAttenuateClass);
_selfPositionClass = [_self, _vehicle] call FUNC(getVehiclePositionClass);
_selfTurnedOut = isTurnedOut _self;

_unitTurnedOut = false;
_unitPositionClass = _unit;
if(IS_OBJECT(_unit)) then {
    _unitPositionClass = [_unit, _vehicle] call FUNC(getVehiclePositionClass);
    _unitTurnedOut = isTurnedOut _unitTurnedOut;
};

// Get this value based on whether we are turned out or inside
_selfRet = 0;
_unitRet = 0;



if(!(isNil "_selfTurnedOut")) then { 
    // load up the attenuation class from the main root
    if(_selfTurnedOut) then {
        _selfRet = getNumber ( configFile >> "CfgAcreAttenuation" >> _attenuateClass >> _selfPositionClass >> "turnedout" >> _unitPositionClass >> "attenuationValue");
    } else {
        _selfRet = getNumber ( configFile >> "CfgAcreAttenuation" >> _attenuateClass >> _selfPositionClass >> "inside" >> _unitPositionClass >> "attenuationValue");
    };
} else {
    _selfRet = getNumber ( configFile >> "CfgAcreAttenuation" >> _attenuateClass >> _selfPositionClass >> "inside" >> _unitPositionClass >> "attenuationValue");
};
if(!(isNil "_unitTurnedOut")) then { 
    // load up the attenuation class from the main root
    if(_selfTurnedOut) then {
        _unitRet = getNumber ( configFile >> "CfgAcreAttenuation" >> _attenuateClass >> _unitPositionClass >> "turnedout" >> _selfPositionClass >> "attenuationValue");
    } else {
        _unitRet = getNumber ( configFile >> "CfgAcreAttenuation" >> _attenuateClass >> _unitPositionClass >> "inside" >> _selfPositionClass >> "attenuationValue");
    };
} else {
    _unitRet = getNumber ( configFile >> "CfgAcreAttenuation" >> _attenuateClass >> _unitPositionClass >> "inside" >> _selfPositionClass >> "attenuationValue");
};
_ret = _selfRet + _unitRet;


TRACE_1("ret", _ret);

if(isNil "_ret") then {
    _ret = 0;
};

_ret