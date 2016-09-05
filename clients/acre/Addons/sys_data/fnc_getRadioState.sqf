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

params["_radio"];
private _stateCopy = nil;

if( (isNil QUOTE(acre_sys_server_obelisk)) ) exitWith {
    diag_log text "GET RADIO STATE acre_sys_data_radioLockObject OR acre_sys_server_obelisk IS NIL!";
    nil
};

// if we own the radio, we pull oblix state
// if we dont own it, we push a CBA event requesting they push latest state, then we get the latest oblix data via the reply event
TRACE_1("_radio",_radio);
private _state = acre_sys_server_obelisk getVariable _radio;
TRACE_2("", _radio, _state);
_stateCopy = nil;
if(!isNil "_state") then {
    if(IS_ARRAY(_state)) then {
        _stateCopy = [];
        _stateCopy = +_state;
    } else {
        _stateCopy = _state;
    };
};
_stateCopy

