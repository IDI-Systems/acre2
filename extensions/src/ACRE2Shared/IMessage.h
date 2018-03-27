#pragma once

#include "compat.h"
#include "Macros.h"

class IMessage
{
public:
    virtual ~IMessage(){}

    virtual uint8_t *getData(void) = 0;
    virtual uint32_t getLength(void) = 0;
    virtual int8_t *getProcedureName(void) = 0;

    virtual unsigned char *getParameter(uint32_t) = 0;
    virtual int32_t getParameterAsInt(uint32_t) = 0;
    virtual float getParameterAsFloat(uint32_t) = 0;
    virtual uint32_t getParameterCount(void) = 0;
    
};
