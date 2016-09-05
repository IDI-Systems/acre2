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

/*
 *  This function is called when a radio transmission is closed.
 *  It handles the radios behavior depending of the remaining
 *  transmissions. 
 *
 *  Type of Event:
 *      Transmission
 *  Event:
 *      handleEndTransmission
 *  Event raised by:
 *      - Remote Start Speaking Event
 *
 *  Parsed parameters:
 *      0:  Radio ID
 *      1:  Event (-> "handleBeginTransmission")
 *      2:  Eventdata
 *          2.0:    Radio ID of transmitting radio
 *      3:  Radiodata  
 *      4:  Remote Call (-> false)
 *
 *  Returned parameters:
 *      true
*/

private ["_beeped", "_currentTransmissions", "_volume"];
params ["_radioId", "_eventKind", "_eventData"];

_eventData params["_txId"];
_currentTransmissions = SCRATCH_GET(_radioId, "currentTransmissions");
_currentTransmissions = _currentTransmissions - [_txId];

if((count _currentTransmissions) == 0) then {
    _beeped = SCRATCH_GET(_radioId, "hasBeeped");
    _pttDown = SCRATCH_GET_DEF(_radioId, "PTTDown", false);
    if(!_pttDown) then {
        if(!isNil "_beeped" && {_beeped}) then {
            _volume = [_radioId, "getVolume"] call EFUNC(sys_data,dataEvent);
            [_radioId, "Acre_GenericClickOff", [0,0,0], [0,1,0], _volume] call EFUNC(sys_radio,playRadioSound);
        };
    };
    SCRATCH_SET(_radioId, "hasBeeped", false);
};
SCRATCH_SET(_radioId, "cachedTransmissions", false);
true;