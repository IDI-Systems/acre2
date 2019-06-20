#pragma once

#include "compat.h"
#include <list>
#include <string>
#include "Macros.h"
#include "Types.h"

#include "IMessage.h"

static const int32_t TEXTMESSAGE_BUFSIZE = 4096;
static const int32_t TEXTMESSAGE_MAX_PARAMETER_COUNT = 1024;

class CTextMessage : public IMessage {
public:
    // create new message to send constructor
    CTextMessage(char *data, size_t length);
    ~CTextMessage(void);
    acre::Result parse(char *const data, const size_t len);
    bool isValid();

    const char* getProcedureName(void) const final;
    const unsigned char* getParameter(const uint32_t index) const final;
    int32_t getParameterAsInt(const uint32_t index) const final;
    float32_t getParameterAsFloat(const uint32_t index) const final;
    uint32_t getParameterCount(void) const final;

    static IMessage *createNewMessage(char *procedureName, ... );
    static IMessage *formatNewMessage(char *procedureName, char *format, ... );

    const unsigned char *getData() final { return ((unsigned char *)this->m_DataPtr); }
    acre::Result setData(unsigned char *const data) {
        this->parse((char *const) data, strlen((char*)data));
        return acre::Result::ok;
    }

    size_t getLength() const final { return this->m_Data->length(); }

private:
    std::string *m_Data;
    std::string *m_RpcProcedureName;
    std::string *m_Parameters[TEXTMESSAGE_MAX_PARAMETER_COUNT];
    uint32_t m_ParameterCount;
    bool m_IsValid;
    char *m_DataPtr;
};
