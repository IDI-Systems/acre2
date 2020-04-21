#include "controller.hpp"
#include "simulation/object.hpp"
#include "antenna\antenna_library.hpp"
#include "signal.hpp"
#include <chrono>

#ifdef _DEBUG
#define DEBUG_DISPATCH(x, y) { std::string empty; _debug_display->call(x, arguments(y), empty); }
#else
#define DEBUG_DISPATCH(x, y)
#endif

namespace acre {
    controller::controller() : threaded_dispatcher() {
        add("init", std::bind(&acre::controller::init, this, std::placeholders::_1, std::placeholders::_2));
        add("reset", std::bind(&acre::controller::reset, this, std::placeholders::_1, std::placeholders::_2));
        add("ready", std::bind(&acre::controller::get_ready, this, std::placeholders::_1, std::placeholders::_2));
        add("stop", std::bind(&controller::do_stop, this, std::placeholders::_1, std::placeholders::_2));
        _initiated = false;
        _ready = true;
    }
    controller::~controller() { }

    bool controller::init(const arguments &_args, std::string & result) {
        if (!_initiated) {
            _initiated = true;
            acre::pbo::fileloader::get().poke();
            add_module(std::make_shared<acre::signal::controller>());
        }
        return true;
    }

    bool controller::get_ready(const arguments &_args, std::string & result) {
        result = "0";

        if (!_ready)
            result = "-1";

        return true;
    }

    bool controller::reset(const arguments &_args, std::string & result) {
        _ready = false;


        { 
            std::lock_guard<std::mutex> lock_results(_messages_lock);

            while (!_messages.empty()) {
                _messages.pop();
            }
        }

        _ready = true;

        return true;
    }
}

