#include "MumbleCommandServer.h"

#include "MumbleFunctions.h"

#include "TextMessage.h"
#include "Log.h"

#include "MumbleClient.h"

extern MumbleAPI mumAPI;
extern mumble_connection_t activeConnection;
extern plugin_id_t pluginID;

acre::Result CMumbleCommandServer::initialize(void){
    TRACE("enter");

    return acre::Result::ok;
}

acre::Result CMumbleCommandServer::shutdown(void) {
    TRACE("enter");

    return acre::Result::ok;
}


acre::Result CMumbleCommandServer::sendMessage(IMessage *msg){
    LOCK(this);
    /*
    ts3Functions.sendPluginCommand((unsigned __int64)ts3Functions.getCurrentServerConnectionHandlerID(),
        (const char*)this->getCommandId(),
        (const char*)msg->getData(),
        PluginCommandTarget_CURRENT_CHANNEL, NULL, NULL);
        */
    mumble_userid_t* channelUsers;
    size_t userCount;
    mumble_channelid_t currentChannel;
    mumble_error_t err;
    err = mumAPI.getChannelOfUser(pluginID, activeConnection, this->getId(), &currentChannel);
    if (err != ErrorCode::EC_OK) {
        LOG("ERROR, UNABLE TO GET CHANNEL OF USER: %d", err);
        return acre::Result::error;
    }
    err = mumAPI.getUsersInChannel(pluginID, activeConnection, currentChannel, &channelUsers, &userCount);
    if (err != ErrorCode::EC_OK) {
        LOG("ERROR, UNABLE TO GET USERS IN CHANNEL: %d", err);
        return acre::Result::error;
    }
    err = mumAPI.sendData(pluginID, activeConnection, channelUsers, userCount, (const char*)msg->getData(), msg->getLength(), "ACRE2");
    if (err != ErrorCode::EC_OK) {
        LOG("ERROR, UNABLE TO SEND MESSAGE DATA: %d", err);
        return acre::Result::error;
    }
    err = mumAPI.freeMemory(pluginID, (void *)channelUsers);
    if (err != ErrorCode::EC_OK) {
        LOG("ERROR, UNABLE TO FREE CHANNEL USER LIST: %d", err);
        return acre::Result::error;
    }

    delete msg;

    UNLOCK(this);

    return acre::Result::ok;
}

acre::Result CMumbleCommandServer::handleMessage(unsigned char* data) {
    return this->handleMessage(data, strlen((char*)data));
}

acre::Result CMumbleCommandServer::handleMessage(unsigned char* data, size_t length) {
    CTextMessage* msg;
    //TRACE("recv: [%s]", data);
    msg = new CTextMessage((char*)data, length);
    if (CEngine::getInstance()->getRpcEngine() && (msg != nullptr)) {
        CEngine::getInstance()->getRpcEngine()->runProcedure((IServer*)this, (IMessage*)msg);
    }
    return acre::Result::ok;
}


acre::Result CMumbleCommandServer::release(void) {
    return acre::Result::ok;
}


//
// constructor/destructor foo
// 
CMumbleCommandServer::CMumbleCommandServer(const acre::id_t id) {
    this->setId(id);
}
CMumbleCommandServer::CMumbleCommandServer(void) {
    this->setCommandId(0);
    this->setConnected(true);
}
CMumbleCommandServer::~CMumbleCommandServer() {
    
}
