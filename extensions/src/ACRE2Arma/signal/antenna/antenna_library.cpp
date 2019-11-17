#include "antenna_library.hpp"
#include "../../common/pbo/fileloader.hpp"

bool acre::signal::antenna_library::load_antenna(std::string antenna_name_, std::string antenna_path_) {
    auto entry = _library.find(antenna_name_);
    if (entry == _library.end()) {
        acre::pbo::file_entry_p antenna_entry;
        if (acre::pbo::fileloader::get().get_file(antenna_path_, "aba", antenna_entry)) {
            _library[antenna_name_] = std::make_shared<antenna>(antenna_entry->stream());
            return true;
        }
        return false;
    }
    return true;
};


bool acre::signal::antenna_library::get_antenna(std::string antenna_name_, antenna_p &antenna_) {
    auto entry = _library.find(antenna_name_);
    if (entry != _library.end()) {
        antenna_ = entry->second;
        return true;
    }
    return false;
};
