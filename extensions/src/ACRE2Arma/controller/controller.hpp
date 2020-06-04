#pragma once

#include "shared.hpp"
#include "singleton.hpp"
#include "arguments.hpp"
#include "dispatch.hpp"


namespace acre {
    
    

    class controller 
        : public singleton<controller>,
        public threaded_dispatcher {
    public:
        controller();
        ~controller();

        
        bool init(const arguments &, std::string &);
        bool reset(const arguments &, std::string &);
        bool get_ready(const arguments &, std::string &);

        bool do_stop(const arguments &, std::string &) {
            stop();
            _worker.join();
            return true;
        };
    
    protected:
        bool _initiated;
    };

    
}

