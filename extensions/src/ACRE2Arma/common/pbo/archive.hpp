#pragma once

#include "shared.hpp"
#include "compressed_base.hpp"

namespace acre { 
    namespace pbo {
        class ext_entry {
        public:
            ext_entry();
            ext_entry(std::istream &);
            std::unordered_map<std::string, std::string> header;
        };
        typedef std::shared_ptr<ext_entry> ext_entry_p;

        class entry {
        public:
            entry();
            entry(std::istream &);
 
            std::string filename;

            uint32_t    compression;
            uint32_t    size;
            uint32_t    storage_size;
            uint32_t    offset;         // pre-computed during search, offset of file

            uint32_t    reserved;
            uint32_t    timestamp;
        };
        typedef std::shared_ptr<entry> entry_p;

        class file {
        public:
            entry_p     entry;
            std::unique_ptr<uint8_t[]> data;
            std::streamsize    size;
        };
        typedef std::shared_ptr<file> file_p;

        class archive : public _compressed_base {
        public:
            archive();
            archive(std::istream &);
            ~archive();

            bool      get_file(std::istream &, const std::string & file, file_p output);
            bool      get_file(std::istream &, const entry_p entry, file_p output);

            std::streamoff          begin_data_offset;

            ext_entry_p             info;
            std::vector<entry_p>    entries;
        };
        typedef std::shared_ptr<archive> archive_p;
    } 
}
