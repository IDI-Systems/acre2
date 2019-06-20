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
    if (data->function != nullptr) {
        data->function->call(data->server, data->message);
    }
    delete data->message;
    free(data);

    return acre::Result::ok;
}

//
// Proc functions
// 
acre::Result CRpcEngine::addProcedure(IRpcFunction *const cmd) {
    LOCK(this);
    this->m_FunctionList.insert(std::pair<std::string, IRpcFunction *>(std::string(cmd->getName()), cmd));
    UNLOCK(this);

    return acre::Result::ok;
}
acre::Result CRpcEngine::removeProcedure(IRpcFunction *const cmd) {
    LOCK(this);
    this->m_FunctionList.erase(cmd->getName());
    UNLOCK(this);

    return acre::Result::ok;
}
acre::Result CRpcEngine::removeProcedure(char *const cmd) {
    LOCK(this);
    this->m_FunctionList.erase(cmd);
    UNLOCK(this);

    return acre::Result::ok;
}
IRpcFunction *CRpcEngine::findProcedure(char *const cmd) {
    
    if (this->getShuttingDown()) {
        return nullptr;
    }

    auto it = this->m_FunctionList.find(std::string((char *)cmd));
    if (it != this->m_FunctionList.end()) {
        return (IRpcFunction *)it->second;
    }

    return nullptr;
}
acre::Result CRpcEngine::runProcedure(IServer *const serverInstance, IMessage *msg) {
    return this->runProcedure(serverInstance, msg, TRUE);
}

acre::Result CRpcEngine::runProcedure(IServer *const serverInstance, IMessage *msg, const bool entrant) {
    
    if (msg == nullptr) {
        return acre::Result::error;
    } else if (msg->getProcedureName() == nullptr) {
        delete msg;
        return acre::Result::error;
    }

    IRpcFunction *const ptr = this->findProcedure((char *) msg->getProcedureName());
    if (ptr != nullptr) {
        if (!entrant) {
            LOCK(this);
            ptr->call(serverInstance, msg);
            delete msg;
            UNLOCK(this);
        } else {
            if (!this->getRunning()) {
                this->startWorker();
            }
            ACRE_RPCDATA *const data = (ACRE_RPCDATA *)malloc(sizeof(ACRE_RPCDATA));
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
