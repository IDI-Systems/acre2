#pragma once

#include "shared.hpp"
#include "glm\vec3.hpp"
#include "glm\vec2.hpp"
#include "singleton.hpp"
#include "pbo\search.hpp"
#include "membuf.hpp"
#include "wrp\landscape.hpp"
#include "pbo\fileloader.hpp"
#include "antenna\antenna.hpp"

namespace acre {
	namespace signal {
		class antenna_library : public singleton<antenna_library> {
		public:
			antenna_library() {};
			~antenna_library() {};
			bool load_antenna(std::string antenna_name_, std::string antenna_path_) {
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
			bool get_antenna(std::string antenna_name_, antenna_p &antenna_) {
				auto entry = _library.find(antenna_name_);
				if (entry != _library.end()) {
					antenna_ = entry->second;
					return true;
				}
				return false;
			};
		protected:
			std::map<std::string, antenna_p> _library;
		};
	}
}