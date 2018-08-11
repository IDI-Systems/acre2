#pragma once

#include "compat.h"
#include "Macros.h"

class IMessage
{
public:
    virtual ~IMessage(){}

    virtual unsigned char *getData(void) = 0;
    virtual uint32_t getLength(void) = 0;
    virtual char *getProcedureName(void) = 0;

    virtual unsigned char *getParameter(unsigned int) = 0;
    virtual int32_t getParameterAsInt(unsigned int) = 0;
    virtual float32_t getParameterAsFloat(unsigned int) = 0;
    virtual uint32_t getParameterCount(void) = 0;
    
};
