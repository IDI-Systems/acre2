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

// this function gets the attenuation value relative *from* the provided unit *to* the acre_player
// e.g. what the local acre_player attenuation scale value is.
// returns 0-1
private["_temp"];
params["_unitVehicle","_positionName"];

TRACE_1("enter", _this);

private _attenuate = 0;

// now, one of us is in a vehicle. We need to search both and see what our outide attenuation values are
// aproppriately if we are in a different vehicle
private _playerVehicle = vehicle acre_player;

if( !(_unitVehicle != _playerVehicle) ) then { // We are NOT in the same vehicle, use outide attenuation value
    if(_playerVehicle != acre_player) then { // wee are in a vehicle
        // get our own outside attenuation value
        _temp = [_playerVehicle, acre_player] call FUNC(getVehicleOutsideAttenuate);
        TRACE_2("", _attenuate, _temp);
        if(!(isTurnedOut acre_player)) then {
        // if(!([acre_player] call FUNC(isTurnedOut))) then {
            _attenuate = _attenuate + _temp;
        };
    };
    
    _temp = [_unitVehicle, _positionName] call FUNC(getVehicleOutsideAttenuate);
} else { // crew member attenuation code goes here
    _attenuate = [_unitVehicle, acre_player, _positionName] call FUNC(getVehicleCrewAttenuate);
};

TRACE_3("returning attenuate", _playerVehicle, _unitVehicle, _attenuate);

_attenuate