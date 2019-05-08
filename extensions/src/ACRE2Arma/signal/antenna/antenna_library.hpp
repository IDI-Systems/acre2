#ifndef ANTENNA_ANTENNA_LIBRARY_HPP_
#define ANTENNA_ANTENNA_LIBRARY_HPP_

#include "antenna.hpp"

#include <string>
#include <map>

#include "singleton.hpp"

namespace acre {
    namespace signal {
        class antenna_library : public singleton<antenna_library> {
        public:
            antenna_library() {};
            ~antenna_library() {};
            bool load_antenna(std::string antenna_name_, std::string antenna_path_);
            bool get_antenna(std::string antenna_name_, antenna_p &antenna_);
        protected:
            std::map<std::string, antenna_p> _library;
        };
    }
}

#endif /* ANTENNA_ANTENNA_LIBRARY_HPP_ */
