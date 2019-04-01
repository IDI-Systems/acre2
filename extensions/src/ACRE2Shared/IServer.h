#pragma once

#include "_CONSTANTS.h"
#include "Macros.h"
#include "compat.h"
#include "Types.h"

//typedef acre_result_t (*IServerCallback)(IServer *, IMessage *msg, void *data);

class IServer
{
public:
    virtual ~IServer(){}
    
    virtual acre_result_t initialize(void) = 0;
    virtual acre_result_t shutdown(void) = 0;

    virtual acre_result_t sendMessage(IMessage *msg) = 0;
    virtual acre_result_t handleMessage(unsigned char *data) = 0;
    virtual acre_result_t release(void) = 0;
    
    
    //DECLARE_INTERFACE_MEMBER(IServerCallback, RecvCallback);
    DECLARE_INTERFACE_MEMBER(BOOL, Connected);
    DECLARE_INTERFACE_MEMBER(acre_id_t, Id);
};