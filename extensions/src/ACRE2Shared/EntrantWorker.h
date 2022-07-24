#pragma once

#include "Types.h"
#include "Lockable.h"
#include "Macros.h"

#include <queue>
#include <thread>

#include <Tracy.hpp>

template<typename T> class TEntrantWorker : public CLockable {
public:
    TEntrantWorker() {
        this->setRunning(false);
    }
    ~TEntrantWorker() {

    }

    acre::Result startWorker(void) {
        ZoneScoped;

        LOCK(this);
        setShuttingDown(false);
        std::queue<T>().swap(m_processQueue); // Clear the queue
        m_workerThread = std::thread(&TEntrantWorker::exWorkerThread, this);
        setRunning(true);
        UNLOCK(this);
        return acre::Result::ok;
    }

    acre::Result stopWorker(void) {
        ZoneScoped;
        
        setShuttingDown(true);
        setRunning(false);
        if (m_workerThread.joinable()) {
            m_workerThread.join();
        }
        LOCK(this)
        std::queue<T>().swap(m_processQueue); // Clear the queue
        UNLOCK(this);
        setShuttingDown(false);

        return acre::Result::ok;
    }

    acre::Result exWorkerThread() {
        while (!getShuttingDown()) {
            LOCK(this);
            if (!m_processQueue.empty()) {
                const T item = m_processQueue.front();
                m_processQueue.pop();
                exProcessItem(item);
            }
            UNLOCK(this);
            Sleep(1);
        }
        return acre::Result::ok;
    }

    virtual acre::Result exProcessItem(T) = 0;

    virtual inline void setShuttingDown(const bool value) { m_shuttingDown = value; }
    virtual inline bool getShuttingDown() const { return m_shuttingDown; }
    virtual inline void setRunning(const bool value) { m_running = value; }
    virtual inline bool getRunning() const { return m_running; }

protected:
    std::thread m_workerThread;
    std::queue<T> m_processQueue;

    bool m_shuttingDown;
    bool m_running;
};
