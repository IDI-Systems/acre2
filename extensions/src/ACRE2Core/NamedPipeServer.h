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

    acre::Result readLoop();
    acre::Result sendLoop();

    acre::Result initialize( void );
    acre::Result shutdown( void );

    acre::Result handleMessage(unsigned char *data) { (void) data; return acre::Result::notImplemented; }

    acre::Result sendMessage( IMessage *message );

    acre::Result release( void ) { return acre::Result::ok; };
    
    acre::Result checkServer( void ); // DRM

    char *currentServerId;

    DECLARE_MEMBER(HANDLE, PipeHandleRead);
    DECLARE_MEMBER(HANDLE, PipeHandleWrite);
    DECLARE_MEMBER(std::string, FromPipeName);
    DECLARE_MEMBER(std::string, ToPipeName);

    __inline void setConnectedWrite(const bool value) { m_connectedWrite = value; }
    __inline bool getConnectedWrite() const { return m_connectedWrite; }

    __inline void setConnectedRead(const bool value) { m_connectedRead = value; }
    __inline bool getConnectedRead() const { return m_connectedRead; }

    __inline void setShuttingDown(const bool value) { m_shuttingDown = value; }
    __inline bool getShuttingDown() const { return m_shuttingDown; }

    __inline void setId(const acre::id_t value) final { m_id = value; }
    __inline acre::id_t getId() const final { return m_id; }

    bool getConnected() const final { return (getConnectedRead() && getConnectedWrite()); };
    void setConnected(bool value) final { setConnectedRead(value); setConnectedWrite(value); };

protected:
    acre::id_t m_id;
    bool       m_connectedWrite;
    bool       m_connectedRead;
    bool       m_shuttingDown;

private:
    Concurrency::concurrent_queue<IMessage *> m_sendQueue;
    std::thread m_readThread;
    std::thread m_sendThread;
    PSECURITY_ATTRIBUTES m_PipeSecurity;
    std::set<std::string> validTSServers;       
};
