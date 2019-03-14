#include "CommandServer.h"

#include "TsFunctions.h"

#include "TextMessage.h"
#include "Log.h"

#include "TS3Client.h"

extern TS3Functions ts3Functions;

acre_result_t CCommandServer::initialize(void){
    TRACE("enter");

    return acre_result_ok;
}

acre_result_t CCommandServer::shutdown(void) {
    TRACE("enter");

    return acre_result_ok;
}


acre_result_t CCommandServer::sendMessage(IMessage *msg){
    LOCK(this);
    //LOG("Sending: %s", (const char *)msg->getData());
    ts3Functions.sendPluginCommand((unsigned __int64)ts3Functions.getCurrentServerConnectionHandlerID(),
        (const char *)this->getCommandId(), 
        (const char *)msg->getData(), 
        PluginCommandTarget_CURRENT_CHANNEL, NULL, NULL);
    //TRACE("sending [%s], [%s]", this->getCommandId(), msg->getData());

    delete msg;

    UNLOCK(this);

    return acre_result_ok;
}

acre_result_t CCommandServer::handleMessage(unsigned char *data){
    CTextMessage *msg;
    //TRACE("recv: [%s]", data);
    msg = new CTextMessage((char *)data, strlen((char *)data));
    if (CEngine::getInstance()->getRpcEngine() && msg) {
        CEngine::getInstance()->getRpcEngine()->runProcedure((IServer *)this, (IMessage *)msg);
    }
    return acre_result_ok;
}


acre_result_t CCommandServer::release(void) {
    
    if (this->getCommandId())
        free(this->getCommandId());

    return acre_result_ok;
}


//
// constructor/destructor foo
// 
CCommandServer::CCommandServer(acre_id_t id) {
    this->setId(id);
}
CCommandServer::CCommandServer(void) {
    this->setCommandId(NULL);
    this->setConnected(TRUE);
}
CCommandServer::~CCommandServer() {
    
}