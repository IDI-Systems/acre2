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

    acre::Result        addProcedure(IRpcFunction *cmd);
    acre::Result        removeProcedure(IRpcFunction *cmd);
    acre::Result        removeProcedure(char * cmd);
    IRpcFunction    *findProcedure(char *cmd);
    acre::Result        runProcedure(IServer *serverInstance, IMessage *msg);
    acre::Result        runProcedure(IServer *serverInstance, IMessage *msg, BOOL entrant);

    acre::Result        exProcessItem(ACRE_RPCDATA *data);
private:
    std::map<std::string, IRpcFunction *> m_FunctionList;
};