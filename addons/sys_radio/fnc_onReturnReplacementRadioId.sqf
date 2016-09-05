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
//#define DEBUG_MODE_FULL
#include "script_component.hpp"
LOG("HIT CALLBACK");

params["_player", "_class", "_replacementId"];

if(_player == acre_player) then {
    // Add a new radio based on the id we just got
    TRACE_1("Adding replacement radio", _class);
    TRACE_2("checking", _replacementId, GVAR(replacementRadioIdList));
    if(!(_replacementId in GVAR(replacementRadioIdList))) exitWith {
        LOG("WTF?!?!?!");
    };
    // copy the oblix info
    // @TODO copy radio data to new id
    if(!(isNil "_oldOblix")) then {
        // @TODO copy radio data to new id
        // order of operations..we must always add the weapon LAST.
        [acre_player, _class] call EFUNC(lib,addGear);
        if((count GVAR(currentRadioList)) == 0) then {
            [_class] call EFUNC(sys_radio,setActiveRadio);
        };
        GVAR(pendingClaim) = GVAR(pendingClaim) - 1;
    } else {
        [_player, _class] call FUNC(onReturnRadioId);
    };
    
    REM(GVAR(replacementRadioIdList), _replacementId);
};
