#pragma once

#include "_CONSTANTS.h"
#include "Macros.h"
#include "compat.h"
#include "Types.h"

//typedef acre::Result (*IServerCallback)(IServer *, IMessage *msg, void *data);

class IServer {
public:
    virtual ~IServer(){}
    
    virtual acre::Result initialize(void) = 0;
    virtual acre::Result shutdown(void) = 0;

    virtual acre::Result sendMessage(IMessage *const msg) = 0;
    virtual acre::Result handleMessage(unsigned char *const data) = 0;
    virtual acre::Result release(void) = 0;
    
    
    //DECLARE_INTERFACE_MEMBER(IServerCallback, RecvCallback);
    virtual void setConnected(const bool value) = 0;
    virtual bool getConnected() const = 0;

    virtual void setId(const acre::id_t value) = 0;
    virtual acre::id_t getId() const = 0;
};
