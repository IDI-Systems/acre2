#pragma once
#include "compat.h"

#include <mutex>

#include <Tracy.hpp>

class CLockable {
private:
    TracyLockable(std::recursive_mutex, m_lockable_mutex);
public:
    void lock() {
        m_lockable_mutex.lock();
    };

    void unlock() {
        m_lockable_mutex.unlock();
    };
};
