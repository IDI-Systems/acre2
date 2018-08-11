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

    ACRE_RESULT initialize(IClient *const ac_client, IServer *const ac_externalServer, const std::string ac_fromPipeName, const std::string ac_toPipeName);
    ACRE_RESULT initialize(IClient *const ac_client, IServer *const ac_externalServer, const std::string ac_fromPipeName, const std::string ac_toPipeName, const std::string ac_loggingPath);

    ACRE_RESULT start(const ACRE_ID ac_id);
    ACRE_RESULT stop();

    ACRE_RESULT localStartSpeaking(const ACRE_SPEAKING_TYPE ac_speakingType);
    ACRE_RESULT localStartSpeaking(const ACRE_SPEAKING_TYPE ac_speakingType, const std::string &radioId);
    ACRE_RESULT localStopSpeaking( void );

    ACRE_RESULT remoteStartSpeaking(const ACRE_ID ac_remoteId, const int32_t ac_languageId, const std::string &ac_netId, const ACRE_SPEAKING_TYPE ac_speakingType, const std::string &ac_radioId, const ACRE_VOLUME ac_curveScale);
    ACRE_RESULT remoteStopSpeaking(const ACRE_ID ac_remoteId);

    std::map<ACRE_ID, CPlayer *> speakingList;

    virtual __inline void setSoundEngine(CSoundEngine *const ac_value) { this->m_soundEngine = ac_value; }
    virtual __inline CSoundEngine* getSoundEngine() const { return this->m_soundEngine; }

    virtual __inline void setRpcEngine(CRpcEngine *const ac_value) { this->m_rpcEngine = ac_value; }
    virtual __inline CRpcEngine* getRpcEngine() const { return this->m_rpcEngine; }

    virtual __inline void setExternalServer(IServer *const ac_value) { this->m_externalServer = ac_value; }
    virtual __inline IServer* getExternalServer() const { return this->m_externalServer; }

    virtual __inline void setGameServer(IServer *const ac_value) { this->m_gameServer = ac_value; }
    virtual __inline IServer* getGameServer() const { return this->m_gameServer; }

    virtual __inline void setSoundPlayback(CSoundPlayback *const ac_value) { this->m_soundPlayback = ac_value; }
    virtual __inline CSoundPlayback* getSoundPlayback() const { return this->m_soundPlayback; }

    virtual __inline void setSoundSystemOverride(const bool ac_value) { this->m_soundSystemOverride = ac_value; }
    virtual __inline bool getSoundSystemOverride() const { return this->m_soundSystemOverride; }

    virtual __inline void setState(const ACRE_STATE ac_value) { this->m_state = ac_value; }
    virtual __inline ACRE_STATE getState() const { return this->m_state; }

    virtual __inline void setSelf(CSelf *const ac_value) { this->m_self = ac_value; }
    virtual __inline CSelf* getSelf() const { return this->m_self; }

    virtual __inline void setClient(IClient *const ac_value) { this->m_client = ac_value; }
    virtual __inline IClient* getClient() const { return this->m_client; }

protected:
    CSoundEngine *m_soundEngine;
    CRpcEngine *m_rpcEngine;
    IServer *m_externalServer;
    IServer *m_gameServer;
    CSoundPlayback *m_soundPlayback;
    bool m_soundSystemOverride;
    ACRE_STATE m_state;
    CSelf *m_self;
    IClient *m_client;
};
