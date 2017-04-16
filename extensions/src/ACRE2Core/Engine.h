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



    ACRE_RESULT initialize(IClient * client, IServer * externalServer, std::string fromPipeName, std::string toPipeName);
    ACRE_RESULT initialize(IClient * client, IServer * externalServer, std::string fromPipeName, std::string toPipeName, std::string loggingPath);

    ACRE_RESULT start(ACRE_ID id);
    ACRE_RESULT stop();

    ACRE_RESULT localStartSpeaking(ACRE_SPEAKING_TYPE speakingType);
    ACRE_RESULT localStartSpeaking(ACRE_SPEAKING_TYPE speakingType, std::string radioId);
    ACRE_RESULT localStopSpeaking( void );

    ACRE_RESULT remoteStartSpeaking(ACRE_ID remoteId, int languageId, std::string netId, ACRE_SPEAKING_TYPE speakingType, std::string radioId, ACRE_VOLUME curveScale);
    ACRE_RESULT remoteStopSpeaking(ACRE_ID remoteId);

    std::map<ACRE_ID, CPlayer *> speakingList;

    DECLARE_MEMBER(CSoundEngine *, SoundEngine);
    DECLARE_MEMBER(CRpcEngine *, RpcEngine);
    DECLARE_MEMBER(IServer *, ExternalServer);
    DECLARE_MEMBER(IServer *, GameServer);
    //DECLARE_MEMBER(CKeyHandlerEngine *, KeyHandlerEngine);
    DECLARE_MEMBER(CSoundPlayback *, SoundPlayback);

    DECLARE_MEMBER(bool, SoundSystemOverride);

    DECLARE_MEMBER(ACRE_STATE, State);

    DECLARE_MEMBER(CSelf *, Self);

    DECLARE_MEMBER(IClient *, Client);



};
