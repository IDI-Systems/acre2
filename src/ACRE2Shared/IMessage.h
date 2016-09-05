#pragma once

#include "compat.h"
#include "Macros.h"

class IMessage
{
public:
	virtual ~IMessage(){}

	virtual unsigned char *getData(void) = 0;
	virtual unsigned int getLength(void) = 0;
	virtual char *getProcedureName(void) = 0;

	virtual unsigned char *getParameter(unsigned int) = 0;
	virtual int getParameterAsInt(unsigned int) = 0;
	virtual float getParameterAsFloat(unsigned int) = 0;
	virtual unsigned int getParameterCount(void) = 0;
	
};