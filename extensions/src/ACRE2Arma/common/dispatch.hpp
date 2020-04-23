#pragma once

#include <thread>
#include <mutex>
#include <atomic>
#include <queue>

#include "shared.hpp"
#include "arguments.hpp"
#include "singleton.hpp"

extern std::function<int(char const*, char const*, char const*)> callbackFunc;

namespace acre {
    class controller_module {
    public:
        controller_module() : _stopped(false) { };
        ~controller_module() { };
        void stop() {
            std::lock_guard<std::mutex> lock(_stop_lock);
            _stopped = true;
        }
        bool stopped() {
            std::lock_guard<std::mutex> lock(_stop_lock);
            return _stopped;
        }
    protected:
        std::mutex _stop_lock;

        bool _stopped;
    };

    class dispatcher {
    public:
        dispatcher() : _ready(true) { }

        virtual bool call(const std::string & name_, arguments & args_, std::string & result_string_, std::int32_t & result_code_) {
            if (_methods.find(name_) == _methods.end()) {
                // @TODO: Exceptions
                return false;
            }
            return _methods[name_](args_, result_string_, result_code_);
        }

        bool add(const std::string & name_, std::function<bool(arguments &, std::string &, int &)> func_) {
            if (_methods.find(name_) != _methods.end()) {
                // @TODO: Exceptions
                return false;
            }
            _methods[name_] = func_;

            return true;
        }

        bool ready() const { return _ready;  }
        void ready(bool r) { _ready.exchange(r); }
    protected:
        std::unordered_map < std::string, std::function<bool(arguments &, std::string &, int &)> > _methods;
        std::atomic_bool _ready;
    };

    class dispatch : public dispatcher, public singleton<dispatch> { };

    struct dispatch_message {
        dispatch_message(const std::string & command_, const arguments & args_, const uint64_t id_) : command(command_), args(args_), id(id_) {}
        std::string command;
        arguments args;
        uint64_t    id;
    };

    class threaded_dispatcher : public dispatcher {
    public:
        threaded_dispatcher() : _stop(false), _worker(&acre::threaded_dispatcher::monitor, this), _message_id(0) {

        }
        ~threaded_dispatcher() {}

        bool call(const std::string & name_, arguments & args_, std::string & result_string_, int & result_code_, bool threaded) {
            if (_methods.find(name_) == _methods.end()) {
                // @TODO: Exceptions
                return false;
            }
            if (threaded) {
                std::lock_guard<std::mutex> lock(_messages_lock);
                _messages.push(dispatch_message(name_, args_, _message_id));

                // @TODO: We should provide an interface for this serialization.
                std::stringstream ss;
                ss << "[\"result_id\", " << _message_id << "]";
                result_string_ = ss.str();
                result_code_ = static_cast<int>(_message_id++);
            } else {
#ifdef _DEBUG
                    LOG(TRACE) << "dispatch[immediate]:\t[" << name_ << "] { " << args_.to_string() << " }";
#endif
                return dispatcher::call(name_, args_, result_string_, result_code_);
            }

            return true;
        }
        bool call(const std::string & name_, arguments & args_, std::string & result_string_, int & result_code_) override {
            return call(name_, args_, result_string_, result_code_, false);
        }

        void stop() {
            for (auto module : _modules) {
                module->stop();
            }
            std::lock_guard<std::mutex> lock(_messages_lock);
            _stop = true;
        }

        void add_module(std::shared_ptr<controller_module> module_) {
            _modules.push_back(module_);
        }

    protected:
        void monitor() {
            while (!_stop) {

                bool empty = false;
                {
                    std::lock_guard<std::mutex> lock(_messages_lock);
                    empty = _messages.empty();
                }
                while (!empty) {
                    if (_ready) {
                        _messages_lock.lock();
                        dispatch_message _message = std::move(_messages.front());
                        _messages.pop();
                        _messages_lock.unlock();
 
#ifdef _DEBUG
                            LOG(TRACE) << "dispatch[threaded]:\t[" << _message.command << "]";
                            if (_message.args.size() > 0) {
                                // LOG(TRACE) << "\t{ " << _message.args.to_string() << " }";
                            }
#endif
                        std::string result_message;
                        std::int32_t result_code = -1;
                        dispatcher::call(_message.command, _message.args, result_message, result_code);
                        std::stringstream ss;
                        ss << "[" << _message.id << ",[" << result_message << "]]";

                        bool cbRecieved = false; // call back buffer can only hold 100 messages a frame (doubt acre will ever hit this limit)
                        while (!_stop && !cbRecieved) {
                            int cbBufferRemaining = callbackFunc("ACRE_TR", _message.command.c_str(), ss.str().c_str());
                            // LOG(TRACE) << "sending callback [id: " << _message.id << ", buffer: " << cbBufferRemaining << "]";
                            if (cbBufferRemaining > -1) {
                                cbRecieved = true;
                            } else {
                                sleep(5);
                            }
                        }

                        {
                            std::lock_guard<std::mutex> lock(_messages_lock);
                            empty = _messages.empty();
                        }
                    }
                }
                sleep(5);
            }
        }
        std::atomic_bool                _stop;

        std::queue<dispatch_message>    _messages;
        std::mutex                      _messages_lock;

        std::thread                     _worker;

        uint64_t                        _message_id;

        std::vector<std::shared_ptr<controller_module>> _modules;
    };
    class threaded_dispatch : public threaded_dispatcher, public singleton<dispatch> { };
};
