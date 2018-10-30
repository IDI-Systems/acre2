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

    ACRE_RESULT initialize(IClient *const client, IServer *const externalServer, const std::string fromPipeName, const std::string toPipeName);
    ACRE_RESULT initialize(IClient *const client, IServer *const externalServer, const std::string fromPipeName, const std::string toPipeName, const std::string loggingPath);

    ACRE_RESULT start(const ACRE_ID id);
    ACRE_RESULT stop();

    ACRE_RESULT localStartSpeaking(const ACRE_SPEAKING_TYPE speakingType);
    ACRE_RESULT localStartSpeaking(const ACRE_SPEAKING_TYPE speakingType, const std::string &radioId);
    ACRE_RESULT localStopSpeaking( void );

    ACRE_RESULT remoteStartSpeaking(const ACRE_ID remoteId, const int32_t languageId, const std::string &netId, const ACRE_SPEAKING_TYPE speakingType, const std::string &radioId, const ACRE_VOLUME curveScale);
    ACRE_RESULT remoteStopSpeaking(const ACRE_ID remoteId);

    std::map<ACRE_ID, CPlayer *> speakingList;

    virtual __inline void setSoundEngine(CSoundEngine *const value) { this->m_soundEngine = value; }
    virtual __inline CSoundEngine* getSoundEngine() const { return this->m_soundEngine; }

    virtual __inline void setRpcEngine(CRpcEngine *const value) { this->m_rpcEngine = value; }
    virtual __inline CRpcEngine* getRpcEngine() const { return this->m_rpcEngine; }

    virtual __inline void setExternalServer(IServer *const value) { this->m_externalServer = value; }
    virtual __inline IServer* getExternalServer() const { return this->m_externalServer; }

    virtual __inline void setGameServer(IServer *const value) { this->m_gameServer = value; }
    virtual __inline IServer* getGameServer() const { return this->m_gameServer; }

    virtual __inline void setSoundPlayback(CSoundPlayback *const value) { this->m_soundPlayback = value; }
    virtual __inline CSoundPlayback* getSoundPlayback() const { return this->m_soundPlayback; }

    virtual __inline void setSoundSystemOverride(const bool value) { this->m_soundSystemOverride = value; }
    virtual __inline bool getSoundSystemOverride() const { return this->m_soundSystemOverride; }

    virtual __inline void setState(const ACRE_STATE value) { this->m_state = value; }
    virtual __inline ACRE_STATE getState() const { return this->m_state; }

    virtual __inline void setSelf(CSelf *const value) { this->m_self = value; }
    virtual __inline CSelf* getSelf() const { return this->m_self; }

    virtual __inline void setClient(IClient *const value) { this->m_client = value; }
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
