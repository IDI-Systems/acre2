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

    virtual void setConnected(const bool ac_value) = 0;
    virtual bool getConnected() const = 0;

    virtual void setId(const ACRE_ID ac_value) = 0;
    virtual ACRE_ID getId() const = 0;
};
