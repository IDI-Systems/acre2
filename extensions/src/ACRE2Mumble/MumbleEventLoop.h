#pragma once

#include <functional>
#include <deque>
#include <mutex>
#include <condition_variable>
#include <thread>

namespace acre {

    class MumbleEventLoop {
    public:
        MumbleEventLoop();

        static MumbleEventLoop& getInstance();

        void stop();

        void queue(const std::function<void()>& callable);
        void queue(std::function<void()>&& callable);

    protected:
        std::mutex m_lock;
        std::condition_variable m_waiter;
        bool m_keepRunning = true;
        std::deque<std::function<void()>> m_queuedFunctions;
        std::thread m_thread;

        void run();
    };

}
