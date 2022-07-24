#pragma once

#include <functional>
#include <deque>
#include <mutex>
#include <condition_variable>
#include <thread>

#include <Tracy.hpp>

namespace acre {

    /**
     * This class represents a separate event loop that allows to process events in their own thread. This is needed, because
     * the synchronization of the Mumble API works by executing all API functions within Mumble's main thread, which also
     * happens to be the thread almost all plugin callbacks are called from. Thus, blocking these callbacks (e.g. due to waiting
     * on obtaining a lock) and simultaneously executing an API function from the thread that is the cause of the blocking (e.g.
     * because it is holding the mentioned lock) will yield a deadlock, since the API call will block until it can be executed
     * in Mumble's main thread, but the main thread is currently stuck in the plugin callback.
     * Mumble does have a mechanism built-in that prevents an actual deadlock from happening (using a timed-wait) but such calls
     * will still cause a lag in the program and will also cause the API call to fail (with a timeout error). Thus, these
     * situations should be avoided.
     * This is achieved by not executing the plugin callbacks synchronously but instead queuing them into this event loop for
     * async execution. Therefore Mumble's main thread will not be blocked and we avoid this entire situation.
     *
     * Note that when shutting the event loop down from within a plugin callback (typically the shutdown callback), the
     * abovementioned situation can still easily occur (since we have to wait for the event loop to end before returning
     * from that callback). However, due to Mumble's deadlock prevention, this shouldn't cause any major issues. It could lead to
     * small delays during shutdown, though (and some Mumble API calls failing under that circumstances).
     */
    class MumbleEventLoop {
    public:
        MumbleEventLoop();

        static MumbleEventLoop& getInstance();

        void start();
        void stop();

        void queue(const std::function<void()>& callable);
        void queue(std::function<void()>&& callable);

    protected:
        TracyLockable(std::mutex, m_lock);
        std::condition_variable_any m_waiter;
        bool m_keepRunning = true;
        bool m_drain       = false;
        std::deque<std::function<void()>> m_queuedFunctions;
        std::thread m_thread;

        void run();
    };

}
