#define COMPONENT sys_intercom
#define COMPONENT_BEAUTIFIED Vehicle Intercom
#include "\idi\acre\addons\main\script_mod.hpp"

// #define DRAW_INFANTRYPHONE_INFO // Draws infantry phone position
// #define DRAW_CURSORPOS_INFO // Draws cursor position and intersection with object
// #define DEBUG_VEHICLE_INFO // Uses a long dummy vehicle info line
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
#include "script_acre_rackIntercom_defines.hpp"
#include "script_acre_intercom_defines.hpp"

#define PHONE_MAXDISTANCE_DEFAULT 10
#define PHONE_MAXDISTANCE_HULL    3

// Infantry phone default configuration (fnc_infantryPhoneRingingPFH.sqf)
#define INFANTRY_PHONE_SOUNDFILE QPATHTO_R(sounds\Cellphone_Ring.wss);
#define INFANTRY_PHONE_SOUND_PFH_DURATION 2.25
#define INFANTRY_PHONE_VOLUME 3.16
#define INFANTRY_PHONE_SOUNDPITCH 1
#define INFANTRY_PHONE_MAX_DISTANCE 75

#define ACTION_INTERCOM_PTT 0
#define ACTION_BROADCAST   1
#define INTERCOM_ACCENT_VOLUME_FACTOR   0.8
#define MINIMUM_INTERCOM_ACCENT_VOLUME  0.1

#define MAIN_DISPLAY (findDisplay 31337)

// VIC3
#define VIC3FFCS_WORK_KNOB_POSITIONS     6
#define VIC3FFCS_MONITOR_KNOB_POSITIONS  7

#define INTERCOM_STATIONSTATUS_INTERCOMKNOB       "intercomKnob"
#define INTERCOM_STATIONSTATUS_MONITORKNOB        "monitorKnob"
#define INTERCOM_STATIONSTATUS_VOLUMEKNOB         "volumeKnob"
#define INTERCOM_STATIONSTATUS_WORKKNOB           "workKnob"
