#pragma once
#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "_CONSTANTS.h"

class IRpcFunction
{
public:
    virtual ~IRpcFunction(){}

    virtual acre_result_t call(IServer*, IMessage *) = 0;

    DECLARE_INTERFACE_MEMBER(char *, Name);
};