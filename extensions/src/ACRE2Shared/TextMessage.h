#pragma once

#include "compat.h"
#include <list>

#include <string>
#include <cstring>

#include "Macros.h"
#include "Types.h"

#include "IMessage.h"

#define TEXTMESSAGE_BUFSIZE 4096
#define TEXTMESSAGE_MAX_PARAMETER_COUNT 1024


class CTextMessage : public IMessage
{
public:
    // create new message to send constructor
    CTextMessage(char *data, size_t length);
    ~CTextMessage(void);
    ACRE_RESULT parse(char *data, size_t len);

    char *getProcedureName(void);
    bool isValid();
    unsigned char *getParameter(unsigned int index);
    int getParameterAsInt(unsigned int index);
    float getParameterAsFloat(unsigned int index);
    unsigned int getParameterCount(void);


    static IMessage *createNewMessage(char *procedureName, ... );
    static IMessage *formatNewMessage(char *procedureName, char *format, ... );

    unsigned char *getData() {
        return ((unsigned char *)this->m_DataPtr);
    }
    ACRE_RESULT setData(unsigned char *data) {
        this->parse((char *)data, strlen((char*)data));
        return ACRE_OK;
    }

    unsigned int getLength() {
        return this->m_Data->length();
    }

private:
    std::string *m_Data;
    std::string *m_RpcProcedureName;
    std::string *m_Parameters[TEXTMESSAGE_MAX_PARAMETER_COUNT];
    unsigned int m_ParameterCount;
    bool m_IsValid;
    char *m_DataPtr;
};
