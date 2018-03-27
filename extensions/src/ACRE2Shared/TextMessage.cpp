#include "TextMessage.h"
#include "IMessage.h"

#include "Log.h"

bool CTextMessage::isValid(void) {
    return this->m_IsValid;
}

ACRE_RESULT CTextMessage::parse(int8_t *value, size_t len) {
    size_t x;
    size_t length;
    this->m_RpcProcedureName = NULL;
    this->m_Data = NULL;
    memset(this->m_Parameters, 0x00, sizeof(this->m_Parameters));
    this->m_IsValid = false;
    this->m_ParameterCount = 0;

    if (!value){
        this->m_IsValid = false;
        return ACRE_OK;
    }

    // Check to make sure the entire chunk of data is a NULL terminated ascii string
    for (x=0;x<len;x++) {
        if (!__isascii(value[x]) && value[x] != 0x00) {
            this->m_IsValid = false;
            LOG("INVALID PACKET DETECTED l:%d", len);
            return ACRE_ERROR;
        }
        if (value[x] == 0x00)    // null terminate, bail
            break;
    }

    length = (strlen(value)+1);
    if (length < 3)  {
        this->m_IsValid = false;
        return ACRE_ERROR;
    }

    this->m_DataPtr = (int8_t *) calloc((size_t) length, sizeof(int8_t));
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
        this->m_IsValid = false;
        return ACRE_ERROR;
    }
    std::string procedureName = this->m_Data->substr(0, x);
    this->m_RpcProcedureName = new std::string(procedureName.c_str());

    // now parse parameters..if there are any
    if (x == this->m_Data->length()-1) {
        this->m_IsValid = true;
        return ACRE_OK;
    }

    std::string t( this->m_Data->substr(this->m_Data->find_first_of(":")+1 , (this->m_Data->length() - this->m_Data->find_first_of(":")+1) ).c_str() );
    int32_t pParamCount = 0;
    for (x = 0;x<TEXTMESSAGE_MAX_PARAMETER_COUNT;x++) {
        if (t.length() < 1)
            break;
        if (t.length() > 1 && t.find("<null>") == std::string::npos && t.find(",") != std::string::npos ) {
            this->m_Parameters[x] = new std::string(t.substr(0, t.find(",")).c_str());
            pParamCount += 1;
        }  else if (t.find(",") == std::string::npos ) {
            this->m_IsValid = true;
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
    this->m_IsValid = true;

    //this->setLength((uint32_t)this->m_Data->size());

    return ACRE_OK;
}

CTextMessage::CTextMessage(int8_t *value, size_t len)
{
    this->m_ParameterCount = 0;
    this->m_RpcProcedureName = NULL;
    this->m_DataPtr = NULL;
    this->parse(value, len);
    //this->m_Length = 0;
}

int32_t CTextMessage::getParameterAsInt(uint32_t index) {
    uint32_t8_t *value;
    value = this->getParameter(index);
    if (value) {
        return((int)atoi((int8_t*)value));
    } else {
        return ACRE_ERROR;
    }
}


float CTextMessage::getParameterAsFloat(uint32_t index) {
    uint8_t *value;
    value = this->getParameter(index);
    if (value) {
        return((float)atof((int8_t*)value));
    } else {
        return (float)ACRE_ERROR;
    }
}

uint8_t *CTextMessage::getParameter(uint32_t index) {
    if (index > this->m_ParameterCount) {
        return NULL;
    } else {
        if (this->m_Parameters[index] == NULL)
            return NULL;
        else
            return((uint8_t *)this->m_Parameters[index]->c_str());
    }
}


CTextMessage::~CTextMessage(void)
{
    uint32_t x;

    for (x=0;x<TEXTMESSAGE_MAX_PARAMETER_COUNT;x++) {
        if (this->m_Parameters[x])
            delete this->m_Parameters[x];
    }

    if (this->m_RpcProcedureName)
        delete this->m_RpcProcedureName;
    if (this->m_Data)
        delete this->m_Data;
    if (this->m_DataPtr)
        free(this->m_DataPtr);
}
int8_t *CTextMessage::getProcedureName() {
    if (this->m_RpcProcedureName) {
        return (int8_t *)this->m_RpcProcedureName->c_str();
    } else {
        return NULL;
    }
}
IMessage *CTextMessage::formatNewMessage(int8_t *procedureName, int8_t *format, ... ) {
    int8_t buffer[TEXTMESSAGE_BUFSIZE];
    int8_t *finalBuffer;
    va_list va;
    CTextMessage *msg;

    msg = NULL;


    if (!procedureName) {
        LOG("procedureName was null");
        return NULL;
    }

    finalBuffer = (int8_t *) calloc((size_t) TEXTMESSAGE_BUFSIZE, sizeof(int8_t));
    if (!buffer) {
        // Windows routines
        //LOG("calloc() failed: %d", GetLastError());
        LOG("calloc() failed: %d", 0);
        return NULL;
    }

    buffer[0] = 0x00;
    snprintf(finalBuffer, TEXTMESSAGE_BUFSIZE, "%s:", procedureName);

    va_start(va, format);
    vsnprintf(buffer,sizeof(buffer), format, va);
    va_end(va);

    strncat(finalBuffer, buffer, TEXTMESSAGE_BUFSIZE);

    msg = new CTextMessage(finalBuffer, strlen(finalBuffer)+1);

    if (!msg->isValid()) {
        LOG("ERR: msg was invalid");
        delete msg;
        msg = NULL;
    }

    free(finalBuffer);

    return((IMessage *)msg);
}

IMessage *CTextMessage::createNewMessage(int8_t *procedureName, ... ) {
    int8_t *buffer, *ptr;
    va_list va;
    CTextMessage *msg;

    msg = NULL;

    if (!procedureName) {
        LOG("procedureName was null");
        return NULL;
    }

    buffer = (int8_t *) calloc ((size_t) TEXTMESSAGE_BUFSIZE, sizeof(int8_t));
    if (!buffer) {
        // Windows routines
        //LOG("calloc() failed: %d", GetLastError());
        LOG("calloc() failed: %d", 0);
        return NULL;
    }

    buffer[0] = 0x00;
    snprintf(buffer, TEXTMESSAGE_BUFSIZE, "%s:", procedureName);

    va_start(va, procedureName);
    ptr = va_arg( va, int8_t * );
    while (ptr != NULL) {
        strncat(buffer, ptr, TEXTMESSAGE_BUFSIZE);
        strncat(buffer, ",", TEXTMESSAGE_BUFSIZE);
        ptr = va_arg( va, int8_t * );
    }
    va_end(va);

    buffer = (int8_t *)realloc(buffer, strlen(buffer)+1);
    msg = new CTextMessage(buffer, strlen(buffer)+1);

    if (!msg->isValid()) {
        LOG("ERR: msg was invalid");
        delete msg;
        msg = NULL;
    }

    free(buffer);

    return((IMessage *)msg);
}
uint32_t CTextMessage::getParameterCount() {
    return (this->m_ParameterCount);
}
