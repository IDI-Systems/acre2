#pragma once

#include "Singleton.h"
#include "SoundEngine.h"
#include "RpcEngine.h"
#include "Player.h"
#include "IServer.h"
#include "IClient.h"
#include "Self.h"
//#include "KeyHandlerEngine.h"
#include "SoundPlayback.h"

#include "Log.h"


#define ACRE_LOG_PATH "acre2.log"

class CEngine : public TSingleton<CEngine>, public CLockable {
public:
    CEngine(void) { g_Log = nullptr; };
    ~CEngine(void) { LOG("* Destroying logging engine."); delete g_Log; };

    

    acre::Result initialize(IClient * client, IServer * externalServer, std::string fromPipeName, std::string toPipeName);
    acre::Result initialize(IClient * client, IServer * externalServer, std::string fromPipeName, std::string toPipeName, std::string loggingPath);

    acre::Result start(const acre::id_t id);
    acre::Result stop();

    acre::Result localStartSpeaking(const acre::Speaking speakingType);
    acre::Result localStartSpeaking(const acre::Speaking speakingType, const std::string radioId);
    acre::Result localStopSpeaking( void );

    acre::Result remoteStartSpeaking(const acre::id_t remoteId, const int32_t languageId, const std::string netId, const acre::Speaking speakingType, const std::string radioId, const acre::volume_t curveScale);
    acre::Result remoteStopSpeaking(const acre::id_t remoteId);

    std::map<acre::id_t, CPlayer *> speakingList;

    DECLARE_MEMBER(CSoundEngine *, SoundEngine);
    DECLARE_MEMBER(CRpcEngine *, RpcEngine);
    DECLARE_MEMBER(IServer *, ExternalServer);
    DECLARE_MEMBER(IServer *, GameServer);
    //DECLARE_MEMBER(CKeyHandlerEngine *, KeyHandlerEngine);
    DECLARE_MEMBER(CSoundPlayback *, SoundPlayback);

    DECLARE_MEMBER(BOOL, SoundSystemOverride);

    DECLARE_MEMBER(acre::State, State);
    
    DECLARE_MEMBER(CSelf *, Self);

    DECLARE_MEMBER(IClient *, Client);

    
    
};
