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

    AcreResult readLoop();
    AcreResult sendLoop();

    AcreResult initialize( void );
    AcreResult shutdown( void );

    AcreResult handleMessage(unsigned char *data) { data=data;return AcreResult::notImplemented; }

    AcreResult sendMessage( IMessage *message );

    AcreResult release( void ) { return AcreResult::ok; };
    
    AcreResult checkServer( void ); // DRM

    char *currentServerId;

    DECLARE_MEMBER(HANDLE, PipeHandleRead);
    DECLARE_MEMBER(HANDLE, PipeHandleWrite);
    DECLARE_MEMBER(BOOL, ConnectedWrite);
    DECLARE_MEMBER(BOOL, ConnectedRead)
    DECLARE_MEMBER(acre_id_t, Id);
    DECLARE_MEMBER(BOOL, ShuttingDown);
    DECLARE_MEMBER(std::string, FromPipeName);
    DECLARE_MEMBER(std::string, ToPipeName);

public:
    BOOL getConnected() { return (this->getConnectedRead() && this->getConnectedWrite()); };
    void setConnected(BOOL value) { this->setConnectedRead(value); this->setConnectedWrite(value); };
private:
    Concurrency::concurrent_queue<IMessage *> m_sendQueue;
    std::thread m_readThread;
    std::thread m_sendThread;
    PSECURITY_ATTRIBUTES m_PipeSecurity;
    std::set<std::string> validTSServers;
    
};