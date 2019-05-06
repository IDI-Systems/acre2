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

    

    AcreResult initialize(IClient * client, IServer * externalServer, std::string fromPipeName, std::string toPipeName);
    AcreResult initialize(IClient * client, IServer * externalServer, std::string fromPipeName, std::string toPipeName, std::string loggingPath);

    AcreResult start(acre_id_t id);
    AcreResult stop();

    AcreResult localStartSpeaking(AcreSpeaking speakingType);
    AcreResult localStartSpeaking(AcreSpeaking speakingType, std::string radioId);
    AcreResult localStopSpeaking( void );

    AcreResult remoteStartSpeaking(acre_id_t remoteId, int languageId, std::string netId, AcreSpeaking speakingType, std::string radioId, acre_volume_t curveScale);
    AcreResult remoteStopSpeaking(acre_id_t remoteId);

    std::map<acre_id_t, CPlayer *> speakingList;

    DECLARE_MEMBER(CSoundEngine *, SoundEngine);
    DECLARE_MEMBER(CRpcEngine *, RpcEngine);
    DECLARE_MEMBER(IServer *, ExternalServer);
    DECLARE_MEMBER(IServer *, GameServer);
    //DECLARE_MEMBER(CKeyHandlerEngine *, KeyHandlerEngine);
    DECLARE_MEMBER(CSoundPlayback *, SoundPlayback);

    DECLARE_MEMBER(BOOL, SoundSystemOverride);

    DECLARE_MEMBER(AcreState, State);
    
    DECLARE_MEMBER(CSelf *, Self);

    DECLARE_MEMBER(IClient *, Client);

    
    
};