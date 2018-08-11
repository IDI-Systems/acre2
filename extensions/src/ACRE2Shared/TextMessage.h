#pragma once

#include "compat.h"
#include <list>
#include <string>
#include "Macros.h"
#include "Types.h"

#include "IMessage.h"

#define TEXTMESSAGE_BUFSIZE 4096
#define TEXTMESSAGE_MAX_PARAMETER_COUNT 1024


class CTextMessage : public IMessage
{
public:
    // create new message to send constructor
    CTextMessage(char *const data, const size_t ac_length);
    ~CTextMessage(void);
    ACRE_RESULT parse(char *const data, const size_t ac_len);

    char *getProcedureName(void);
    BOOL isValid();
    unsigned char *getParameter(const uint32_t ac_index);
    int getParameterAsInt(const uint32_t ac_index);
    float getParameterAsFloat(uint32_t index);
    unsigned int getParameterCount(void);
    

    static IMessage *createNewMessage(const char *const procedureName, ... );
    static IMessage *formatNewMessage(const char *const  procedureName, char *format, ... );

    unsigned char *getData() { 
        return (unsigned char *) this->m_DataPtr; 
    }
    ACRE_RESULT setData(unsigned char *data) {
        this->parse((char *)data, strlen((char *) data));
        return ACRE_OK;
    }

    uint32_t getLength() {
        return (uint32_t) this->m_Data->length();
    }

private:
    std::string *m_Data;
    std::string *m_RpcProcedureName;
    std::string *m_Parameters[TEXTMESSAGE_MAX_PARAMETER_COUNT];
    uint32_t m_ParameterCount;
    bool m_IsValid;
    char *m_DataPtr;
};
