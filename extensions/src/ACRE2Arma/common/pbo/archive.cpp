#pragma once

#include "archive.hpp"
#include "p3d/read_helpers.hpp"



namespace acre {
    namespace pbo {
        bool      archive::get_file(std::istream &, const std::string & file, file_p output) {
            return false;
        }

        bool      archive::get_file(std::istream & stream_, const entry_p entry_, file_p output) {
            std::streamoff file_offset, bytes_read;
            uint32_t use_size;

            std::streampos _save = stream_.tellg();
            file_offset = begin_data_offset + entry_->offset;
          
            
            
            stream_.seekg(file_offset, stream_.beg);
            if (entry_->compression == 'Cprs') {
                output->data = std::unique_ptr<uint8_t[]>(new uint8_t[entry_->size]);
                _lzss_decompress(stream_, entry_->size);
                memcpy(output->data.get(), this->_data.get(), entry_->size);
                use_size = entry_->size;
            }
            else {
                bytes_read = 0;
                use_size = entry_->storage_size;
                output->data = std::unique_ptr<uint8_t[]>(new uint8_t[use_size]);
                while (bytes_read < use_size) {
                    if (!stream_.read((char *)output->data.get() + bytes_read, use_size - bytes_read)) {
                        return false;
                    }
                    bytes_read += stream_.gcount();
                }
            }
            
            output->size = use_size;
            output->entry = entry_;

            stream_.seekg(_save, stream_.beg);

            return true;
        }

        archive::archive() { }
        archive::archive(std::istream &stream_) {
            // Read the first entry, then info, then next entry
            uint32_t offset = 0;
            entry_p root_entry = std::make_shared<entry>(stream_);
            info = std::make_shared<ext_entry>(stream_);
            root_entry->offset = 0;
            entries.push_back(root_entry);

            entry_p next_entry = std::make_shared<entry>(stream_);
            while (next_entry->filename != "") { // off by 1006 ?!
                next_entry->offset = offset;
                entries.push_back(next_entry);
                offset += next_entry->storage_size;

                next_entry = std::make_shared<entry>(stream_);
            }
            begin_data_offset = stream_.tellg();;
        }
        archive::~archive() {}

        entry::entry() {}
        entry::entry(std::istream &stream_) { 
            READ_STRING(filename);
            std::transform(filename.begin(), filename.end(), filename.begin(), ::tolower);

            stream_.read((char *)&compression, sizeof(uint32_t));
            stream_.read((char *)&size, sizeof(uint32_t));
            stream_.read((char *)&reserved, sizeof(uint32_t));
            stream_.read((char *)&timestamp, sizeof(uint32_t));
            stream_.read((char *)&storage_size, sizeof(uint32_t));
        }

        ext_entry::ext_entry() {}
        ext_entry::ext_entry(std::istream &stream_) {
            std::string key, val;
            READ_STRING(key);
            
            while (key != "") {
                READ_STRING(val);
                header[key] = val;
                READ_STRING(key);
            }
            
        }
    }
}
