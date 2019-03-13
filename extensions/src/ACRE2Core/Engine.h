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

    

    acre_result_t initialize(IClient * client, IServer * externalServer, std::string fromPipeName, std::string toPipeName);
    acre_result_t initialize(IClient * client, IServer * externalServer, std::string fromPipeName, std::string toPipeName, std::string loggingPath);

    acre_result_t start(acre_id_t id);
    acre_result_t stop();

    acre_result_t localStartSpeaking(acre_speaking_t speakingType);
    acre_result_t localStartSpeaking(acre_speaking_t speakingType, std::string radioId);
    acre_result_t localStopSpeaking( void );

    acre_result_t remoteStartSpeaking(acre_id_t remoteId, int languageId, std::string netId, acre_speaking_t speakingType, std::string radioId, acre_volume_t curveScale);
    acre_result_t remoteStopSpeaking(acre_id_t remoteId);

    std::map<acre_id_t, CPlayer *> speakingList;

    DECLARE_MEMBER(CSoundEngine *, SoundEngine);
    DECLARE_MEMBER(CRpcEngine *, RpcEngine);
    DECLARE_MEMBER(IServer *, ExternalServer);
    DECLARE_MEMBER(IServer *, GameServer);
    //DECLARE_MEMBER(CKeyHandlerEngine *, KeyHandlerEngine);
    DECLARE_MEMBER(CSoundPlayback *, SoundPlayback);

    DECLARE_MEMBER(BOOL, SoundSystemOverride);

    DECLARE_MEMBER(acre_state_t, State);
    
    DECLARE_MEMBER(CSelf *, Self);

    DECLARE_MEMBER(IClient *, Client);

    
    
};