#pragma once

#include <cstdint>

class CPlayer;
class IServer;
class IMessage;
class IRpcFunction;
class IServer;

/*
 * Basic type definitions
 */
typedef float float32_t;
typedef double float64_t;

/*
 * ACRE type definitions
 */

typedef uint32_t acre_id_t;
typedef float32_t acre_volume_t;

enum class AcreResult : uint32_t {
    ok,
    invalidPlayer = 0x00000100,
    notFound = 0x00FF0000,
    invalidPacket = 0xFF000000,
    notImplemented = 0xFFFFFFF0,
    error = 0xFFFFFFFF
};

enum class AcreState : uint32_t {
    running = 1,
    initializing,
    stopping,
    starting,
    ready,
    stopped = 0xFFFFFFFF
};

enum class AcreSilence {
    off,
    always,
    alwaysAdmin,
    ingame,
    ingameAdmin
};

enum class AcreSpeaking {
    direct,
    radio,
    unknown,
    intercom,
    spectate
};

enum class AcreCurveModel {
    original,
    amplitude,
    selectableA,
    selectableB
};

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

typedef AcreResult (*ACRE_RPCFUNCTION)(IServer *, IMessage *);



typedef AcreResult (*ACRE_CALLBACK_TALKING)(CPlayer *);
*/

