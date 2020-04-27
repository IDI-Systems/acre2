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

    acre::Result    addProcedure(IRpcFunction *const cmd);
    acre::Result    removeProcedure(IRpcFunction *const cmd);
    acre::Result    removeProcedure(char *const cmd);
    IRpcFunction    *findProcedure(char *const cmd);
    acre::Result    runProcedure(IServer *const serverInstance, IMessage *msg);
    acre::Result    runProcedure(IServer *const serverInstance, IMessage *msg, bool entrant);

    acre::Result    exProcessItem(ACRE_RPCDATA *data);
private:
    std::map<std::string, IRpcFunction *> m_FunctionList;
};
