#pragma once
#include "compat.h"

#include <mutex>

class CLockable {
private:
    std::recursive_mutex m_lockable_mutex;
public:
    void lock() {
        m_lockable_mutex.lock();
    };

    void unlock() {
        m_lockable_mutex.unlock();
    };
};
