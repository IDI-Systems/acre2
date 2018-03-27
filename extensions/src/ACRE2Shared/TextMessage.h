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
    CTextMessage(int8_t *data, size_t length);
    ~CTextMessage(void);
    ACRE_RESULT parse(int8_t *data, size_t len);

    int8_t *getProcedureName(void);
    bool isValid();
    uint8_t *getParameter(uint32_t index);
    int32_t getParameterAsInt(uint32_t index);
    float getParameterAsFloat(uint32_t index);
    uint32_t getParameterCount(void);


    static IMessage *createNewMessage(int8_t *procedureName, ... );
    static IMessage *formatNewMessage(int8_t *procedureName, int8_t *format, ... );

    uint8_t *getData() {
        return ((uint8_t *)this->m_DataPtr);
    }
    ACRE_RESULT setData(uint8_t *data) {
        this->parse((int8_t *)data, strlen((int8_t*)data));
        return ACRE_OK;
    }

    uint32_t getLength() {
        return this->m_Data->length();
    }

private:
    std::string *m_Data;
    std::string *m_RpcProcedureName;
    std::string *m_Parameters[TEXTMESSAGE_MAX_PARAMETER_COUNT];
    uint32_t m_ParameterCount;
    bool m_IsValid;
    int8_t *m_DataPtr;
};
