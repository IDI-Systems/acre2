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
acre::Result CRpcEngine::exProcessItem(ACRE_RPCDATA *data) {
    if (data->function) {
        data->function->call(data->server, data->message);
    }
    delete data->message;
    free(data);

    return acre::Result::ok;
}

//
// Proc functions
// 
acre::Result CRpcEngine::addProcedure(IRpcFunction *cmd) {
    LOCK(this);
    this->m_FunctionList.insert(std::pair<std::string, IRpcFunction *>(std::string(cmd->getName()), cmd));
    UNLOCK(this);

    return acre::Result::ok;
}
acre::Result CRpcEngine::removeProcedure(IRpcFunction *cmd) {
    LOCK(this);
    this->m_FunctionList.erase(cmd->getName());
    UNLOCK(this);

    return acre::Result::ok;
}
acre::Result CRpcEngine::removeProcedure(char * cmd) {
    LOCK(this);
    this->m_FunctionList.erase(cmd);
    UNLOCK(this);

    return acre::Result::ok;
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
acre::Result CRpcEngine::runProcedure(IServer *serverInstance, IMessage *msg) {
    return this->runProcedure(serverInstance, msg, TRUE);
}
acre::Result CRpcEngine::runProcedure(IServer *serverInstance, IMessage *msg, BOOL entrant) {
    IRpcFunction *ptr;
    ACRE_RPCDATA *data;
    
    if (msg) {
        if (!msg->getProcedureName()) {
            delete msg;
            return acre::Result::error;
        }

        ptr = this->findProcedure((char *) msg->getProcedureName());
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
        return acre::Result::ok;
    } else {
        return acre::Result::error;
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
