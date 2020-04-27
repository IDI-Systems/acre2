#pragma once
#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "_CONSTANTS.h"

class IRpcFunction
{
public:
    virtual ~IRpcFunction(){}

    virtual acre::Result call(IServer *const srv, IMessage *const msg) = 0;

    virtual void setName(char *const value) = 0;
    virtual char* getName() const = 0;
};
