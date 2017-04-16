#pragma once

#include <cstddef>

class CPlayer;
class IServer;
class IMessage;
class IRpcFunction;
class IServer;
//
// Macro type definitions
//


#define ACRE_OK 0
#define ACRE_NOT_IMPL 0xFFFFFFF0
#define ACRE_ERROR 0xFFFFFFFF
#define ACRE_NOT_FOUND 0x00FF0000
#define ACRE_INVALID_PLAYER 0x00000100
#define ACRE_INVALID_PACKET 0xFF000000
typedef unsigned int ACRE_RESULT;

#define ACRE_STATE_RUNNING 1
#define ACRE_STATE_INITIALIZING 2
#define ACRE_STATE_STOPPING 3
#define ACRE_STATE_STARTING 4
#define ACRE_STATE_READY 5
#define ACRE_STATE_STOPPED 0xFFFFFFFF
typedef unsigned int ACRE_STATE;

#define ACRE_SILENCE_OFF 0
#define ACRE_SILENCE_ALWAYS 1
#define ACRE_SILENCE_ALWAYS_ADMIN 2
#define ACRE_SILENCE_INGAME 3
#define ACRE_SILENCE_INGAME_ADMIN 4
#define ACRE_SILENCE_OFF_STR "ACRE_SILENCE_OFF"
#define ACRE_SILENCE_ALWAYS_STR "ACRE_SILENCE_ALWAYS"
#define ACRE_SILENCE_ALWAYS_ADMIN_STR "ACRE_SILENCE_ALWAYS_ADMIN"
#define ACRE_SILENCE_INGAME_STR "ACRE_SILENCE_INGAME"
#define ACRE_SILENCE_INGAME_ADMIN_STR "ACRE_SILENCE_INGAME_ADMIN"
typedef unsigned int ACRE_SILENCE;

typedef unsigned int ACRE_ID;

typedef unsigned int ACRE_FREQUENCY;
typedef unsigned int ACRE_POWER;
typedef float ACRE_VOLUME;

#define ACRE_SQUAWK_ON  0x00000001
#define ACRE_SQUAWK_OFF 0x00000002
typedef unsigned int ACRE_SQUAWK;

#define ACRE_SPEAKING_SPECTATE 0x00000004
#define ACRE_SPEAKING_INTERCOM 0x00000003
#define ACRE_SPEAKING_UNKNOWN 0x00000002
#define ACRE_SPEAKING_RADIO 0x00000001
#define ACRE_SPEAKING_DIRECT 0x00000000
typedef unsigned int ACRE_SPEAKING_TYPE;

#define ACRE_CURVE_MODEL_ORIGINAL 0
#define ACRE_CURVE_MODEL_AMPLITUDE 1
#define ACRE_CURVE_MODEL_SELECTABLE_A 2
#define ACRE_CURVE_MODEL_SELECTABLE_B 3
typedef unsigned int ACRE_CURVE_MODEL;

typedef struct ACRE_RPCDATA {
    IRpcFunction *function;
    IServer *server;
    IMessage *message;
    ACRE_RPCDATA(IRpcFunction *func, IServer *serv, IMessage *msg) { function=func;server=serv;message=msg;}
    ACRE_RPCDATA() {function=NULL;server=NULL;message=NULL; }
} ACRE_RPCDATA, *PACRE_RPCDATA;

/*
typedef BYTE ACRE_KEY;

// struct includes
#include "ACRE_VECTOR.h"
#include "ACRE_ANTENNA.h"
#include "ACRE_RADIO.h"
#include "ACRE_KEYBIND.h"
#include "ACRE_ADDR.h"

typedef ACRE_RESULT (*ACRE_RPCFUNCTION)(IServer *, IMessage *);



typedef ACRE_RESULT (*ACRE_CALLBACK_TALKING)(CPlayer *);
*/
