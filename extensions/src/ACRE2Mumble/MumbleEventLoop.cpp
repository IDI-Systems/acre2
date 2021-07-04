#include "MumbleEventLoop.h"

namespace acre {

    MumbleEventLoop& MumbleEventLoop::getInstance() {
        static MumbleEventLoop loop;

        return loop;
    }

    MumbleEventLoop::MumbleEventLoop() : m_thread(&MumbleEventLoop::run, this) {
    }

    void MumbleEventLoop::stop() {
        {
            std::lock_guard<std::mutex> guard(m_lock);
            m_keepRunning = false;
        }

        m_waiter.notify_all();

        // Wait until the worker thread has finished
        m_thread.join();
    }

    void MumbleEventLoop::queue(const std::function<void()>& callable) {
        {
            std::lock_guard<std::mutex> guard(m_lock);

            m_queuedFunctions.push_back(callable);
        }

        m_waiter.notify_all();
    }

    void MumbleEventLoop::queue(std::function<void()>&& callable) {
        {
            std::unique_lock<std::mutex> guard(m_lock);

            m_queuedFunctions.push_back(std::move(callable));
        }

        m_waiter.notify_all();
    }

    void MumbleEventLoop::run() {
        std::unique_lock<std::mutex> guard(m_lock);

        while (m_keepRunning) {
            // Process all pending events
            while (!m_queuedFunctions.empty()) {
                std::function<void()> currentFunc = std::move(m_queuedFunctions.front());
                m_queuedFunctions.pop_front();

                currentFunc();
            }

            // Wait for something to happen. Note that during the waiting the lock is released and
            // re-aquired once the waiting ends
            m_waiter.wait(guard);
        }
    }
}
