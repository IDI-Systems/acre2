#include "Log.h"
#include "MumbleClient.h"
#include "MumbleCommandServer.h"
#include "MumbleFunctions.h"
#include "TextMessage.h"

#include <Tracy.hpp>

#include <mutex>

extern MumbleAPI_v_1_0_x mumAPI;
extern mumble_connection_t activeConnection;
extern mumble_plugin_id_t pluginID;

acre::Result CMumbleCommandServer::initialize() {
    TRACE("enter");

    return acre::Result::ok;
}

acre::Result CMumbleCommandServer::shutdown() {
    TRACE("enter");

    return acre::Result::ok;
}

acre::Result CMumbleCommandServer::sendMessage(IMessage *msg) {
    ZoneScoped;

    std::lock_guard<CLockable> guard(*this);

    mumble_userid_t *channelUsers     = nullptr;
    size_t userCount                  = 0U;
    mumble_channelid_t currentChannel = 0;

    mumble_error_t err = API_CALL(getChannelOfUser, pluginID, activeConnection, this->getId(), &currentChannel);
    if (err != MUMBLE_STATUS_OK) {
        LOG("ERROR, UNABLE TO GET CHANNEL OF USER: %s (%d)", mumble_errorMessage(err), err);
        return acre::Result::error;
    }

    err = API_CALL(getUsersInChannel, pluginID, activeConnection, currentChannel, &channelUsers, &userCount);
    if (err != MUMBLE_STATUS_OK) {
        LOG("ERROR, UNABLE TO GET USERS IN CHANNEL: %s (%d)", mumble_errorMessage(err), err);
        return acre::Result::error;
    }

    err = API_CALL(sendData, pluginID, activeConnection, channelUsers, userCount, (const uint8_t *) msg->getData(), msg->getLength(), "ACRE2");
    if (err != MUMBLE_STATUS_OK) {
        LOG("ERROR, UNABLE TO SEND MESSAGE DATA: %s (%d)", mumble_errorMessage(err), err);
        return acre::Result::error;
    }
    err = API_CALL(freeMemory, pluginID, (void *) channelUsers);
    if (err != MUMBLE_STATUS_OK) {
        LOG("ERROR, UNABLE TO FREE CHANNEL USER LIST: %s (%d)", mumble_errorMessage(err), err);
        return acre::Result::error;
    }

    delete msg;

    return acre::Result::ok;
}

acre::Result CMumbleCommandServer::handleMessage(unsigned char *data) {
    return this->handleMessage(data, strlen((char *) data));
}

acre::Result CMumbleCommandServer::handleMessage(unsigned char *data, size_t length) {
    ZoneScoped;

    CTextMessage *msg = nullptr;
    // TRACE("recv: [%s]", data);
    msg = new (std::nothrow) CTextMessage((char *) data, length);
    if (CEngine::getInstance()->getRpcEngine() && (msg != nullptr)) {
        CEngine::getInstance()->getRpcEngine()->runProcedure((IServer *) this, (IMessage *) msg);
    }
    return acre::Result::ok;
}

acre::Result CMumbleCommandServer::release() {
    return acre::Result::ok;
}

//
// constructor/destructor foo
//
CMumbleCommandServer::CMumbleCommandServer(const acre::id_t id) {
    this->setId(id);
}

CMumbleCommandServer::CMumbleCommandServer() {
    this->setCommandId(0);
    this->setConnected(true);
}
