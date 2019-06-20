#pragma once

#include "compat.h"
#include "Types.h"
#include "Lockable.h"
#include "Macros.h"

#include <concurrent_queue.h>
#include <thread>

template<typename T> class TEntrantWorker : public CLockable {
public:
    TEntrantWorker() {
        this->setRunning(false);
    }
    ~TEntrantWorker() {
    
    }
    acre::Result startWorker(void) {
        LOCK(this);
        setShuttingDown(false);
        m_processQueue.clear();
        m_workerThread = std::thread(&TEntrantWorker::exWorkerThread, this);
        setRunning(true);
        UNLOCK(this);
        return acre::Result::ok;
    }

    acre::Result stopWorker(void) {
        setShuttingDown(true);
        setRunning(false);
        if (m_workerThread.joinable()) {
            m_workerThread.join();
        }
        LOCK(this)
        m_processQueue.clear();
        UNLOCK(this);
        setShuttingDown(false);
        
        return acre::Result::ok;
    }

    acre::Result exWorkerThread() {
        T item;
        while (!getShuttingDown()) {
            LOCK(this);
            if (m_processQueue.try_pop(item)) {    
                exProcessItem(item);
            }
            UNLOCK(this);
            Sleep(1);
        }
        return acre::Result::ok;
    }

    virtual acre::Result exProcessItem(T) = 0;

    virtual __inline void setShuttingDown(const bool value) { m_shuttingDown = value; }
    virtual __inline bool getShuttingDown() const { return m_shuttingDown; }
    virtual __inline void setRunning(const bool value) { m_running = value; }
    virtual __inline bool getRunning() const { return m_running; }

protected:
    std::thread m_workerThread;
    Concurrency::concurrent_queue<T> m_processQueue;

    bool m_shuttingDown;
    bool m_running;
};
