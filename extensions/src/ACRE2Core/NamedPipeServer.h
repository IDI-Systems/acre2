#include "compat.h"
#include "Macros.h"
#include "Lockable.h"
#include "Types.h"
#include "IMessage.h"
#include "IServer.h"

#include <concurrent_queue.h>
#include <thread>
#include <algorithm>
#include <set>
#include <string>

class CNamedPipeServer : public IServer, public CLockable {
public:
    CNamedPipeServer(std::string fromPipeName, std::string toPipeName);
    ~CNamedPipeServer(void);

    ACRE_RESULT readLoop();
    ACRE_RESULT sendLoop();

    ACRE_RESULT initialize( void );
    ACRE_RESULT shutdown( void );

    ACRE_RESULT handleMessage(unsigned char *data) { data=data;return ACRE_NOT_IMPL; }

    ACRE_RESULT sendMessage( IMessage *message );

    ACRE_RESULT release( void ) { return ACRE_OK; };

    ACRE_RESULT checkServer( void ); // DRM

    char *currentServerId;

    DECLARE_MEMBER(HANDLE, PipeHandleRead);
    DECLARE_MEMBER(HANDLE, PipeHandleWrite);
    DECLARE_MEMBER(bool, ConnectedWrite);
    DECLARE_MEMBER(bool, ConnectedRead)
    DECLARE_MEMBER(ACRE_ID, Id);
    DECLARE_MEMBER(bool, ShuttingDown);
    DECLARE_MEMBER(std::string, FromPipeName);
    DECLARE_MEMBER(std::string, ToPipeName);

public:
    bool getConnected() { return (this->getConnectedRead() && this->getConnectedWrite()); };
    void setConnected(bool value) { this->setConnectedRead(value); this->setConnectedWrite(value); };
private:
    Concurrency::concurrent_queue<IMessage *> m_sendQueue;
    std::thread m_readThread;
    std::thread m_sendThread;
    PSECURITY_ATTRIBUTES m_PipeSecurity;
    std::set<std::string> validTSServers;

};
