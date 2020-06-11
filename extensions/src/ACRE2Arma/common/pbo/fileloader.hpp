#pragma once

#include "controller.hpp"
#include "archive.hpp"
#include "search.hpp"
#include "singleton.hpp"
#include "membuf.hpp"
#include <shlwapi.h>
#pragma comment(lib, "shlwapi.lib")

namespace acre {
    namespace pbo {
        class file_entry {
        public:
            file_entry() = delete;            
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
            void poke(acre::controller * ctrl) {
                ctrl->add("copy_to_temp", std::bind(&acre::pbo::fileloader::copy_to_temp, this, std::placeholders::_1, std::placeholders::_2));
                return;
            }

            // write wav files from pbo to temp folder
            bool acre::pbo::fileloader::copy_to_temp(const arguments& _args, std::string& result) {
                if (_args.size() < 2) {
                    result = "Bad Arg count";
                    return false;
                }
                std::string source_arma_path = _args.as_string(0);
                std::string output_filename = _args.as_string(1);
                LOG(INFO) << "copy_to_temp [" << source_arma_path << ", " << output_filename << "]";

                file_entry_p fep;
                if (!get_file(source_arma_path, "wav", fep)) {
                    result = "File not found";
                    return false;
                }
                std::istream& arma_filesys_is(fep->stream());

                char tempPath[MAX_PATH - 14];
                GetTempPathA(sizeof(tempPath), tempPath);
                std::string tempFolder = std::string(tempPath);
                tempFolder += "acre";
                if (!PathFileExistsA(tempFolder.c_str())) {
                    if (!CreateDirectoryA(tempFolder.c_str(), NULL)) {
                        result = "Could not create temp folder";
                        return false;
                    }
                }
                std::ofstream temp_ofs(tempFolder + "\\" + output_filename, std::ios::out | std::ios::binary | std::ios::trunc);
                if (!temp_ofs.is_open()) {
                    result = "Could not open temp file";
                    return false;
                }

                temp_ofs << arma_filesys_is.rdbuf();
                temp_ofs.close();

                result = "";
                return true;
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
