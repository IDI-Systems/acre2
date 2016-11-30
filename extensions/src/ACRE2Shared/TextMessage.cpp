#include "TextMessage.h"
#include "IMessage.h"

#include "Log.h"

#include <string>

BOOL CTextMessage::isValid(void) {
    return this->m_IsValid;
}

ACRE_RESULT CTextMessage::parse(char *value, size_t len) {
    size_t x;
    size_t length;
    this->m_RpcProcedureName = NULL;
    this->m_Data = NULL;
    memset(this->m_Parameters, 0x00, sizeof(this->m_Parameters));
    this->m_IsValid = FALSE;
    this->m_ParameterCount = 0;

    if (!value){
        this->m_IsValid = FALSE;
        return ACRE_OK;
    }

    // Check to make sure the entire chunk of data is a NULL terminated ascii string
    for(x=0;x<len;x++) {
        if (!__isascii(value[x]) && value[x] != 0x00) {
            this->m_IsValid = FALSE;
            LOG("INVALID PACKET DETECTED l:%d", len);
            return ACRE_ERROR;
        }
        if (value[x] == 0x00)    // null terminate, bail
            break;
    }

    length = (strlen(value)+1);
    if (length < 3)  {
        this->m_IsValid = FALSE;
        return ACRE_ERROR;
    }
    
    this->m_DataPtr = (char *)LocalAlloc(0, length);
    memcpy(this->m_DataPtr, value, length);
    this->m_DataPtr[length-1] = 0x00;

    // parse the parameters and stuff
    // TODO: check actual string validity with isAlpha

    // parse it
    // tokenize it and break it up
    this->m_Data = new std::string(this->m_DataPtr);
    x = this->m_Data->find_first_of(":");
    if (x < 2 || x > 1000000 || x == std::string::npos) {
        LOG("INVALID DATA");
        this->m_IsValid = FALSE;
        return ACRE_ERROR;
    }
    std::string procedureName = this->m_Data->substr(0, x);
    this->m_RpcProcedureName = new std::string(procedureName.c_str());

    // now parse parameters..if there are any
    if (x == this->m_Data->length()-1) {
        this->m_IsValid = TRUE;    
        return ACRE_OK;
    }

    std::string t( this->m_Data->substr(this->m_Data->find_first_of(":")+1 , (this->m_Data->length() - this->m_Data->find_first_of(":")+1) ).c_str() );
    int pParamCount = 0;
    for(x = 0;x<TEXTMESSAGE_MAX_PARAMETER_COUNT;x++) {
        if (t.length() < 1)
            break;
        if (t.length() > 1 && t.find("<null>") == std::string::npos && t.find(",") != std::string::npos ) {
            this->m_Parameters[x] = new std::string(t.substr(0, t.find(",")).c_str());
            pParamCount += 1;
        }  else if (t.find(",") == std::string::npos ) {
            this->m_IsValid = TRUE;    
            this->m_Parameters[x] = new std::string(t.substr(0, t.length()));
            pParamCount += 1;
            break;
        }
        if (this->m_Parameters[x] == NULL) {
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
    this->m_IsValid = TRUE;
    
    //this->setLength((unsigned int)this->m_Data->size());

    return ACRE_OK;
}

CTextMessage::CTextMessage(char *value, size_t len)
{
    this->m_ParameterCount = 0;
    this->m_RpcProcedureName = NULL;
    this->m_DataPtr = NULL;
    this->parse(value, len);
    //this->m_Length = 0;
}

int CTextMessage::getParameterAsInt(unsigned int index) {
    unsigned char *value;
    value = this->getParameter(index);
    if (value) {
        return((int)atoi((char*)value));
    } else {
        return ACRE_ERROR;
    }
}


float CTextMessage::getParameterAsFloat(unsigned int index) {
    unsigned char *value;
    value = this->getParameter(index);
    if (value) {
        return((float)atof((char*)value));
    } else {
        return (float)ACRE_ERROR;
    }
}

unsigned char *CTextMessage::getParameter(unsigned int index) {
    if (index > this->m_ParameterCount) {
        return NULL;
    } else {
        if (this->m_Parameters[index] == NULL) 
            return NULL;
        else
            return((unsigned char *)this->m_Parameters[index]->c_str());
    }
}


CTextMessage::~CTextMessage(void)
{
    unsigned int x;

    for(x=0;x<TEXTMESSAGE_MAX_PARAMETER_COUNT;x++) {
        if (this->m_Parameters[x])
            delete this->m_Parameters[x];
    }

    if (this->m_RpcProcedureName)
        delete this->m_RpcProcedureName;
    if (this->m_Data)
        delete this->m_Data;
    if (this->m_DataPtr)
        LocalFree(this->m_DataPtr);
}
char *CTextMessage::getProcedureName() {
    if (this->m_RpcProcedureName) {
        return (char *)this->m_RpcProcedureName->c_str();
    } else {
        return NULL;
    }
}
IMessage *CTextMessage::formatNewMessage(char *procedureName, char *format, ... ) {
    char buffer[TEXTMESSAGE_BUFSIZE];
    char *finalBuffer;
    va_list va;
    CTextMessage *msg;

    msg = NULL;


    if (!procedureName) {
        LOG("procedureName was null");
        return NULL;
    }
    
    finalBuffer = (char *)LocalAlloc(LPTR, TEXTMESSAGE_BUFSIZE);
    if (!buffer) {
        LOG("LocalAlloc() failed: %d", GetLastError());
        return NULL;
    }
    
    buffer[0] = 0x00;
    _snprintf_s(finalBuffer, TEXTMESSAGE_BUFSIZE, TEXTMESSAGE_BUFSIZE-1, "%s:", procedureName); 
    
    va_start(va, format);
    vsprintf_s(buffer,sizeof(buffer), format, va);
    va_end(va);

    strcat_s(finalBuffer, TEXTMESSAGE_BUFSIZE, buffer);

    msg = new CTextMessage(finalBuffer, strlen(finalBuffer)+1);

    if (!msg->isValid()) {
        LOG("ERR: msg was invalid");
        delete msg;
        msg = NULL;
    }

    LocalFree(finalBuffer);

    return((IMessage *)msg);
}

IMessage *CTextMessage::createNewMessage(char *procedureName, ... ) {
    char *buffer, *ptr;
    va_list va;
    CTextMessage *msg;

    msg = NULL;

    if (!procedureName) {
        LOG("procedureName was null");
        return NULL;
    }
    
    buffer = (char *)LocalAlloc(LPTR, TEXTMESSAGE_BUFSIZE);
    if (!buffer) {
        LOG("LocalAlloc() failed: %d", GetLastError());
        return NULL;
    }
    
    buffer[0] = 0x00;
    _snprintf_s(buffer, TEXTMESSAGE_BUFSIZE, TEXTMESSAGE_BUFSIZE-1, "%s:", procedureName); 
    
    va_start(va, procedureName);
    ptr = va_arg( va, char * );
    while(ptr != NULL) {
        strcat_s(buffer, TEXTMESSAGE_BUFSIZE, ptr);
        strcat_s(buffer, TEXTMESSAGE_BUFSIZE, ",");
        ptr = va_arg( va, char * );    
    }
    va_end(va);

    buffer = (char *)LocalReAlloc(buffer, strlen(buffer)+1, LMEM_MOVEABLE);
    msg = new CTextMessage(buffer, strlen(buffer)+1);
    
    if (!msg->isValid()) {
        LOG("ERR: msg was invalid");
        delete msg;
        msg = NULL;
    }

    LocalFree(buffer);

    return((IMessage *)msg);
}
unsigned int CTextMessage::getParameterCount() { 
    return (this->m_ParameterCount);
}