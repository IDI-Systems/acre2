#include "TextMessage.h"
#include "IMessage.h"

#include "Log.h"

#include <string>
#include <limits.h>

bool CTextMessage::isValid(void) {
    return this->m_IsValid;
}

acre::Result CTextMessage::parse(char *const value, const size_t len) {
    this->m_RpcProcedureName = nullptr;
    this->m_Data = nullptr;
    memset(this->m_Parameters, 0x00, sizeof(this->m_Parameters));
    this->m_IsValid = false;
    this->m_ParameterCount = 0;

    if (!value){
        this->m_IsValid = false;
        return acre::Result::ok;
    }

    // Don't check for ascii only characters for setTs3ChannelDetails procedure
    std::string text(value);
    if (text.find("setTs3ChannelDetails") == std::string::npos) {
        // Check to make sure the entire chunk of data is a NULL terminated ascii string
        for (size_t x = 0; x < len; x++) {
            if (!__isascii(value[x]) && value[x] != 0x00) {
                this->m_IsValid = false;
                LOG("INVALID PACKET DETECTED l:%d", len);
                return acre::Result::error;
            }
            if (value[x] == 0x00) {   // null terminate, bail
                break;
            }
        }
    }

    const size_t length = strlen(value) + 1;
    if (length < 3)  {
        this->m_IsValid = false;
        return acre::Result::error;
    }
    
    this->m_DataPtr = (char *)LocalAlloc(0, length);
    memcpy(this->m_DataPtr, value, length);
    this->m_DataPtr[length-1] = 0x00;

    // parse the parameters and stuff
    // TODO: check actual string validity with isAlpha

    // parse it
    // tokenize it and break it up
    this->m_Data = new std::string(this->m_DataPtr);
    const size_t pos = this->m_Data->find_first_of(":");
    if ((pos < 2) || (pos > 1000000) || (pos == std::string::npos)) {
        LOG("INVALID DATA");
        this->m_IsValid = false;
        return acre::Result::error;
    }
    std::string procedureName = this->m_Data->substr(0, pos);
    this->m_RpcProcedureName = new std::string(procedureName.c_str());

    // now parse parameters..if there are any
    if (pos == (this->m_Data->length() - 1)) {
        this->m_IsValid = true;    
        return acre::Result::ok;
    }

    std::string t( this->m_Data->substr(this->m_Data->find_first_of(":")+1 , (this->m_Data->length() - this->m_Data->find_first_of(":")+1) ).c_str() );
    int32_t pParamCount = 0;
    for (int32_t x = 0; x < TEXTMESSAGE_MAX_PARAMETER_COUNT; x++) {
        if (t.length() < 1) {
            break;
        }

        if ((t.length() > 1) && (t.find("<null>") == std::string::npos) && (t.find(",") != std::string::npos)) {
            this->m_Parameters[x] = new std::string(t.substr(0, t.find(",")).c_str());
            pParamCount += 1;
        }  else if (t.find(",") == std::string::npos) {
            this->m_IsValid = true;    
            this->m_Parameters[x] = new std::string(t.substr(0, t.length()));
            pParamCount += 1;
            break;
        }
        if (this->m_Parameters[x] == nullptr) {
            this->m_Parameters[x] = new std::string("");
        } else {
            if (this->m_Parameters[x]->length() < 1) {
                delete this->m_Parameters[x];
                this->m_Parameters[x] = new std::string("");
            }
        }
        t = t.substr(t.find(",")+1, t.length()-1);
    }

    this->m_ParameterCount = pParamCount;
    this->m_IsValid = true;
    
    //this->setLength((uint32_t)this->m_Data->size());

    return acre::Result::ok;
}

CTextMessage::CTextMessage(char *const value, const size_t len)
{
    this->m_ParameterCount = 0;
    this->m_RpcProcedureName = nullptr;
    this->m_DataPtr = nullptr;
    this->parse(value, len);
    //this->m_Length = 0;
}

int32_t CTextMessage::getParameterAsInt(const uint32_t index) const {
    const unsigned char * value = this->getParameter(index);
    if (value) {
        return atoi((char*)value);
    } else {
        return std::numeric_limits<int32_t>::max();
    }
}


float32_t CTextMessage::getParameterAsFloat(const uint32_t index) const {

    const unsigned char * value = this->getParameter(index);
    if (value) {
        return static_cast<float32_t>(atof((char*)value));
    } else {
        return static_cast<float32_t>(acre::Result::error);
    }
}

const unsigned char *const CTextMessage::getParameter(uint32_t index) const {
    if (index > this->m_ParameterCount) {
        return nullptr;
    } else {
        if (this->m_Parameters[index] == nullptr) {
            return nullptr;
        } else {
            return (unsigned char *)this->m_Parameters[index]->c_str();
        }
    }
}

CTextMessage::~CTextMessage(void) {
    
    for (uint32_t x = 0; x < TEXTMESSAGE_MAX_PARAMETER_COUNT; x++) {
        if (this->m_Parameters[x]) {
            delete this->m_Parameters[x];
        }
    }

    if (this->m_RpcProcedureName != nullptr) {
        delete this->m_RpcProcedureName;
    }
    if (this->m_Data != nullptr) {
        delete this->m_Data;
    }
    if (this->m_DataPtr != nullptr) {
        LocalFree(this->m_DataPtr);
    }
}

const char *const CTextMessage::getProcedureName() const {
    if (this->m_RpcProcedureName) {
        return (char *)this->m_RpcProcedureName->c_str();
    } else {
        return nullptr;
    }
}

IMessage *CTextMessage::formatNewMessage(char *procedureName, char *format, ... ) {
    char buffer[TEXTMESSAGE_BUFSIZE];
    va_list va;

    if (procedureName == nullptr) {
        LOG("procedureName was null");
        return nullptr;
    }
    
    char *finalBuffer = (char *)LocalAlloc(LPTR, TEXTMESSAGE_BUFSIZE);
    if (buffer == nullptr) {
        LOG("LocalAlloc() failed: %d", GetLastError());
        return nullptr;
    }
    
    buffer[0] = 0x00;
    _snprintf_s(finalBuffer, TEXTMESSAGE_BUFSIZE, TEXTMESSAGE_BUFSIZE-1, "%s:", procedureName); 
    
    va_start(va, format);
    vsprintf_s(buffer, sizeof(buffer), format, va);
    va_end(va);

    strcat_s(finalBuffer, TEXTMESSAGE_BUFSIZE, buffer);

    CTextMessage *msg = new CTextMessage(finalBuffer, strlen(finalBuffer) + 1);

    if (!msg->isValid()) {
        LOG("ERR: msg was invalid");
        delete msg;
        msg = nullptr;
    }

    LocalFree(finalBuffer);

    return static_cast<IMessage *>(msg);
}

IMessage *CTextMessage::createNewMessage(char *procedureName, ... ) {
    va_list va;
   
    if (!procedureName) {
        LOG("procedureName was null");
        return nullptr;
    }
    
    char *buffer = (char *)LocalAlloc(LPTR, TEXTMESSAGE_BUFSIZE);
    if (buffer == nullptr) {
        LOG("LocalAlloc() failed: %d", GetLastError());
        return nullptr;
    }
    
    buffer[0] = 0x00;
    _snprintf_s(buffer, TEXTMESSAGE_BUFSIZE, TEXTMESSAGE_BUFSIZE - 1, "%s:", procedureName); 
    
    va_start(va, procedureName);
    char *ptr = va_arg( va, char * );
    while (ptr != nullptr) {
        strcat_s(buffer, TEXTMESSAGE_BUFSIZE, ptr);
        strcat_s(buffer, TEXTMESSAGE_BUFSIZE, ",");
        ptr = va_arg( va, char * );    
    }
    va_end(va);

    buffer = (char *)LocalReAlloc(buffer, strlen(buffer) + 1, LMEM_MOVEABLE);
    CTextMessage *msg = new CTextMessage(buffer, strlen(buffer) + 1);
    
    if (!msg->isValid()) {
        LOG("ERR: msg was invalid");
        delete msg;
        msg = nullptr;
    }

    LocalFree(buffer);

    return((IMessage *)msg);
}

uint32_t CTextMessage::getParameterCount() const { 
    return this->m_ParameterCount;
}
