#include "NamedPipeServer.h"
#include "TextMessage.h"
#include <sddl.h>
#include "Log.h"
#include "Engine.h"



    

CNamedPipeServer::CNamedPipeServer(std::string fromPipeName, std::string toPipeName) {
    this->setConnectedWrite(false);
    this->setConnectedRead(false);
    this->setPipeHandleWrite(INVALID_HANDLE_VALUE);
    this->setPipeHandleRead(INVALID_HANDLE_VALUE);
    this->setShuttingDown(false);

    this->setFromPipeName(fromPipeName);
    this->setToPipeName(toPipeName);
    
}

CNamedPipeServer::~CNamedPipeServer( void ) {
    this->shutdown();
}

ACRE_RESULT CNamedPipeServer::initialize() {
    HANDLE writeHandle, readHandle;

    //SECURITY_DESCRIPTOR SDWrite;
    //InitializeSecurityDescriptor(&SDWrite, SECURITY_DESCRIPTOR_REVISION);
    //SetSecurityDescriptorDacl(&SDWrite, true, NULL, false);
    //SECURITY_ATTRIBUTES SAWrite;
    //SAWrite.nLength = sizeof(SAWrite);
    //SAWrite.lpSecurityDescriptor = &SDWrite;
    //SAWrite.bInheritHandle = true;

    // Generate a low integrity access DACL
    SECURITY_ATTRIBUTES saWrite = { 0 };
    SECURITY_ATTRIBUTES *psaWrite = 0; psaWrite = &saWrite;
    saWrite.nLength = sizeof(SECURITY_ATTRIBUTES);
    saWrite.bInheritHandle = true;
    ConvertStringSecurityDescriptorToSecurityDescriptor(
        TEXT("S:(ML;;NWNR;;;LW)"), SDDL_REVISION_1, &saWrite.lpSecurityDescriptor, NULL);

    // open our pipe handle, then kick up a thread to monitor it and add shit to our queue
    // this end LISTENS and CREATES the pipe
    LOG("Opening game pipe...");
    bool tryAgain = true;

    while (tryAgain) {
        writeHandle = CreateNamedPipeA(
                this->getFromPipeName().c_str(), // name of the pipe
                PIPE_ACCESS_DUPLEX, 
                PIPE_TYPE_MESSAGE |        // message-type pipe 
                PIPE_READMODE_MESSAGE,    // send data as message
                PIPE_UNLIMITED_INSTANCES,
                4096, // no outbound buffer
                4096, // no inbound buffer
                0, // use default wait time
                psaWrite
            );
        if (writeHandle == INVALID_HANDLE_VALUE) {
            char errstr[1024];
            
            _snprintf_s(errstr, sizeof(errstr), "Conflicting game write pipe detected, could not create pipe!\nERROR CODE: %d", GetLastError());
            int ret = MessageBoxA(NULL, errstr, "ACRE Error", MB_RETRYCANCEL | MB_ICONEXCLAMATION);
            if (ret != IDRETRY) {
                tryAgain = false;
                TerminateProcess(GetCurrentProcess(), 0);
            }
        } else {
            tryAgain = false;
        }
    }

    // Generate a low integrity access DACL
    SECURITY_ATTRIBUTES saRead = { 0 };
    SECURITY_ATTRIBUTES *psaRead = 0; psaRead = &saRead;
    saRead.nLength = sizeof(SECURITY_ATTRIBUTES);
    saRead.bInheritHandle = true;
    ConvertStringSecurityDescriptorToSecurityDescriptor(
        TEXT("S:(ML;;NWNR;;;LW)"), SDDL_REVISION_1, &saRead.lpSecurityDescriptor, NULL);

    tryAgain = true;
    while (tryAgain) {
        readHandle = CreateNamedPipeA(
                this->getToPipeName().c_str(), // name of the pipe
                PIPE_ACCESS_DUPLEX, 
                PIPE_TYPE_MESSAGE |        // message-type pipe 
                PIPE_NOWAIT |            // Depricated but fuck it, it is simpler.
                PIPE_READMODE_MESSAGE,    // send data as message
                PIPE_UNLIMITED_INSTANCES, 
                4096, // no outbound buffer
                4096, // no inbound buffer
                0, // use default wait time
                psaRead // use default security attributes
            );
        if (readHandle == INVALID_HANDLE_VALUE) {
            char errstr[1024];
            
            _snprintf_s(errstr, sizeof(errstr), "Conflicting game read pipe detected, could not create pipe!\nERROR CODE: %d", GetLastError());
            int ret = MessageBoxA(NULL, errstr, "ACRE Error", MB_RETRYCANCEL | MB_ICONEXCLAMATION);
            if (ret != IDRETRY) {
                tryAgain = false;
                TerminateProcess(GetCurrentProcess(), 0);
            }
        } else {
            tryAgain = false;
        }
    }

    this->setPipeHandleRead(readHandle);
    this->setPipeHandleWrite(writeHandle);

    LOG("Game pipe opening successful. [%d & %d]", this->getPipeHandleRead(), this->getPipeHandleWrite());

    this->m_sendThread = std::thread(&CNamedPipeServer::sendLoop, this);
    this->m_readThread = std::thread(&CNamedPipeServer::readLoop, this);
    return ACRE_OK;
}

ACRE_RESULT CNamedPipeServer::shutdown(void) {
    HANDLE hPipe;

    this->setShuttingDown(true);

    this->setConnectedWrite(false);
    this->setConnectedRead(false);
    
    //Wake the synchronous named pipe
    //Called from the same process but from a different thread
    hPipe = CreateFile(this->getToPipeName().c_str(), GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, NULL, OPEN_EXISTING, 0, NULL);
    if (hPipe != INVALID_HANDLE_VALUE) {
        DisconnectNamedPipe(hPipe);
        CloseHandle(hPipe);
    }

    // Read should initiate the full shutdown, so we wait for him to die first and we only wake him.
    if (this->m_readThread.joinable()) {
        this->m_readThread.join();
    }

    // Now we wake the write pipe just in case.
    hPipe = CreateFile(this->getFromPipeName().c_str(), GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, NULL, OPEN_EXISTING, 0, NULL);
    if (hPipe != INVALID_HANDLE_VALUE) {
        DisconnectNamedPipe(hPipe);
        CloseHandle(hPipe);
    }

    if (this->m_sendThread.joinable()) {
        this->m_sendThread.join();
    }

    this->setShuttingDown(false);

    return ACRE_OK;
}

ACRE_RESULT CNamedPipeServer::sendLoop() {
    uint32_t cbWritten, size;
    IMessage *msg;
    bool ret;
    clock_t lastTick, tick;

    while (!this->getShuttingDown()) {
        
        do {
            ConnectNamedPipe(this->m_PipeHandleWrite, NULL);
            if (GetLastError() == ERROR_PIPE_CONNECTED) {    
                LOG("Client write connected");
                CEngine::getInstance()->getSoundEngine()->onClientGameConnected();
                this->setConnectedWrite(true);
                break;
            } else {
                this->setConnectedWrite(false);
                Sleep(1);
            }
        } while (!this->getConnectedWrite() && !this->getShuttingDown());

        lastTick = clock() / CLOCKS_PER_SEC;
        while (this->getConnectedWrite()) {
            if (this->getShuttingDown())
                break;

            tick = clock() / CLOCKS_PER_SEC;
            if (tick - lastTick > (PIPE_TIMEOUT / 1000)) {
                LOG("No send message for %d seconds, disconnecting", (PIPE_TIMEOUT / 1000));
                this->setConnectedWrite(false);
                break;
            }

            if (this->m_sendQueue.try_pop(msg)) {
                if (msg) {
                    lastTick = clock() / CLOCKS_PER_SEC;
                    size = (uint32_t)strlen((char *)msg->getData())+1;
                    if (size > 3) {
                        // send it and free it
                        //LOCK(this);
                        this->lock();
                        ret = WriteFile( 
                            this->m_PipeHandleWrite,     // pipe handle 
                            msg->getData(),                    // message 
                            size,                    // message length 
                            &cbWritten,             // bytes written 
                            NULL);                  // not overlapped 
                        this->unlock();

                        if ( ! ret) {
                            LOG("WriteFile failed, [%d]", GetLastError());
                            if (GetLastError() == ERROR_BROKEN_PIPE) {
                                this->setConnectedWrite(false);
                            }
                        }
                    }
                    delete msg;
                }
            }
            Sleep(1);
        }
        LOG("Write loop disconnected");
        FlushFileBuffers(this->m_PipeHandleWrite);
        ret = DisconnectNamedPipe(this->m_PipeHandleWrite);
        Sleep(1);
    }
    TRACE("Sending thread terminating");

    return ACRE_OK;
}

ACRE_RESULT CNamedPipeServer::readLoop() {
    uint32_t cbRead;
    IMessage *msg;
    bool ret;
    clock_t lastTick, tick;
    char *mBuffer;


    mBuffer = (char *)LocalAlloc(LMEM_FIXED, BUFSIZE);
    if (!mBuffer) {
        LOG("LocalAlloc() failed: %d", GetLastError());
    }
    /*
    this->validTSServers.insert(std::string("enter a ts3 server id here")); 
    */
    while (!this->getShuttingDown()) {
        //this->checkServer();
        ret = ConnectNamedPipe(this->m_PipeHandleRead, NULL);
        if (GetLastError() == ERROR_PIPE_CONNECTED) {    
            LOG("Client read connected");
            CEngine::getInstance()->getClient()->updateShouldSwitchTS3Channel(false);
            CEngine::getInstance()->getClient()->unMuteAll();
            CEngine::getInstance()->getSoundEngine()->onClientGameConnected();
            this->setConnectedRead(true);
        } else {
            this->setConnectedRead(false);
            Sleep(1);

            continue;
        }
        lastTick = clock() / CLOCKS_PER_SEC;
        while (this->getConnectedRead()) {
            //this->checkServer();
            if (this->getShuttingDown())
                break;

            tick = clock() / CLOCKS_PER_SEC;
            //LOG("[%d] - [%d] = [%d] vs. [%d]", tick, lastTick, (tick - lastTick),(PIPE_TIMEOUT / 1000));
            if (tick - lastTick > (PIPE_TIMEOUT / 1000)) {
                LOG("No read message for %d seconds, disconnecting", (PIPE_TIMEOUT / 1000));
                this->setConnectedWrite(false);
                this->setConnectedRead(false);
                break;
            }

            //Run channel switch to server channel
            if (CEngine::getInstance()->getClient()->shouldSwitchTS3Channel()) {
                CEngine::getInstance()->getClient()->moveToServerTS3Channel();
            }

            ret = false;
            do {
                ret = ReadFile(this->m_PipeHandleRead, mBuffer, BUFSIZE, &cbRead, NULL);
                if (!ret && GetLastError() != ERROR_MORE_DATA) {
                    break;
                } else if (!ret && GetLastError() == ERROR_BROKEN_PIPE) {
                    this->setConnectedRead(false);
                    break;
                }
                // handle the packet and run it
                mBuffer[cbRead]=0x00;
                //LOG("READ: %s", (char *)mBuffer);
                msg = new CTextMessage((char *)mBuffer, cbRead);    
                //TRACE("got and parsed message [%s]", msg->getData());
                if (msg && msg->getProcedureName()) {
                    
                    CEngine::getInstance()->getRpcEngine()->runProcedure(this, msg);

                    lastTick = clock() / CLOCKS_PER_SEC;
                    //TRACE("tick [%d], [%s]",lastTick, msg->getData());
                }
                // wait 1ms for new msg so we dont hog cpu cycles
            } while (!ret);
            //ret = ConnectNamedPipe(this->getPipeHandle(), NULL);    
            Sleep(1);
        }
        // Kill the write pipe along with ourselves, because we master shutdown/startup
        this->setConnectedWrite(false);
        this->setConnectedRead(false);
        FlushFileBuffers(this->m_PipeHandleRead);
        ret = DisconnectNamedPipe(this->m_PipeHandleRead);

        //Run channel switch to original channel
        CEngine::getInstance()->getClient()->moveToPreviousTS3Channel();
        CEngine::getInstance()->getSoundEngine()->onClientGameDisconnected();
        LOG("Client disconnected");
        CEngine::getInstance()->getClient()->unMuteAll();
        
        // Clear the send queue since client disconnected
        this->m_sendQueue.clear();
        
        // send an event that we have disconnected 
        if (CEngine::getInstance()->getExternalServer()->getConnected()) {
            CEngine::getInstance()->getExternalServer()->sendMessage(
                CTextMessage::formatNewMessage("ext_reset", 
                    "%d,",
                    CEngine::getInstance()->getSelf()->getId()
                ) 
            );
        } 
        Sleep(1);
    }
    
    if (mBuffer)
        LocalFree(mBuffer);

    TRACE("Receiving thread terminating");

    return ACRE_OK;
}

ACRE_RESULT CNamedPipeServer::sendMessage( IMessage *message ) {
    if (message) {
        TRACE("sending [%s]", message->getData());
        this->m_sendQueue.push(message);
        return ACRE_OK;
    } else {
        return ACRE_ERROR;
    }
}

ACRE_RESULT CNamedPipeServer::checkServer( void ) {
    std::string uniqueId = CEngine::getInstance()->getClient()->getUniqueId();
    if (uniqueId != "" && this->validTSServers.find(uniqueId) == this->validTSServers.end()) {
        MessageBoxA(NULL, "This server is NOT registered for ACRE2 testing! Please remove the plugin! Teamspeak will now close.", "ACRE Error", MB_OK | MB_ICONEXCLAMATION);
        TerminateProcess(GetCurrentProcess(), 0);
    }
    return ACRE_OK;
}
