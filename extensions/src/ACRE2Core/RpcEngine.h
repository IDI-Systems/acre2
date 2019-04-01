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

    AcreResult        addProcedure(IRpcFunction *cmd);
    AcreResult        removeProcedure(IRpcFunction *cmd);
    AcreResult        removeProcedure(char * cmd);
    IRpcFunction    *findProcedure(char *cmd);
    AcreResult        runProcedure(IServer *serverInstance, IMessage *msg);
    AcreResult        runProcedure(IServer *serverInstance, IMessage *msg, BOOL entrant);

    AcreResult        exProcessItem(ACRE_RPCDATA *data);
private:
    std::map<std::string, IRpcFunction *> m_FunctionList;
};