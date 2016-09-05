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

private["_attenuateClass", "_ret", "_parent", "_positionClass", "_playerTurnedOut"];
params["_vehicle", "_unit"];

TRACE_2("Getting outside attenuation", _vehicle, _unit);

_ret = 0;
_playerTurnedOut = false;
_positionClass = _unit;
_attenuateClass = [_vehicle] call FUNC(getVehicleAttenuateClass);
if(IS_OBJECT(_unit)) then {
    _positionClass = [_unit, _vehicle] call FUNC(getVehiclePositionClass);

    _playerTurnedOut = isTurnedOut _unit;//[_unit] call FUNC(isTurnedOut);
    TRACE_3("turned out status", _attenuateClass, _positionClass, _playerTurnedOut);
};
if(!(isNil "_playerTurnedOut")) then {
    if(_playerTurnedOut) then {
        _ret = getNumber ( configFile >> "CfgAcreAttenuation" >>_attenuateClass >> _positionClass >> "turnedout" >> "attenuateOutside");
    } else {
        _ret = getNumber ( configFile >> "CfgAcreAttenuation" >>_attenuateClass >> _positionClass >> "inside" >> "attenuateOutside");
    };
} else {
    // load up the attenuation class from the main root
    _ret = getNumber ( configFile >> "CfgAcreAttenuation" >>_attenuateClass >> _positionClass >> "inside" >> "attenuateOutside");
};
TRACE_1("ret", _ret);

if(isNil "_ret") then {
    _ret = 0;
};

_ret