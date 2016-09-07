/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
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
