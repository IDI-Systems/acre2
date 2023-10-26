/**
FAST RECOMPILING
**/
// #define DISABLE_COMPILE_CACHE
// To Use: [] call ACRE_PREP_RECOMPILE;

#ifdef DISABLE_COMPILE_CACHE
    #define LINKFUNC(x) {_this call FUNC(x)}
    #define PREP_RECOMPILE_START    if (isNil "ACRE_PREP_RECOMPILE") then {ACRE_RECOMPILES = []; ACRE_PREP_RECOMPILE = {{call _x} forEach ACRE_RECOMPILES;}}; private _recomp = {
    #define PREP_RECOMPILE_END      }; call _recomp; ACRE_RECOMPILES pushBack _recomp;
#else
    #define LINKFUNC(x) FUNC(x)
    #define PREP_RECOMPILE_START ; /* disabled */
    #define PREP_RECOMPILE_END ; /* disabled */
#endif


/**
STACK TRACING
**/
//#define ENABLE_CALLSTACK
//#define ENABLE_PERFORMANCE_COUNTERS
//#define DEBUG_EVENTS
// To Use:
// - DUMPSTACK;
// - [] call acre_main_fnc_dumpCallStack;

#ifdef ENABLE_CALLSTACK
    #define CALLSTACK(function) {private ['_ret']; if (ACRE_IS_ERRORED) then { ['AUTO','AUTO'] call ACRE_DUMPSTACK_FNC; ACRE_IS_ERRORED = false; }; ACRE_IS_ERRORED = true; ACRE_STACK_TRACE set [ACRE_STACK_DEPTH, [diag_tickTime, __FILE__, __LINE__, ACRE_CURRENT_FUNCTION, 'ANON', _this]]; ACRE_STACK_DEPTH = ACRE_STACK_DEPTH + 1; ACRE_CURRENT_FUNCTION = 'ANON'; _ret = _this call ##function; ACRE_STACK_DEPTH = ACRE_STACK_DEPTH - 1; ACRE_IS_ERRORED = false; _ret;}
    #define CALLSTACK_NAMED(function, functionName) {private ['_ret']; if (ACRE_IS_ERRORED) then { ['AUTO','AUTO'] call ACRE_DUMPSTACK_FNC; ACRE_IS_ERRORED = false; }; ACRE_IS_ERRORED = true; ACRE_STACK_TRACE set [ACRE_STACK_DEPTH, [diag_tickTime, __FILE__, __LINE__, ACRE_CURRENT_FUNCTION, functionName, _this]]; ACRE_STACK_DEPTH = ACRE_STACK_DEPTH + 1; ACRE_CURRENT_FUNCTION = functionName; _ret = _this call ##function; ACRE_STACK_DEPTH = ACRE_STACK_DEPTH - 1; ACRE_IS_ERRORED = false; _ret;}
    #define DUMPSTACK ([__FILE__, __LINE__] call acre_main_fnc_dumpCallStack)

    #define FUNC(var1) {private ['_ret']; if (ACRE_IS_ERRORED) then { ['AUTO','AUTO'] call ACRE_DUMPSTACK_FNC; ACRE_IS_ERRORED = false; }; ACRE_IS_ERRORED = true; ACRE_STACK_TRACE set [ACRE_STACK_DEPTH, [diag_tickTime, __FILE__, __LINE__, ACRE_CURRENT_FUNCTION, 'TRIPLES(ADDON,fnc,var1)', _this]]; ACRE_STACK_DEPTH = ACRE_STACK_DEPTH + 1; ACRE_CURRENT_FUNCTION = 'TRIPLES(ADDON,fnc,var1)'; _ret = _this call TRIPLES(ADDON,fnc,var1); ACRE_STACK_DEPTH = ACRE_STACK_DEPTH - 1; ACRE_IS_ERRORED = false; _ret;}
    #define EFUNC(var1,var2) {private ['_ret']; if (ACRE_IS_ERRORED) then { ['AUTO','AUTO'] call ACRE_DUMPSTACK_FNC; ACRE_IS_ERRORED = false; }; ACRE_IS_ERRORED = true; ACRE_STACK_TRACE set [ACRE_STACK_DEPTH, [diag_tickTime, __FILE__, __LINE__, ACRE_CURRENT_FUNCTION, 'TRIPLES(DOUBLES(PREFIX,var1),fnc,var2)', _this]]; ACRE_STACK_DEPTH = ACRE_STACK_DEPTH + 1; ACRE_CURRENT_FUNCTION = 'TRIPLES(DOUBLES(PREFIX,var1),fnc,var2)'; _ret = _this call TRIPLES(DOUBLES(PREFIX,var1),fnc,var2); ACRE_STACK_DEPTH = ACRE_STACK_DEPTH - 1; ACRE_IS_ERRORED = false; _ret;}
#else
    #define CALLSTACK(function) function /* disabled */
    #define CALLSTACK_NAMED(function, functionName) function /* disabled */
    #define DUMPSTACK ; /* disabled */
#endif


/**
PERFORMANCE COUNTERS
**/
// #define ENABLE_PERFORMANCE_COUNTERS
// To Use:
// - DUMP_COUNTERS;
// - [] call acre_main_fnc_dumpPerformanceCounters;

#ifdef ENABLE_PERFORMANCE_COUNTERS
    #define CBA_fnc_addPerFrameHandler { _ret = [(_this select 0), (_this select 1), (_this select 2)] call CBA_fnc_addPerFrameHandler; if (isNil "ACRE_PFH") then { ACRE_PFH = []; }; ACRE_PFH pushBack [[_ret, __FILE__, __LINE__], [(_this select 0), (_this select 1), (_this select 2)]];  _ret }

    #define CREATE_COUNTER(x) if (isNil "ACRE_COUNTERS") then { ACRE_COUNTERS = []; }; GVAR(DOUBLES(x,counter)) = []; GVAR(DOUBLES(x,counter)) set [0, QGVAR(DOUBLES(x,counter))];  GVAR(DOUBLES(x,counter)) set [1, diag_tickTime]; ACRE_COUNTERS pushBack GVAR(DOUBLES(x,counter));
    #define BEGIN_COUNTER(x) if (isNil QGVAR(DOUBLES(x,counter))) then { CREATE_COUNTER(x) }; GVAR(DOUBLES(x,counter)) set [2, diag_tickTime];
    #define END_COUNTER(x) GVAR(DOUBLES(x,counter)) pushBack [(GVAR(DOUBLES(x,counter)) select 2), diag_tickTime];

    #define DUMP_COUNTERS ([__FILE__, __LINE__] call acre_main_fnc_dumpPerformanceCounters)
#else
    #define CREATE_COUNTER(x) ; /* disabled */
    #define BEGIN_COUNTER(x) ; /* disabled */
    #define END_COUNTER(x) ; /* disabled */
    #define DUMP_COUNTERS ; /* disabled */
#endif
