#include "NamedPipeServer.h"
#include "TextMessage.h"
#include "Log.h"
#include "Engine.h"

#ifdef WIN32
#include <sddl.h>
#else
#include <time.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <netinet/ip.h>
#endif

#ifdef WIN32
typedef clock_t walltime_t;
#else
typedef timespec walltime_t;
#endif

CNamedPipeServer::CNamedPipeServer(std::string fromPipeName, std::string toPipeName) {
    this->setConnectedWrite(false);
    this->setConnectedRead(false);
    this->setShuttingDown(false);

#ifdef WIN32
    this->setPipeHandleWrite(INVALID_HANDLE_VALUE);
    this->setPipeHandleRead(INVALID_HANDLE_VALUE);
    this->setFromPipeName(fromPipeName);
    this->setToPipeName(toPipeName);
#endif
}

CNamedPipeServer::~CNamedPipeServer( void ) {
    this->shutdown();
}

walltime_t getMonotime() {
#ifdef WIN32
    return clock();
#else
    walltime_t ret;
    clock_gettime(CLOCK_MONOTONIC_RAW, &ret);
    return ret;
#endif
}

long diffMonotime(walltime_t current, walltime_t previous) {
#ifdef WIN32
    return ((current - previous) * 1000) / CLOCKS_PER_SEC;
#else
    time_t s = (current.tv_sec - previous.tv_sec);
    time_t ms = (time_t) ((current.tv_nsec - previous.tv_nsec) / 1000000);
    return s * 1000 + ms;
#endif
}

acre::Result CNamedPipeServer::initialize() {
#ifdef WIN32
    HANDLE writeHandle, readHandle;

    SECURITY_DESCRIPTOR sd;
    if (!InitializeSecurityDescriptor(&sd, SECURITY_DESCRIPTOR_REVISION)) { LOG("InitializeSecurityDescriptor Error : %u", GetLastError()); }
    if (!SetSecurityDescriptorDacl(&sd, TRUE, nullptr, FALSE)) { LOG("SetSecurityDescriptorDacl Error : %u", GetLastError()); }
    if (!SetSecurityDescriptorControl(&sd, SE_DACL_PROTECTED, SE_DACL_PROTECTED)) { LOG("SetSecurityDescriptorControl Error : %u", GetLastError()); }
    SECURITY_ATTRIBUTES sa = { sizeof(SECURITY_ATTRIBUTES), &sd, true };
#endif

    // open our pipe handle, then kick up a thread to monitor it and add shit to our queue
    // this end LISTENS and CREATES the pipe
    LOG("Opening game pipe...");
    bool tryAgain = true;

#ifdef WIN32
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
                &sa
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
                &sa // use default security attributes
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
#else
    this->m_sockFD = socket(AF_INET, SOCK_STREAM, 0);

    const struct sockaddr_in listenAddr = {
        .sin_family = AF_INET,
        .sin_port = htons(acreListenPort),
        .sin_addr = {
            htonl(INADDR_LOOPBACK)
        }
    };

    int param = 1;
    setsockopt(this->m_sockFD, SOL_SOCKET, SO_REUSEADDR, &param, sizeof(int));
    int ret = bind(this->m_sockFD, (struct sockaddr *) &listenAddr, sizeof(listenAddr));

    if(ret) {
      LOG("Could not bind to port %d, error %d", acreListenPort, errno);
      return acre::Result::error;
    }

    LOG("Bound on port %d", acreListenPort);

    ret = listen(this->m_sockFD, 1);
    if (ret) {
      LOG("Could not listen on port %d, error %d", acreListenPort, errno);
      return acre::Result::error;
    }

    this->m_readThread = std::thread(&CNamedPipeServer::readLoop, this);
    this->m_sendThread = std::thread(&CNamedPipeServer::sendLoop, this);
#endif

    return acre::Result::ok;
}

acre::Result CNamedPipeServer::shutdown(void) {
    this->setShuttingDown(true);

    this->setConnectedWrite(false);
    this->setConnectedRead(false);

#ifdef WIN32
    HANDLE hPipe;
    //Wake the synchronous named pipe
    //Called from the same process but from a different thread
    hPipe = CreateFile(this->getToPipeName().c_str(), GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, NULL, OPEN_EXISTING, 0, NULL);
    if (hPipe != INVALID_HANDLE_VALUE) {
        DisconnectNamedPipe(hPipe);
        CloseHandle(hPipe);
    }
#else
    ::shutdown(this->m_sockFD, SHUT_RDWR);
    close(this->m_sockFD);
#endif

    // Read should initiate the full shutdown, so we wait for him to die first and we only wake him.
    if (this->m_readThread.joinable()) {
        this->m_readThread.join();
    }

#ifdef WIN32
    // Now we wake the write pipe just in case.
    hPipe = CreateFile(this->getFromPipeName().c_str(), GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, NULL, OPEN_EXISTING, 0, NULL);
    if (hPipe != INVALID_HANDLE_VALUE) {
        DisconnectNamedPipe(hPipe);
        CloseHandle(hPipe);
    }
#endif

    if (this->m_sendThread.joinable()) {
        this->m_sendThread.join();
    }

    this->setShuttingDown(false);

    return acre::Result::ok;
}

acre::Result CNamedPipeServer::sendLoop() {
#ifdef WIN32
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

        walltime_t lastTick = getMonotime();
        while (this->getConnectedWrite()) {
            if (this->getShuttingDown())
                break;

            walltime_t tick = getMonotime();
            if (diffMonotime(tick, lastTick) > PIPE_TIMEOUT) {
                LOG("No send message for %d seconds, disconnecting", (PIPE_TIMEOUT / 1000));
                this->setConnectedWrite(false);
                break;
            }

            IMessage *msg = nullptr;
            if (this->m_sendQueue.try_pop(msg)) {
                if (msg != nullptr) {
                    lastTick = getMonotime();
                    const DWORD size = (uint32_t)strlen((char *)msg->getData()) + 1;
                    if (size > 3) {
                        DWORD cbWritten = 0;
                        // send it and free it
                        //LOCK(this);
                        this->lock();
                        const bool ret = WriteFile(
                            this->m_PipeHandleWrite,     // pipe handle
                            msg->getData(),                    // message
                            size,                    // message length
                            &cbWritten,             // bytes written
                            NULL);                  // not overlapped
                        this->unlock();

                        if (!ret) {
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
        const bool ret = DisconnectNamedPipe(this->m_PipeHandleWrite);
        Sleep(1);
    }
    TRACE("Sending thread terminating");

    return acre::Result::ok;
#else
    ssize_t bufferHead, len;
    while (!this->getShuttingDown()) {
        CEngine::getInstance()->getSoundEngine()->onClientGameConnected();
        while(!this->getConnectedWrite() && !this->getShuttingDown()) {
            Sleep(1);
        }

        walltime_t lastTick = getMonotime();
        while (this->getConnectedWrite()) {
            if (this->getShuttingDown()) {
                break;
            }

            walltime_t tick = getMonotime();
            if (diffMonotime(tick, lastTick) > PIPE_TIMEOUT) {
                LOG("No send message for %d seconds, disconnecting", (PIPE_TIMEOUT / 1000));
                this->setConnectedWrite(false);
                break;
            }

            IMessage *msg = nullptr;
            if (this->m_sendQueue.try_pop(msg)) {
                if (msg != nullptr) {
                    lastTick = getMonotime();
                    const uint32_t msgSize = (uint32_t)strlen((char *)msg->getData());
                    const uint32_t size = msgSize + 4;
                    char writeBuffer[size];
                    strncpy(writeBuffer + 4, (char *)msg->getData(), strlen((char *) msg->getData()));
                    writeBuffer[0] = (char) (msgSize >> 24);
                    writeBuffer[1] = (char) (msgSize >> 16);
                    writeBuffer[2] = (char) (msgSize >> 8);
                    writeBuffer[3] = (char) (msgSize);
                    if (size > 3) {
                        //LOCK(this);
                        this->lock();
                        bufferHead = 0;
                        while (bufferHead < size) {
                            len = write(this->m_clientFD, writeBuffer + bufferHead, size - bufferHead);
                            bufferHead += len;
                            if (len == -1) {
                                LOG("Error when writing to socket: %d", errno);
                                this->setConnectedWrite(false);
                            };
                        };
                        this->unlock();
                    }
                    delete msg;
                }
            }
            Sleep(1);
        }
        LOG("Write loop disconnected");
        Sleep(1);
    }
    TRACE("Sending thread terminating");

    return acre::Result::ok;
#endif
}

acre::Result CNamedPipeServer::readLoop() {
#ifdef WIN32
    DWORD cbRead;

    char *mBuffer = (char *)LocalAlloc(LMEM_FIXED, BUFSIZE);
    if (mBuffer == nullptr) {
        LOG("LocalAlloc() failed: %d", GetLastError());
    }
    /*
    this->validTSServers.insert(std::string("enter a ts3 server id here"));
    */
    while (!this->getShuttingDown()) {
        //this->checkServer();
        bool ret = ConnectNamedPipe(this->m_PipeHandleRead, NULL);
        if (GetLastError() == ERROR_PIPE_CONNECTED) {
            LOG("Client read connected");
            CEngine::getInstance()->getClient()->updateShouldSwitchChannel(false);
            CEngine::getInstance()->getClient()->unMuteAll();
            CEngine::getInstance()->getSoundEngine()->onClientGameConnected();
            this->setConnectedRead(true);
        } else {
            this->setConnectedRead(false);
            Sleep(1);

            continue;
        }
        walltime_t lastTick = getMonotime();
        while (this->getConnectedRead()) {
            //this->checkServer();
            if (this->getShuttingDown()) {
                break;
            }

            walltime_t tick = getMonotime();
            //LOG("[%d] - [%d] = [%d] vs. [%d]", tick, lastTick, (tick - lastTick),(PIPE_TIMEOUT / 1000));
            if (diffMonotime(tick, lastTick) > PIPE_TIMEOUT) {
                LOG("No read message for %d seconds, disconnecting", (PIPE_TIMEOUT / 1000));
                this->setConnectedWrite(false);
                this->setConnectedRead(false);
                break;
            }

            //Run channel switch to server channel
            if (CEngine::getInstance()->getClient()->shouldSwitchChannel()) {
                CEngine::getInstance()->getClient()->moveToServerChannel();
            }

            ret = false;
            do {
                ret = ReadFile(this->m_PipeHandleRead, mBuffer, BUFSIZE - 1, &cbRead, NULL); // -1 for null-byte below
                if (!ret && GetLastError() != ERROR_MORE_DATA) {
                    break;
                } else if (!ret && GetLastError() == ERROR_BROKEN_PIPE) {
                    this->setConnectedRead(false);
                    break;
                }
                // handle the packet and run it
                mBuffer[cbRead] = 0x00;
                //LOG("READ: %s", (char *)mBuffer);
                IMessage *const msg = new CTextMessage((char *)mBuffer, cbRead);
                //TRACE("got and parsed message [%s]", msg->getData());
                if (msg != nullptr && msg->getProcedureName()) {

                    // Do not free msg, this is deleted inside runProcedure()
                    CEngine::getInstance()->getRpcEngine()->runProcedure(this, msg);

                    lastTick = getMonotime();
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
        CEngine::getInstance()->getClient()->moveToPreviousChannel();
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

    return acre::Result::ok;
#else
    char *mBuffer = (char *)calloc(1, BUFSIZE);
    if (mBuffer == nullptr) {
        LOG("calloc failed: %d", errno);
    }

    LOG("starting read loop");

    ssize_t bufferHead;
    ssize_t len;
    unsigned char lengthBuffer[4];
    fd_set readfds;

    while (!this->getShuttingDown()) {
        FD_ZERO(&readfds);
        FD_SET(this->m_sockFD, &readfds);
        struct timeval tv = {
            .tv_sec = 0,
            .tv_usec = 50000
        };

        if (select(this->m_sockFD + 1, &readfds, NULL, NULL, &tv) == 0) {
            continue;
        }

        this->m_clientFD = accept(this->m_sockFD, NULL, NULL);
        if (this->m_clientFD != -1) {
            LOG("Client connected");
            CEngine::getInstance()->getClient()->updateShouldSwitchChannel(false);
            CEngine::getInstance()->getClient()->unMuteAll();
            CEngine::getInstance()->getSoundEngine()->onClientGameConnected();
            this->setConnectedRead(true);
            this->setConnectedWrite(true);
        } else {
            this->setConnectedRead(false);
            this->setConnectedWrite(false);
            Sleep(1);

            continue;
        }
        walltime_t lastTick = getMonotime();
        while (this->getConnectedRead()) {
            if (this->getShuttingDown()) {
                break;
            }

            walltime_t tick = getMonotime();
            if (diffMonotime(tick, lastTick) > PIPE_TIMEOUT) {
                LOG("No read message for %d seconds, disconnecting", (PIPE_TIMEOUT / 1000));
                this->setConnectedWrite(false);
                this->setConnectedRead(false);
                break;
            }

            //Run channel switch to server channel
            if (CEngine::getInstance()->getClient()->shouldSwitchChannel()) {
                CEngine::getInstance()->getClient()->moveToServerChannel();
            }

            // Read exactly four bytes for the message length
            bufferHead = 0;
            while(bufferHead < 4) {
                len = read(this->m_clientFD, (&lengthBuffer) + bufferHead, 4 - bufferHead);
                if (len == 0) {
                    this->setConnectedRead(false);
                    goto clientClose;
                } else if (len == -1) {
                    LOG("Error when reading from socket: %d", errno);
                    this->setConnectedRead(false);
                    goto clientClose;
                };
                bufferHead += len;
            };
            uint32_t messageLength = (lengthBuffer[0] << 24) + (lengthBuffer[1] << 16) + (lengthBuffer[2] << 8) + lengthBuffer[3];

            if (messageLength > BUFSIZE - 1) {
                LOG("Received too-large message with size %d", messageLength);
                this->setConnectedWrite(false);
                this->setConnectedRead(false);
                break;
            }

            mBuffer[messageLength] = 0x00;

            bufferHead = 0;
            while(bufferHead < messageLength) {
                len = read(this->m_clientFD, (mBuffer) + bufferHead, messageLength - bufferHead);
                if (len == 0) {
                    this->setConnectedRead(false);
                    goto clientClose;
                } else if (len == -1) {
                    LOG("Error when reading from socket: %d", errno);
                    this->setConnectedRead(false);
                    goto clientClose;
                };
                bufferHead += len;
            };

            // handle the packet and run it
            mBuffer[messageLength] = 0x00;
            //LOG("READ: %s", (char *)mBuffer);
            IMessage *const msg = new CTextMessage((char *)mBuffer, messageLength);
            TRACE("got and parsed message [%s]", msg->getData());
            if (msg != nullptr && msg->getProcedureName()) {

                // Do not free msg, this is deleted inside runProcedure()
                CEngine::getInstance()->getRpcEngine()->runProcedure(this, msg);

                lastTick = getMonotime();
                //TRACE("tick [%d], [%s]",lastTick, msg->getData());
            }
            // wait 1ms for new msg so we dont hog cpu cycles
            Sleep(1);
        }

clientClose:
        this->setConnectedWrite(false);
        this->setConnectedRead(false);
        close(this->m_clientFD);

        //Run channel switch to original channel
        CEngine::getInstance()->getClient()->moveToPreviousChannel();
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

    if (mBuffer) {
        free(mBuffer);
    }

    TRACE("Receiving thread terminating");

    return acre::Result::ok;
#endif
}

acre::Result CNamedPipeServer::sendMessage( IMessage *message ) {
    if (message) {
        TRACE("sending [%s]", message->getData());
        this->m_sendQueue.push(message);
        return acre::Result::ok;
    } else {
        return acre::Result::error;
    }
}

acre::Result CNamedPipeServer::checkServer( void ) {
    std::string uniqueId = CEngine::getInstance()->getClient()->getUniqueId();
    if (uniqueId != "" && this->validTSServers.find(uniqueId) == this->validTSServers.end()) {
#ifdef WIN32
        MessageBoxA(NULL, "This server is NOT registered for ACRE2 testing! Please remove the plugin! Teamspeak will now close.", "ACRE Error", MB_OK | MB_ICONEXCLAMATION);
        TerminateProcess(GetCurrentProcess(), 0);
#else
#endif
    }
    return acre::Result::ok;
}
