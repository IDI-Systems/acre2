#pragma once

#include "compat.h"
#include "Types.h"
#include "Lockable.h"
#include "Macros.h"

#include <concurrent_queue.h>
#include <thread>

template<typename T> class TEntrantWorker : public CLockable
{
public:
    TEntrantWorker() {
        this->setRunning(false);
    }
    ~TEntrantWorker() {

    }
    ACRE_RESULT startWorker(void) {
        LOCK(this);
        this->setShuttingDown(false);
        this->m_processQueue.clear();
        this->workerThread = std::thread(&TEntrantWorker::exWorkerThread, this);
        this->setRunning(true);
        UNLOCK(this);
        return ACRE_OK;
    }

    ACRE_RESULT stopWorker(void) {
        this->setShuttingDown(true);
        this->setRunning(false);
        if (this->workerThread.joinable()) {
            this->workerThread.join();
        }
        LOCK(this)
        this->m_processQueue.clear();
        UNLOCK(this);
        this->setShuttingDown(false);

        return ACRE_OK;
    }

    ACRE_RESULT exWorkerThread() {
        T item;
        while (!this->getShuttingDown()) {
            LOCK(this);
            if (this->m_processQueue.try_pop(item)) {
                this->exProcessItem(item);
            }
            UNLOCK(this);
            Sleep(1);
        }
        return ACRE_OK;
    }

    virtual ACRE_RESULT exProcessItem(T) = 0;
    DECLARE_MEMBER(bool, ShuttingDown);
    DECLARE_MEMBER(bool, Running);
protected:
    std::thread workerThread;
    Concurrency::concurrent_queue<T> m_processQueue;

};
