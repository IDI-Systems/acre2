#pragma once

#include "compat.h"
#include "Macros.h"

class IMessage
{
public:
    virtual ~IMessage(){}

    virtual unsigned char *const getData(void) = 0;
    virtual size_t getLength(void) const = 0;
    virtual const char *const getProcedureName(void) const = 0;

    virtual const unsigned char *const getParameter(const uint32_t index) const = 0;
    virtual int32_t getParameterAsInt(const uint32_t index) const = 0;
    virtual float32_t getParameterAsFloat(const uint32_t index) const = 0;
    virtual uint32_t getParameterCount(void) const = 0;
};
