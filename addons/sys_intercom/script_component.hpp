#define COMPONENT sys_intercom
#define COMPONENT_BEAUTIFIED Vehicle Intercom
#include "\idi\acre\addons\main\script_mod.hpp"

// #define DRAW_INFANTRYPHONE_INFO
// #define DRAW_CURSORPOS_INFO
// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_SYS_INTERCOM
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_SYS_INTERCOM
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_INTERCOM
#endif

#include "\idi\acre\addons\main\script_macros.hpp"

#define PHONE_MAXDISTANCE_DEFAULT 10 // @todo replace with ace_interaction_fnc_getInteractionDistance when ACE 3.9.1 releases
#define PHONE_MAXDISTANCE_HULL 3

#define NO_INTERCOM 0
#define CREW_INTERCOM 1
#define PASSENGER_INTERCOM 2

// Infantry phone default configuration (fnc_infantryPhoneRingingPFH.sqf)
#define INFANTRY_PHONE_SOUNDFILE QPATHTO_R(sounds\Cellphone_Ring.wss);
#define INFANTRY_PHONE_VOLUME 3.16
#define INFANTRY_PHONE_SOUNDPITCH 1
#define INFANTRY_PHONE_MAX_DISTANCE 75

#define CREW_STRING "str_a3_rscdisplaygarage_tab_crew"
