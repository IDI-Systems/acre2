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

    acre_result_t readLoop();
    acre_result_t sendLoop();

    acre_result_t initialize( void );
    acre_result_t shutdown( void );

    acre_result_t handleMessage(unsigned char *data) { data=data;return acre_result_notImplemented; }

    acre_result_t sendMessage( IMessage *message );

    acre_result_t release( void ) { return acre_result_ok; };
    
    acre_result_t checkServer( void ); // DRM

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