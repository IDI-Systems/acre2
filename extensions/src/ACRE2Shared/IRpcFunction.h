#pragma once
#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "_CONSTANTS.h"

class IRpcFunction
{
public:
    virtual ~IRpcFunction(){}

    virtual AcreResult call(IServer*, IMessage *) = 0;

    DECLARE_INTERFACE_MEMBER(char *, Name);
};
