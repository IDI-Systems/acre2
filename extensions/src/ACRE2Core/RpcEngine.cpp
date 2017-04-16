#pragma once

#include "compat.h"
#include "RpcEngine.h"
#include "IRpcFunction.h"

#include "Macros.h"
#include "Types.h"
#include "IServer.h"
#include "IMessage.h"
#include "Macros.h"
#include "Log.h"
#include <list>

//
// Entrant worker, weee
//
ACRE_RESULT CRpcEngine::exProcessItem(ACRE_RPCDATA *data) {
    if (data->function) {
        data->function->call(data->server, data->message);
    }
    delete data->message;
    free(data);

    return ACRE_OK;
}

//
// Proc functions
// 
ACRE_RESULT CRpcEngine::addProcedure(IRpcFunction *cmd) {
    LOCK(this);
    this->m_FunctionList.insert(std::pair<std::string, IRpcFunction *>(std::string(cmd->getName()), cmd));
    UNLOCK(this);

    return ACRE_OK;
}
ACRE_RESULT CRpcEngine::removeProcedure(IRpcFunction *cmd) {
    LOCK(this);
    this->m_FunctionList.erase(cmd->getName());
    UNLOCK(this);

    return ACRE_OK;
}
ACRE_RESULT CRpcEngine::removeProcedure(char * cmd) {
    LOCK(this);
    this->m_FunctionList.erase(cmd);
    UNLOCK(this);

    return ACRE_OK;
}
IRpcFunction *CRpcEngine::findProcedure(char *cmd) {
    
    std::map<std::string, IRpcFunction *>::iterator it;

    if (this->getShuttingDown())
        return NULL;

    it = this->m_FunctionList.find(std::string((char *)cmd));
    if (it != this->m_FunctionList.end())
        return (IRpcFunction *)it->second;

    return NULL;
}
ACRE_RESULT CRpcEngine::runProcedure(IServer *serverInstance, IMessage *msg) {
    return this->runProcedure(serverInstance, msg, true);
}
ACRE_RESULT CRpcEngine::runProcedure(IServer *serverInstance, IMessage *msg, bool entrant) {
    IRpcFunction *ptr;
    ACRE_RPCDATA *data;
    
    if (msg) {
        if (!msg->getProcedureName()) {
            delete msg;
            return false;
        }

        ptr = this->findProcedure(msg->getProcedureName());
        if (ptr) {
            if (!entrant) {
                LOCK(this);
                ptr->call(serverInstance, msg);
                delete msg;
                UNLOCK(this);
            } else {
                if (!this->getRunning()) {
                    this->startWorker();
                }
                data = (ACRE_RPCDATA *)malloc(sizeof(ACRE_RPCDATA));
                data->function = ptr;
                data->server = serverInstance;
                data->message = msg;
                LOCK(this);
                this->m_processQueue.push(data);
                UNLOCK(this);
            }
        } else {
            // No procedure, delete the message to stop memory leak
            delete msg;
        }
        return ACRE_OK;
    } else {
        return ACRE_ERROR;
    }
}
//
// Constructor // Destructor
//
CRpcEngine::CRpcEngine() {
    // start our entrant worker, weee
    this->startWorker();
}
CRpcEngine::~CRpcEngine() {
    this->stopWorker();
}