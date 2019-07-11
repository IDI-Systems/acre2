#pragma once

#include "shared.hpp"
#include "compressed_base.hpp"
#include "Types.h"

#include <fstream>

namespace acre {
    namespace wrp {
        template<typename T>
        class compressed : public compressed_base<T> {
        public:
            compressed() { }
            compressed(std::istream &stream_, const uint32_t size_, const bool compressed_ = false, const bool fill_ = false, const uint32_t version = 25u) {
                //assert(size_ < 4095 * 10);
                if (size_ > 0) {
                    if (fill) {
                        T val;
                        stream_.read((char *)&val, sizeof(T));
                        for (uint32_t x = 0u; x < size_; x++) {
                            data.push_back(val);
                        }
                    } else {
                        if ((size_ * sizeof(T) >= 1024u && compressed_)) {
                            if (version >= 23) {
                                const int32_t result = _decompress_safe(stream_, size_ * sizeof(T));
                                assert(result > 0);
                                T * ptr = (T *)(_data.get());
                                data.assign(ptr, ptr + size_);
                            } else {
                                const bool ok = _lzss_decompress(stream_, (size_) * sizeof(T));
                                if (ok) {
                                    T * ptr = (T *)(_data.get());
                                    data.assign(ptr, ptr + size_);
                                }
                            }
                        } else {
                            for (uint32_t x = 0u; x < size_; x++) {
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
        class compressed<vector3<float32_t>> : public compressed_base<vector3<float32_t>>{
        public:
            compressed() {}
            compressed(std::istream &stream_, const uint32_t size_, const bool compressed_ = false, const bool fill_ = false, const bool xyzCompressed = false, const uint32_t version = 25u) {

                if (fill) {
                    const acre::vector3<float32_t> val(stream_);
                    for (uint32_t x = 0u; x < size_; x++) {
                        data.push_back(val);
                    }
                } else {
                    if ((size_ * sizeof(float32_t) * 3u >= 1024u && compressed_)) {
                        if (xyzCompressed) {
                            const int32_t result = _decompress_safe(stream_, size_ * sizeof(float32_t));
                            uint32_t * ptr = (uint32_t *)(_data.get());
                            for (uint32_t x = 0; x < size_; x++) {
                                const uint32_t value = ptr[x];
                                data.push_back(decode_xyz(value));
                            }
                        } else {
                            const int32_t result = _decompress_safe(stream_, size_ * sizeof(float32_t) * 3u);
                            float32_t * ptr = (float32_t *)(_data.get());
                            for (uint32_t x = 0; x < size_ * 3; x += 3) {
                                data.push_back(acre::vector3<float>(ptr + x));
                            }
                        }
                    } else {
                        for (uint32_t x = 0u; x < size_; x++) {
                            data.push_back(acre::vector3<float>(stream_));
                        }
                    }
                }
            }

            acre::vector3<float> decode_xyz(uint32_t CompressedXYZ) {
                float32_t scaleFactor = -1.0f / 511.0f;

                int32_t x = CompressedXYZ & 0x3FF;
                int32_t y = (CompressedXYZ >> 10) & 0x3FF;
                int32_t z = (CompressedXYZ >> 20) & 0x3FF;
                if (x > 511) {
                    x -= 1024;
                }
                if (y > 511) {
                    y -= 1024;
                }
                if (z > 511) {
                    z -= 1024;
                }

                return acre::vector3<float32_t>(static_cast<float32_t>(x) * scaleFactor, static_cast<float32_t>(y) * scaleFactor, static_cast<float32_t>(z) * scaleFactor);
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

        enum class LandscapeResult : int8_t {
            Failure = -2,
            Recovered = -1,
            Success = 0
        };

        class landscape {
        public:
            landscape() {};
            landscape(const std::string &path_);
            landscape(std::istream &stream_);
            ~landscape();

            compressed<float32_t> elevations;
            std::vector<vector3<float32_t>> peaks;

            char filetype[5];
            uint32_t map_size_x, map_size_y;
            uint32_t layer_size_x, layer_size_y;
            uint32_t some_bit;
            uint32_t version;
            float32_t cell_size;
            float32_t map_grid_size;
            LandscapeResult failure;

            LandscapeResult parse(const std::string &path_);
            LandscapeResult parse(std::istream &stream_);
            acre::Result generateAcreWrp(std::ofstream &);
        protected:
            bool _read_binary_tree_block(std::istream &stream, const uint32_t bit_length, const uint32_t block_size, const uint32_t cell_size, const uint32_t block_offset_x, const uint32_t block_offset_y);
            bool _process(std::istream &stream);
        };
        typedef std::shared_ptr<landscape> landscape_p;
    }
}
