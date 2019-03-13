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

    acre_result_t        addProcedure(IRpcFunction *cmd);
    acre_result_t        removeProcedure(IRpcFunction *cmd);
    acre_result_t        removeProcedure(char * cmd);
    IRpcFunction    *findProcedure(char *cmd);
    acre_result_t        runProcedure(IServer *serverInstance, IMessage *msg);
    acre_result_t        runProcedure(IServer *serverInstance, IMessage *msg, BOOL entrant);

    acre_result_t        exProcessItem(ACRE_RPCDATA *data);
private:
    std::map<std::string, IRpcFunction *> m_FunctionList;
};