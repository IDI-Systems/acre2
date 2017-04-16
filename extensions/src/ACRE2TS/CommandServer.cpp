#include "CommandServer.h"

#include "TsFunctions.h"

#include "TextMessage.h"
#include "Log.h"

#include "TS3Client.h"

extern TS3Functions ts3Functions;

ACRE_RESULT CCommandServer::initialize(void){
    TRACE("enter");

    return ACRE_OK;
}

ACRE_RESULT CCommandServer::shutdown(void) {
    TRACE("enter");

    return ACRE_OK;
}


ACRE_RESULT CCommandServer::sendMessage(IMessage *msg){
    LOCK(this);
    //LOG("Sending: %s", (const char *)msg->getData());
    ts3Functions.sendPluginCommand((unsigned __int64)ts3Functions.getCurrentServerConnectionHandlerID(),
        (const char *)this->getCommandId(), 
        (const char *)msg->getData(), 
        PluginCommandTarget_CURRENT_CHANNEL, NULL, NULL);
    //LOG("sending [%s], [%s]", this->getCommandId(), msg->getData());

    delete msg;

    UNLOCK(this);

    return ACRE_OK;
}

ACRE_RESULT CCommandServer::handleMessage(unsigned char *data){
    CTextMessage *msg;
    //LOG("recv: [%s]", data);
    msg = new CTextMessage((char *)data, strlen((char *)data));
    if (CEngine::getInstance()->getRpcEngine() && msg) {
        CEngine::getInstance()->getRpcEngine()->runProcedure((IServer *)this, (IMessage *)msg);
    }
    return ACRE_OK;
}


ACRE_RESULT CCommandServer::release(void) {
    
    if (this->getCommandId())
        free(this->getCommandId());

    return ACRE_OK;
}


//
// constructor/destructor foo
// 
CCommandServer::CCommandServer(ACRE_ID id) {
    this->setId(id);
}
CCommandServer::CCommandServer(void) {
    this->setCommandId(NULL);
    this->setConnected(true);
}
CCommandServer::~CCommandServer() {
    
}