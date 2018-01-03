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
#include "script_acre_rackIntercom_defines.hpp"

#define PHONE_MAXDISTANCE_DEFAULT 10 // @todo replace with ace_interaction_fnc_getInteractionDistance when ACE 3.9.1 releases
#define PHONE_MAXDISTANCE_HULL    3

#define ALL_INTERCOMS          -1
#define INTERCOM_DISCONNECTED   0
#define INTERCOM_RX_ONLY        1
#define INTERCOM_TX_ONLY        2
#define INTERCOM_RX_AND_TX      3
#define INTERCOM_DEFAULT_VOLUME 1

#define STATION_INTERCOM_CONFIGURATION_INDEX  0
#define STATION_INTERCOM_UNIT_INDEX           1
#define STATION_RACKS_CONFIGURATION_INDEX     2

#define INTERCOM_STATIONSTATUS_HASINTERCOMACCESS  0
#define INTERCOM_STATIONSTATUS_CONNECTION         1
#define INTERCOM_STATIONSTATUS_VOLUME             2
#define INTERCOM_STATIONSTATUS_LIMITED            3
#define INTERCOM_STATIONSTATUS_TURNEDOUTALLOWED   4
#define INTERCOM_STATIONSTATUS_FORCEDCONNECTION   5
#define INTERCOM_STATIONSTATUS_VOICEACTIVATION    6
#define INTERCOM_STATIONSTATUS_MASTERSTATION      7

// Infantry phone default configuration (fnc_infantryPhoneRingingPFH.sqf)
#define INFANTRY_PHONE_SOUNDFILE QPATHTO_R(sounds\Cellphone_Ring.wss);
#define INFANTRY_PHONE_SOUND_PFH_DURATION 2.25
#define INFANTRY_PHONE_VOLUME 3.16
#define INFANTRY_PHONE_SOUNDPITCH 1
#define INFANTRY_PHONE_MAX_DISTANCE 75
