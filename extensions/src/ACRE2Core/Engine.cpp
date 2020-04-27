#include "Engine.h"
#include "NamedPipeServer.h"
#include "AcreSettings.h"

#include "getClientID.h"
#include "setVoiceCurveModel.h"
#include "updateSpeakingData.h"
#include "ext_remoteStartSpeaking.h"
#include "ext_remoteStopSpeaking.h"
#include "ext_handleGetClientID.h"
#include "getPluginVersion.h"
#include "localMute.h"
#include "setMuted.h"
#include "startRadioSpeaking.h"
#include "stopRadioSpeaking.h"
#include "startIntercomSpeaking.h"
#include "stopIntercomSpeaking.h"
#include "startZeusSpeaking.h"
#include "stopZeusSpeaking.h"
#include "setPTTKeys.h"
#include "loadSound.h"
#include "playSound.h"
#include "setSoundSystemMasterOverride.h"
#include "ext_reset.h"
#include "ping.h"
#include "updateSelf.h"
#include "setSelectableVoiceCurve.h"
#include "setSetting.h"
#include "setTs3ChannelDetails.h"


acre::Result CEngine::initialize(IClient *client, IServer *externalServer, std::string fromPipeName, std::string toPipeName) {

    if (!g_Log) {
        g_Log = (Log *)new Log("acre2.log");
        LOG("* Logging engine initialized.");
    }
    LOG("Configuration Path: {%s\\acre2.ini}", client->getConfigFilePath().c_str());
    CAcreSettings::getInstance()->load(client->getConfigFilePath() + "\\acre2.ini");

    this->setClient(client);
    this->setExternalServer(externalServer);

    this->m_GameServer = new CNamedPipeServer(fromPipeName, toPipeName);
    this->m_SoundEngine = new CSoundEngine();
    this->m_RpcEngine = new CRpcEngine();
    //this->m_KeyHandlerEngine = new CKeyHandlerEngine();
    this->m_SoundPlayback = new CSoundPlayback();
    this->setSoundSystemOverride(false);

    this->setSelf(new CSelf());

    this->getRpcEngine()->addProcedure(new getClientID());
    this->getRpcEngine()->addProcedure(new setVoiceCurveModel());
    this->getRpcEngine()->addProcedure(new updateSpeakingData());
    this->getRpcEngine()->addProcedure(new ext_remoteStartSpeaking());
    this->getRpcEngine()->addProcedure(new ext_remoteStopSpeaking());
    this->getRpcEngine()->addProcedure(new ext_handleGetClientID());
    this->getRpcEngine()->addProcedure(new getPluginVersion());
    this->getRpcEngine()->addProcedure(new localMute());
    this->getRpcEngine()->addProcedure(new setMuted());
    this->getRpcEngine()->addProcedure(new startRadioSpeaking());
    this->getRpcEngine()->addProcedure(new stopRadioSpeaking());
    this->getRpcEngine()->addProcedure(new startIntercomSpeaking());
    this->getRpcEngine()->addProcedure(new stopIntercomSpeaking());
    this->getRpcEngine()->addProcedure(new startZeusSpeaking());
    this->getRpcEngine()->addProcedure(new stopZeusSpeaking());
    this->getRpcEngine()->addProcedure(new setPTTKeys());
    this->getRpcEngine()->addProcedure(new loadSound());
    this->getRpcEngine()->addProcedure(new playLoadedSound());
    this->getRpcEngine()->addProcedure(new setSoundSystemMasterOverride());
    this->getRpcEngine()->addProcedure(new ext_reset());
    this->getRpcEngine()->addProcedure(new ping());
    this->getRpcEngine()->addProcedure(new updateSelf());
    this->getRpcEngine()->addProcedure(new setSelectableVoiceCurve());
    this->getRpcEngine()->addProcedure(new setSetting());
    this->getRpcEngine()->addProcedure(new setTs3ChannelDetails());

    // Initialize the client, because it never was derp
    this->getClient()->initialize();

    return acre::Result::ok;
}

acre::Result CEngine::initialize(IClient *client, IServer *externalServer, std::string fromPipeName, std::string toPipeName, std::string loggingPath) {

    g_Log = (Log *)new Log(const_cast<char *>(loggingPath.c_str()));
    LOG("* Logging engine initialized.");

    return initialize(client, externalServer, fromPipeName, toPipeName);
}

acre::Result CEngine::start(const acre::id_t id) {
    if (this->getExternalServer()) {
        this->getExternalServer()->initialize();
    } else {
        return acre::Result::error;
    }

    if (this->getGameServer()) {
        this->getGameServer()->initialize();
    } else {
        return acre::Result::error;
    }
    /*
    if (this->getKeyHandlerEngine()) {
        this->getKeyHandlerEngine()->initialize();
    } else {
        return acre::Result::error;
    }
    */
    this->getClient()->unMuteAll();
    this->setState(acre::State::running);
    return acre::Result::ok;
}

acre::Result CEngine::stop() {
    LOG("Engine Shutting Down");
    this->setState(acre::State::stopping);

    if (this->getClient()) {
        this->getClient()->enableMicrophone(true);        // unmute local microphone on stopping
        this->getClient()->unMuteAll();
    }

    if (this->getRpcEngine()) {
        this->getRpcEngine()->stopWorker();
    }

    if (this->getGameServer()) {
        this->getGameServer()->shutdown();
    }

    if (this->getExternalServer()) {
        this->getExternalServer()->shutdown();
    }

    CAcreSettings::getInstance()->save();

    this->setState(acre::State::stopped);
    LOG("Engine Shutdown Complete");
    return acre::Result::ok;
}

acre::Result CEngine::localStartSpeaking(const acre::Speaking speakingType) {
    this->localStartSpeaking(speakingType, "");
    return acre::Result::ok;
}

acre::Result CEngine::localStartSpeaking(const acre::Speaking speakingType, const std::string radioId) {
    // send a start speaking event to everyone
    TRACE("Local START speaking: %d, %s", speakingType, radioId.c_str());
    this->getSelf()->lock();
    this->getSelf()->setCurrentRadioId(radioId);
    this->getSelf()->setSpeakingType(speakingType);
    this->getSelf()->clearSoundChannels();

    CEngine::getInstance()->getExternalServer()->sendMessage(
        CTextMessage::formatNewMessage("ext_remoteStartSpeaking",
            "%d,%d,%s,%d,%s,%f,",
            this->getSelf()->getId(),
            this->getSelf()->getCurrentLanguageId(),
            this->getSelf()->getNetId().c_str(),
            this->getSelf()->getSpeakingType(),
            this->getSelf()->getCurrentRadioId().c_str(),
            this->getSelf()->getSelectableCurveScale()
        )
    );

    // Send the local start speaking event to ourselves, so we can play squawk, etc in game.
    CEngine::getInstance()->getGameServer()->sendMessage( CTextMessage::formatNewMessage("localStartSpeaking",
        "%d,%d,%d,%s,",
        this->getSelf()->getId(),
        this->getSelf()->getCurrentLanguageId(),
        this->getSelf()->getSpeakingType(),
        this->getSelf()->getCurrentRadioId().c_str()
        )
    );

    this->getSelf()->setSpeaking(true);
    this->getSelf()->unlock();
    return acre::Result::ok;
}

acre::Result CEngine::localStopSpeaking( void ) {
    this->getSelf()->setSpeaking(false);
    CEngine::getInstance()->getExternalServer()->sendMessage(
        CTextMessage::formatNewMessage("ext_remoteStopSpeaking",
            "%d,%s,",
            this->getSelf()->getId(),
            this->getSelf()->getNetId().c_str()
        )
    );

    CEngine::getInstance()->getGameServer()->sendMessage( CTextMessage::formatNewMessage("localStopSpeaking",
        "%d,%d,%s,",
        this->getSelf()->getId(),
        this->getSelf()->getSpeakingType(),
        this->getSelf()->getCurrentRadioId().c_str()
        )
    );

    return acre::Result::ok;
}

acre::Result CEngine::remoteStartSpeaking(const acre::id_t remoteId, const int32_t languageId, const std::string netId, const acre::Speaking speakingType, const std::string radioId, const acre::volume_t curveScale) {
    TRACE("Remote Start Speaking Enter: %d, %d", remoteId, speakingType);
    auto it = this->speakingList.find(remoteId);
    if (it != this->speakingList.end()) {
        //ghetto rig the remote players curveScale updates
        it->second->setSelectableCurveScale(curveScale);
        return acre::Result::ok;
    }
    CPlayer *remotePlayer = new CPlayer(remoteId);
    this->speakingList.insert(std::pair<acre::id_t, CPlayer *>(remoteId, remotePlayer));
    remotePlayer->setSpeakingType(speakingType);
    remotePlayer->setSelectableCurveScale(curveScale);
    remotePlayer->setCurrentRadioId(radioId);
    remotePlayer->setNetId(netId);

    CEngine::getInstance()->getGameServer()->sendMessage( CTextMessage::formatNewMessage("remoteStartSpeaking",
        "%d,%d,%s,%d,%s,",
        remoteId,
        languageId,
        netId.c_str(),
        speakingType,
        radioId.c_str()
        )
    );

    return acre::Result::ok;
}

acre::Result CEngine::remoteStopSpeaking(const acre::id_t remoteId) {
    TRACE("Remote STOP Speaking Enter: %d", remoteId);
    auto it = this->speakingList.find(remoteId);
    if (it != this->speakingList.end()) {
        CPlayer *remotePlayer = (CPlayer *)it->second;

        CEngine::getInstance()->getGameServer()->sendMessage( CTextMessage::formatNewMessage("remoteStopSpeaking",
            "%d,%s,%d,%s,",
            remotePlayer->getId(),
            remotePlayer->getNetId().c_str(),
            remotePlayer->getSpeakingType(),
            remotePlayer->getCurrentRadioId().c_str()
            )
        );

        this->speakingList.erase(it);
        if (remotePlayer)
            delete remotePlayer;
    }
    return acre::Result::ok;
}
