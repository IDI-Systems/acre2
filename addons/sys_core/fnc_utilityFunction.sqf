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

DFUNC(utilityFuncPFH) = {
    ["setVoiceCurveModel", format["%1,%2,", ACRE_VOICE_CURVE_MODEL, ACRE_VOICE_CURVE_SCALE]] call EFUNC(sys_rpc,callRemoteProcedure);
    // acre_player sideChat format["ptt: %1", (GVAR(keyboardEvents) select 1)];
    {
        _key = HASH_GET(GVAR(keyboardEvents), _x);
        _kbData = format (["%1,%2,%3,%4,%5,"] + _key);
        // diag_log text format["Setting PTT Key: %1", _kbData];
        ["setPTTKeys", _kbData] call EFUNC(sys_rpc,callRemoteProcedure); 
    } forEach HASH_KEYS(GVAR(keyboardEvents));
};
ADDPFH(DFUNC(utilityFuncPFH), 5, []);

[] call FUNC(aliveMonitor);


GVAR(wrongVersionIncrease) = 0;
DFUNC(getPluginVersion) = {
    ["getPluginVersion", ","] call EFUNC(sys_rpc,callRemoteProcedure);
};
["getPluginVersion", ","] call EFUNC(sys_rpc,callRemoteProcedure);
ADDPFH(DFUNC(getPluginVersion), 15, []);