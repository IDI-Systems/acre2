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
    CNamedPipeServer(const std::string fromPipeName, const std::string toPipeName);
    ~CNamedPipeServer(void);

    ACRE_RESULT readLoop();
    ACRE_RESULT sendLoop();

    ACRE_RESULT initialize( void );
    ACRE_RESULT shutdown( void );

    ACRE_RESULT handleMessage(unsigned char *data) { data=data; return ACRE_NOT_IMPL; }

    ACRE_RESULT sendMessage( IMessage *message );

    ACRE_RESULT release( void ) { return ACRE_OK; };

    ACRE_RESULT checkServer( void ); // DRM

    char *currentServerId;

    bool getConnected() const { return (this->getConnectedRead() && this->getConnectedWrite()); };
    void setConnected (const bool value) { this->setConnectedRead(value); this->setConnectedWrite(value); };

    virtual __inline void setPipeHandleRead(const HANDLE value) { this->m_pipeHandleRead = value; }
    virtual __inline HANDLE getPipeHandleRead() const { return this->m_pipeHandleRead; }

    virtual __inline void setPipeHandleWrite(const HANDLE value) { this->m_pipeHandleWrite = value; }
    virtual __inline HANDLE getPipeHandleWrite() const { return this->m_pipeHandleWrite; }

    virtual __inline void setConnectedWrite(const bool value) { this->m_connectedWrite = value; }
    virtual __inline bool getConnectedWrite() const { return this->m_connectedWrite; }

    virtual __inline void setConnectedRead(const bool value) { this->m_connectedRead = value; }
    virtual __inline bool getConnectedRead() const { return this->m_connectedRead; }

    virtual __inline void setId (const ACRE_ID value) { this->m_id = value; }
    virtual __inline ACRE_ID getId() const { return this->m_id; }

    virtual __inline void setShuttingDown(const bool value) { this->m_shuttingDown = value; }
    virtual __inline bool getShuttingDown() const { return this->m_shuttingDown; }

    virtual __inline void setFromPipeName(const std::string value) { this->m_fromPipeName = value; }
    virtual __inline std::string getFromPipeName() const { return this->m_fromPipeName; }

    virtual __inline void setToPipeName(const std::string value) { this->m_toPipeName = value; }
    virtual __inline std::string getToPipeName() const { return this->m_toPipeName; }

protected:
    HANDLE m_pipeHandleRead;
    HANDLE m_pipeHandleWrite;
    bool m_connectedWrite;
    bool m_connectedRead;
    ACRE_ID m_id;
    bool m_shuttingDown;
    std::string m_fromPipeName;
    std::string m_toPipeName;

private:
    Concurrency::concurrent_queue<IMessage *> m_sendQueue;
    std::thread m_readThread;
    std::thread m_sendThread;
    PSECURITY_ATTRIBUTES m_PipeSecurity;
    std::set<std::string> validTSServers;

};
