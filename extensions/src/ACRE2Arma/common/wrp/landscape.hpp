#pragma once

#include "shared.hpp"
#include "compressed_base.hpp"

namespace acre {
    namespace wrp {


        template<typename T>
        class compressed : public compressed_base<T> {
        public:
            compressed() { }
            compressed(std::istream &stream_, uint32_t size_, bool compressed_ = false, bool fill_ = false, uint32_t version = 25)
            {

                //assert(size_ < 4095 * 10);
                if (size_ > 0) {
                    if (fill) {
                        T val;
                        stream_.read((char *)&val, sizeof(T));
                        for (uint32_t x = 0; x < size_; x++) {
                            data.push_back(val);
                        }
                    }
                    else {
                        if ((size_ * sizeof(T) >= 1024 && compressed_)) {
                            if (version >= 23) {
                                int32_t result = _decompress_safe(stream_, size_ * sizeof(T));
                                assert(result > 0);
                                T * ptr = (T *)(_data.get());
                                data.assign(ptr, ptr + size_);
                            }
                            else {
                                bool ok = _lzss_decompress(stream_, (size_) * sizeof(T));
                                if (ok) {
                                    T * ptr = (T *)(_data.get());
                                    data.assign(ptr, ptr + size_);
                                }
                            }
                        }
                        else {
                            for (uint32_t x = 0; x < size_; x++) {
                                T val;
                                stream_.read((char *)&val, sizeof(T));
                                data.push_back(val);
                            }
                        }
                    }
                }
            }
        };

        template<>
        class compressed<vector3<float>> : public compressed_base<vector3<float>>{
        public:
            compressed() {}
            compressed(std::istream &stream_, uint32_t size_, bool compressed_ = false, bool fill_ = false, bool xyzCompressed = false, uint32_t version = 25) {

                if (fill) {
                    acre::vector3<float> val(stream_);
                    for (uint32_t x = 0; x < size_; x++) {
                        data.push_back(val);
                    }
                }
                else {
                    if ((size_ * sizeof(float) * 3 >= 1024 && compressed_)) {
                        if (xyzCompressed) {
                            int32_t result = _decompress_safe(stream_, size_ * sizeof(float));
                            uint32_t * ptr = (uint32_t *)(_data.get());
                            for (uint32_t x = 0; x < size_; x++) {
                                uint32_t value = ptr[x];
                                data.push_back(decode_xyz(value));
                            }
                        }
                        else {
                            int32_t result = _decompress_safe(stream_, size_ * sizeof(float) * 3);
                            float * ptr = (float *)(_data.get());
                            for (uint32_t x = 0; x < size_ * 3; x += 3) {
                                data.push_back(acre::vector3<float>(ptr + x));
                            }
                        }
                    }
                    else {
                        for (uint32_t x = 0; x < size_; x++) {
                            data.push_back(acre::vector3<float>(stream_));
                        }
                    }
                }
            }

            acre::vector3<float> decode_xyz(uint32_t CompressedXYZ)
            {
                float scaleFactor = -1.0f / 511.0f;

                int x = CompressedXYZ & 0x3FF;
                int y = (CompressedXYZ >> 10) & 0x3FF;
                int z = (CompressedXYZ >> 20) & 0x3FF;
                if (x > 511) x -= 1024;
                if (y > 511) y -= 1024;
                if (z > 511) z -= 1024;

                return acre::vector3<float>((float)x * scaleFactor, (float)y * scaleFactor, (float)z * scaleFactor);
            }
        };
        /*
        template<>
        class compressed<pair<float>> : public compressed_base<pair<float>>{
        public:
            compressed() {}
            compressed(std::istream &stream_, bool compressed_ = false, bool fill_ = false, uint32_t version = 68) {
                stream_.read((char *)&size, sizeof(uint32_t));

                if (fill_)
                    READ_BOOL(fill);

                if (fill) {
                    acre::pair<float> val(stream_);
                    for (int x = 0; x < size; x++) {
                        data.push_back(val);
                    }
                }
                else {
                    if (version >= 64) {
                        READ_BOOL(flag);
                    }
                    if ((size * sizeof(float) * 2 >= 1024 && compressed_  && version < 64) || (flag && compressed_)) {

                        int32_t result = _decompress_safe(stream_, size * sizeof(float) * 2);
                        float * ptr = (float *)(_data.get());
                        for (int x = 0; x < size * 2; x += 2) {
                            data.push_back(acre::pair<float>(ptr + x));
                        }
                    }
                    else {
                        for (int x = 0; x < size; x++) {
                            data.push_back(acre::pair<float>(stream_));
                        }
                    }
                }
            }
        };
        */



        class landscape {
        public:
            landscape() {};
            landscape(std::string);
            landscape(std::istream &);
            ~landscape();

            compressed<float> elevations;
            std::vector<vector3<float>> peaks;

            char filetype[5];
            uint32_t map_size_x, map_size_y;
            uint32_t layer_size_x, layer_size_y;
            uint32_t some_bit;
            uint32_t version;
            float cell_size;
            float map_grid_size;

        protected:
            bool _read_binary_tree_block(std::istream &, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t);
            bool _process(std::istream &);
        };
        typedef std::shared_ptr<landscape> landscape_p;
    }
}