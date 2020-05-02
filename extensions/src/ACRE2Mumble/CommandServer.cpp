#include "CommandServer.h"

#include "MumbleFunctions.h"

#include "TextMessage.h"
#include "Log.h"

#include "MumbleClient.h"

extern MumbleAPI mumAPI;
extern mumble_connection_t activeConnection;
extern plugin_id_t ownID;

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

    delete msg;

    UNLOCK(this);

    return acre::Result::ok;
}

acre::Result CMumbleCommandServer::handleMessage(unsigned char *data){
    CTextMessage *msg;
    //LOG("recv: [%s]", data);
    msg = new CTextMessage((char *)data, strlen((char *)data));
    if (CEngine::getInstance()->getRpcEngine() && (msg != nullptr)) {
        CEngine::getInstance()->getRpcEngine()->runProcedure((IServer *)this, (IMessage *)msg);
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
