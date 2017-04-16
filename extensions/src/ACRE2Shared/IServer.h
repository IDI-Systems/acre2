#pragma once

#include "_CONSTANTS.h"
#include "Macros.h"
#include "compat.h"
#include "Types.h"

//typedef ACRE_RESULT (*IServerCallback)(IServer *, IMessage *msg, void *data);

class IServer
{
public:
    virtual ~IServer(){}
    
    virtual ACRE_RESULT initialize(void) = 0;
    virtual ACRE_RESULT shutdown(void) = 0;

    virtual ACRE_RESULT sendMessage(IMessage *msg) = 0;
    virtual ACRE_RESULT handleMessage(unsigned char *data) = 0;
    virtual ACRE_RESULT release(void) = 0;
    
    
    //DECLARE_INTERFACE_MEMBER(IServerCallback, RecvCallback);
    DECLARE_INTERFACE_MEMBER(bool, Connected);
    DECLARE_INTERFACE_MEMBER(ACRE_ID, Id);
};