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
using float32_t = float;
using float64_t = double;

/*
 * ACRE type definitions
 */
namespace acre {
    using id_t = uint32_t;
    using volume_t = float32_t;

    enum class Result : uint32_t {
        ok,
        invalidPlayer = 0x00000100,
        notFound = 0x00FF0000,
        invalidPacket = 0xFF000000,
        notImplemented = 0xFFFFFFF0,
        error = 0xFFFFFFFF
    };

    enum class State : uint32_t {
        running = 1,
        initializing,
        stopping,
        starting,
        ready,
        stopped = 0xFFFFFFFF
    };

    enum class Silence : uint8_t {
        off,
        always,
        alwaysAdmin,
        ingame,
        ingameAdmin
    };

    enum class Speaking : uint8_t {
        direct,
        radio,
        unknown,
        intercom,
        spectate
    };

    enum class CurveModel : uint8_t {
        original,
        amplitude,
        selectableA,
        selectableB
    };
} /* namespace acre */

typedef struct ACRE_RPCDATA {
    IRpcFunction *function;
    IServer *server;
    IMessage *message;
    ACRE_RPCDATA(IRpcFunction *func, IServer *serv, IMessage *msg) : function(func), server(serv), message(msg) {}
    ACRE_RPCDATA() {function = nullptr; server = nullptr; message= nullptr; }
} ACRE_RPCDATA, *PACRE_RPCDATA;

/*
typedef BYTE ACRE_KEY;

// struct includes
#include "ACRE_VECTOR.h"
#include "ACRE_ANTENNA.h"
#include "ACRE_RADIO.h"
#include "ACRE_KEYBIND.h"
#include "ACRE_ADDR.h"

typedef acre::Result (*ACRE_RPCFUNCTION)(IServer *, IMessage *);



typedef acre::Result (*ACRE_CALLBACK_TALKING)(CPlayer *);
*/

