#include "MumbleEventLoop.h"

#include <Tracy.hpp>

namespace acre {

    MumbleEventLoop& MumbleEventLoop::getInstance() {
        static MumbleEventLoop loop;

        return loop;
    }

    MumbleEventLoop::MumbleEventLoop() {
    }

    void MumbleEventLoop::start() {
        if (m_thread.joinable()) {
            throw std::runtime_error("ACRE2 - MumbleEventLoop: Attempted to start already-running event loop. Must call stop first.");
        }

        {
            std::lock_guard<LockableBase(std::mutex)> guard(m_lock);
            m_keepRunning = true;
        }

        m_thread = std::thread(&MumbleEventLoop::run, this);
    }

    void MumbleEventLoop::stop() {
        ZoneScoped;

        {
            std::lock_guard<LockableBase(std::mutex)> guard(m_lock);
            m_keepRunning = false;
            m_drain       = true;

            m_waiter.notify_all();
        }

        if (m_thread.joinable()) {
            // Wait until the worker thread has finished
            m_thread.join();
        }
    }

    void MumbleEventLoop::queue(const std::function<void()>& callable) {
        ZoneScoped;

        std::lock_guard<LockableBase(std::mutex)> guard(m_lock);

        m_queuedFunctions.push_back(callable);

        m_waiter.notify_all();
    }

    void MumbleEventLoop::queue(std::function<void()>&& callable) {
        ZoneScoped;

        std::unique_lock<LockableBase(std::mutex)> guard(m_lock);

        m_queuedFunctions.push_back(std::move(callable));

        m_waiter.notify_all();
    }

    void MumbleEventLoop::run() {
        tracy::SetThreadName("ACRE2-Mumble-EventLoop");

        std::unique_lock<LockableBase(std::mutex)> guard(m_lock);

        const char *frameName = "ACRE2 MumbleEventLoop";
        while (m_keepRunning || m_drain) {
            FrameMarkStart(frameName);

            m_drain = false;

            // Process all pending events
            while (!m_queuedFunctions.empty()) {
                std::function<void()> currentFunc = std::move(m_queuedFunctions.front());
                m_queuedFunctions.pop_front();

                // Execute the current funtion. However, during the time this function is executing, there is no need to
                // keep holding m_lock. By releasing it for that time, we allow further functions to be queued by other threads.
                // This gets especially important if the called function will call a Mumble API function. This function will require
                // to run in Mumble's main thread but if that thread is in turn waiting until a new event is queued (in one of the
                // plugin callbacks in this plugin), we end up with a deadlock.
                guard.unlock();
                currentFunc();
                guard.lock();
            }

            FrameMarkEnd(frameName);

            if (!m_keepRunning) {
                break;
            }

            // Wait for something to happen. Note that during the waiting the lock is released and
            // re-aquired once the waiting ends
            m_waiter.wait(guard);
        }
    }
}
