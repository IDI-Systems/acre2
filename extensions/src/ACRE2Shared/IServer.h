#pragma once

#include "_CONSTANTS.h"
#include "Macros.h"
#include "compat.h"
#include "Types.h"

//typedef AcreResult (*IServerCallback)(IServer *, IMessage *msg, void *data);

class IServer
{
public:
    virtual ~IServer(){}
    
    virtual AcreResult initialize(void) = 0;
    virtual AcreResult shutdown(void) = 0;

    virtual AcreResult sendMessage(IMessage *msg) = 0;
    virtual AcreResult handleMessage(unsigned char *data) = 0;
    virtual AcreResult release(void) = 0;
    
    
    //DECLARE_INTERFACE_MEMBER(IServerCallback, RecvCallback);
    DECLARE_INTERFACE_MEMBER(BOOL, Connected);
    DECLARE_INTERFACE_MEMBER(acre_id_t, Id);
};