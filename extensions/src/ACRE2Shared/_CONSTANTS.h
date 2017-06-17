#pragma once

#define ACRE_PIPE_NAME L"\\\\.\\pipe\\acre_comm_pipe"

#ifndef _REF_TRACE
#define _REF_TRACE 0
#endif
#define _LOCKING_ENABLED 1
#undef _LOCK_TRACE
//#define _LOCK_TRACE 1

#define NOFMOD 1

//#define _DEBUG_DIALOG 1
#undef _DEBUG_DIALOG


#define PIPE_TIMEOUT 5000
#define PIPE_PING_TIMEOUT 15000
#define PERSIST_VERSION_TIMER 5000
#define BUFSIZE 10240
#define MAX_SERVER_INSTANCES 1
#define INFODATA_BUFSIZE 128
#define DEAD_MIC_DELAY 5

#define REsetTIMEOUT 15

#include "version.h"

#define TS3_PLUGIN_API_VERSION 21

#define QUOTE_(x) #x
#define QUOTE(x) QUOTE_(x)

#define ACRE_NAME "ACRE2"
#define ACRE_TEAM "ACRE2 Team"
#define ACRE_URL "https://github.com/IDI-Systems/acre2"
#define ACRE_TEAM_URL QUOTE(ACRE_TEAM - ACRE_URL)
#define ACRE_DESC "This plugin handles realistic radio and direct communcations in Arma 3."
#define ACRE_COMPANY "IDI-Systems"
#define ACRE_COPYRIGHT "©2017 IDI-Systems"
#define ACRE_COMMAND_KEYWORD "ACRE2"

#define ACRE_VERSION QUOTE(ACRE_VERSION_MAJOR.ACRE_VERSION_MINOR.ACRE_VERSION_SUBMINOR.ACRE_VERSION_BUILD)
#define ACRE_VERSION_METADATA "Version: "QUOTE(ACRE_VERSION_MAJOR)"."QUOTE(ACRE_VERSION_MINOR)"."QUOTE(ACRE_VERSION_SUBMINOR)"."QUOTE(ACRE_VERSION_BUILD)

#define ACRE_CURVE_MODEL_ORIGINAL 0
#define ACRE_CURVE_MODEL_AMPLITUDE 1
#define ACRE_CURVE_MODEL_SELECTABLE_A 2
#define ACRE_CURVE_MODEL_SELECTABLE_B 3




/// warning disablers
#pragma warning (disable : 4100)


// config flag strings

