#pragma once

#include "archive.hpp"
#include "search.hpp"
#include "singleton.hpp"
#include "membuf.hpp"


namespace acre {
	namespace pbo {
		class file_entry {
		public:
			file_entry() {};
			file_entry(file_p entry_) : _file(entry_) { 
				
				
				_memory_buffer = acre::membuf((char *)_file->data.get(), entry_->entry->storage_size);
				_stream = new std::istream(&_memory_buffer);
				
			};
			~file_entry() { delete _stream; };
			std::istream & stream() { return *_stream; };
		protected:
			file_p _file;
			acre::membuf _memory_buffer;
			std::istream *_stream;
		};
		typedef std::shared_ptr<file_entry> file_entry_p;

		class fileloader : public singleton<fileloader> {
		public:
			fileloader() {
				_pbo_searcher = std::make_shared<search>();
			};

			~fileloader() {

			};

			//@TODO: yea this is not the best way to do this...
			//Initialize the fileloader before threads start eating it.
			void poke() {
				return;
			}

			bool get_file(std::string path_, std::string _extension, file_entry_p &entry_) {
				std::string working_path = path_;
				// remove leading slash
				if (working_path.c_str()[0] == '\\')
					working_path.erase(working_path.begin());

				std::transform(working_path.begin(), working_path.end(), working_path.begin(), ::tolower);

				auto find_ext = working_path.find(_extension);
				if (find_ext == std::string::npos)
					working_path = working_path + _extension;

				auto iter = _pbo_searcher->file_index().find(working_path);
				if (iter != _pbo_searcher->file_index().end()) {
					return _load_file(iter->first, iter->second, entry_);
				}
				return false;
			}
		protected:
			acre::pbo::search_p _pbo_searcher;

			bool _load_file(const std::string &file_path_, const std::string &pbo_path_, file_entry_p &entry_) {

				std::ifstream _filestream;
				_filestream.open(pbo_path_, std::ios::binary | std::ios::in);

				acre::pbo::archive _archive(_filestream);

				acre::pbo::file_p _file = std::make_shared<acre::pbo::file>();

				std::string search_filename = file_path_;

				// Remove leading slash
				if (search_filename[0] == '\\') {
					search_filename.erase(0, 1);
				}

				std::transform(search_filename.begin(), search_filename.end(), search_filename.begin(), ::tolower);

				std::string prefix = std::string(_archive.info->header["prefix"]);
				std::transform(prefix.begin(), prefix.end(), prefix.begin(), ::tolower);

				search_filename.erase(search_filename.find(prefix), prefix.size() + 1);


				for (auto & entry : _archive.entries) {
					if (entry->filename == search_filename) {
						// Do shit here
						if (_archive.get_file(_filestream, entry, _file)) {
							
							entry_ = std::make_shared<file_entry>(_file);
							_filestream.close();
							return true;
						}
						break;
					}
				}

				_filestream.close();
				return false;
			};
		};
	}
}