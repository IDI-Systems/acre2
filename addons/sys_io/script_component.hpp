#define COMPONENT sys_io
#include "\idi\clients\acre\addons\main\script_mod.hpp"

#ifdef DEBUG_ENABLED_SYS_IO
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_SYS_IO
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_IO
#endif

#include "\idi\clients\acre\addons\main\script_macros.hpp"

#define IO_STATE_IDL    0
#define IO_STATE_AWK    1
#define IO_STATE_RCV    2
#define IO_STATE_SND    3

#define PACKET_PREFIX   "3TA"
#define REMOTE_PACKET_PREFIX "AT3"
