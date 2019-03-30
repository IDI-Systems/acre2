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

typedef enum {
    acre_result_ok,
    acre_result_invalidPlayer = 0x00000100,
    acre_result_notFound = 0x00FF0000,
    acre_result_invalidPacket = 0xFF000000,
    acre_result_notImplemented = 0xFFFFFFF0,
    acre_result_error = 0xFFFFFFFF
} acre_result_t;

typedef enum {
    acre_state_running = 1,
    acre_state_initializing,
    acre_state_stopping,
    acre_state_starting,
    acre_state_ready,
    acre_state_stopped = 0xFFFFFFFF
} acre_state_t;

typedef enum {
    acre_silence_off,
    acre_silence_always,
    acre_silence_alwaysAdmin,
    acre_silence_ingame,
    acre_silence_ingameAdmin
} acre_silence_t;

typedef enum {
    acre_speaking_direct,
    acre_speaking_radio,
    acre_speaking_unknown,
    acre_speaking_intercom,
    acre_speaking_spectate
} acre_speaking_t;

typedef enum {
    acre_curveModel_original,
    acre_curveModel_amplitude,
    acre_curveModel_selectableA,
    acre_curveModel_selectableB
} acre_curveModel_t;

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

typedef acre_result_t (*ACRE_RPCFUNCTION)(IServer *, IMessage *);



typedef acre_result_t (*ACRE_CALLBACK_TALKING)(CPlayer *);
*/

