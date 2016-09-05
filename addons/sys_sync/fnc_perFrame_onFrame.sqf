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
// #define DEBUG_MODE_FULL
//#define ACRE_PERFORMANCE_COUNTERS
#include "script_component.hpp"

GVAR(lastFrameRender) = COMPAT_diag_tickTime;

/*
 if(GVAR(lastCount) > (GVAR(fpsCount)-1)) then {
     hint "FUCK UP IN SEQUENCE!";
 };
GVAR(lastCount) = GVAR(fpsCount);
GVAR(fpsCount) = GVAR(fpsCount) + 1;
*/

#ifdef DEBUG_MODE_FULL
    _rstart = COMPAT_diag_tickTime;
#endif

if(alive GVAR(checkLogic) && (local player || isDedicated)) then {
    // diag_log text format["-------------- ACRE FRAME %1 --------------", diag_frameno];
    _beginFrame = COMPAT_diag_tickTime;
    {    
        private _handlerData = _x;
        if(!(isNil "_handlerData") && IS_ARRAY(_handlerData)) then {
            _handlerData params ["_func", "_delay", "_delta", "", "_args", "_handle"];

            if(COMPAT_diag_tickTime > _delta) then {
                #ifdef ACRE_PERFORMANCE_COUNTERS
                    private _beginStep = COMPAT_diag_tickTime;
                #endif
            
                [_args, _handle] call _func;
                _delta = COMPAT_diag_tickTime + _delay;
                
#ifdef ACRE_PERFORMANCE_COUNTERS
                private _stepDelta = COMPAT_diag_tickTime - _beginStep;
                if(_stepDelta > ACRE_PERFORMANCE_COUNTERS_MAXHANDLETIME) then {
                    ACRE_PERFORMANCE_EXCESSIVE_STEP_TRACKER pushBack [_forEachIndex, COMPAT_diag_tickTime, _stepDelta, _delay, [(_handlerData select 4), (_handlerData select 5)]];
                    ACRE_PERFORMANCE_STEP_TRACKER pushBack [_forEachIndex, COMPAT_diag_tickTime, _stepDelta, _delay, [(_handlerData select 4), (_handlerData select 5)]];
                } else {
                    ACRE_PERFORMANCE_STEP_TRACKER pushBack [_forEachIndex, COMPAT_diag_tickTime, _stepDelta, _delay, [(_handlerData select 4), (_handlerData select 5)]];
                };
#endif
                _handlerData set [2, _delta];
            };
        };
    } forEach GVAR(perFrameHandlerArray);
};


#ifdef ACRE_PERFORMANCE_COUNTERS
    private _frameDelta = COMPAT_diag_tickTime - GVAR(lastFrameRender);
    if(_frameDelta > ACRE_PERFORMANCE_COUNTERS_MAXFRAMETIME) then {
        ACRE_PERFORMANCE_EXCESSIVE_FRAME_TRACKER pushBack [COMPAT_diag_tickTime, _frameDelta];
    } else {
        ACRE_PERFORMANCE_FRAME_TRACKER pushBack [COMPAT_diag_tickTime, _frameDelta];
    };
#endif

#ifdef DEBUG_MODE_FULL
    _rend = COMPAT_diag_tickTime;
    if(isNil "ACRE_TEST_TIMING") then {
        ACRE_TEST_TIMING = [];
        ACRE_MAX_COMMAND_COUNT = 0;
        ACRE_MAX_TIME = 0;
    };

    ACRE_TEST_TIMING = [_rend-_rstart] + ACRE_TEST_TIMING;
    if((count ACRE_TEST_TIMING) > 100) then {
        ACRE_TEST_TIMING resize 100;
    };
    _mean = 0;
    {
        _mean = _mean + _x;
    } forEach ACRE_TEST_TIMING;
    _time = (_mean/100)*1000;
    ACRE_MAX_TIME = ACRE_MAX_TIME max _time;
    hintSilent format["t1: %1\n%2", _time, ACRE_MAX_TIME];
#endif
