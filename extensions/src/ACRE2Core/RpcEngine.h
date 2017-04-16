#pragma once

#include "EntrantWorker.h"
#include "Types.h"
#include "IRpcFunction.h"
#include "Macros.h"

#include <map>
#include <string>

class CRpcEngine : public TEntrantWorker<ACRE_RPCDATA *>
{
public:
    CRpcEngine();
    ~CRpcEngine();

    ACRE_RESULT        addProcedure(IRpcFunction *cmd);
    ACRE_RESULT        removeProcedure(IRpcFunction *cmd);
    ACRE_RESULT        removeProcedure(char * cmd);
    IRpcFunction    *findProcedure(char *cmd);
    ACRE_RESULT        runProcedure(IServer *serverInstance, IMessage *msg);
    ACRE_RESULT        runProcedure(IServer *serverInstance, IMessage *msg, bool entrant);

    ACRE_RESULT        exProcessItem(ACRE_RPCDATA *data);
private:
    std::map<std::string, IRpcFunction *> m_FunctionList;
};