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

if(!isServer) exitWith {};

["acre_checkServerGearDesync", { _this call FUNC(checkServerGearDesync) }] call CALLSTACK(LIB_fnc_addEventHandler);

LOG("Starting radio id handler events");
["acre_getRadioId", { _this call FUNC(onGetRadioId) }] call CALLSTACK(LIB_fnc_addEventHandler);
["acre_acknowledgeId", { _this call FUNC(acknowledgeId) }] call CALLSTACK(LIB_fnc_addEventHandler);
[QGVAR(invalidGarbageCollect), { _this call FUNC(invalidGarbageCollect); }] call CALLSTACK(LIB_fnc_addEventHandler);

ADDPFH(DFUNC(masterIdTracker), 1, []);

ACRE_SERVER_INIT = true;

[QUOTE(GVAR(onSetSpector)), { _this call FUNC(setSpectator) }] call CALLSTACK(LIB_fnc_addEventHandler);
[QUOTE(GVAR(remoteDebugMsg)), { _this call FUNC(remoteDebugMsg) }] call CALLSTACK(LIB_fnc_addEventHandler);
[QUOTE(GVAR(doAddComponentCargo)), { _this call FUNC(doAddComponentCargo) }] call CALLSTACK(LIB_fnc_addEventHandler);

publicVariable "ACRE_SERVER_INIT";

ACRE_FULL_SERVER_VERSION = QUOTE(VERSION);

publicVariable "ACRE_FULL_SERVER_VERSION";


