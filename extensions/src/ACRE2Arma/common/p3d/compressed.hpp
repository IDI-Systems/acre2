#pragma once

#include "shared.hpp"
#include "vector.hpp"

#include "read_helpers.hpp"

#include "compressed_base.hpp"


namespace acre {
    namespace p3d {

        template<typename T>
        class compressed : public compressed_base<T> {
        public:
            compressed() { }
            compressed(std::istream &stream_, bool compressed_ = false, bool fill_ = false, uint32_t version = 68) 
            {
                stream_.read((char *)&this->size, sizeof(uint32_t));
                 
               // if (version <)
                if (fill_)
                    READ_BOOL(this->fill);

                assert(size < 4095 * 10);
                if (this->size > 0) {
                    if (this->fill) {
                        T val;
                        stream_.read((char *)&val, sizeof(T));
                        for (uint32_t x = 0; x < this->size; x++) {
                            this->data.push_back(val);
                        }
                    }  else {
                        if (version >= 64 && compressed_) {
                            READ_BOOL(this->flag);
                        }
                        if ( (this->size * sizeof(T) >= 1024 && compressed_  && version < 64) || (this->flag && compressed_)) {
                            int32_t result = _decompress_safe(stream_, this->size * sizeof(T));
                            assert(result > 0);
                            T * ptr = (T *)(this->_data.get());
                            this->data.assign(ptr, ptr + this->size );
                        } else {
                            for (uint32_t x = 0; x < this->size; x++) {
                                T val;
                                stream_.read((char *)&val, sizeof(T));
                                this->data.push_back(val);
                            }
                        }
                    }
                }
            }
        };

        template<>
        class compressed<vector3<float>> : public compressed_base<vector3<float>>{
        public:
            compressed()  {}
            compressed(std::istream &stream_, bool compressed_ = false, bool fill_ = false, bool xyzCompressed = false, uint32_t version = 68) {
                stream_.read((char *)&size, sizeof(uint32_t));
                
                if (fill_)
                    READ_BOOL(this->fill);
                
                if (this->fill) {
                    acre::vector3<float> val(stream_);
                    for (uint32_t x = 0; x < this->size; x++) {
                        this->data.push_back(val);
                    }
                }
                else {
                    if (version >= 64) {
                        READ_BOOL(this->flag);
                    }
                    if ((this->size * sizeof(float)*3 >= 1024 && compressed_  && version < 64) || (this->flag && compressed_)) {
                        if (xyzCompressed) {
                            int32_t result = _decompress_safe(stream_, size * sizeof(float));
                            uint32_t * ptr = (uint32_t *)(this->_data.get());
                            for (uint32_t x = 0; x < this->size; x++) {
                                uint32_t value = ptr[x];
                                this->data.push_back(decode_xyz(value));
                            }
                        } else {
                            int32_t result = _decompress_safe(stream_, size * sizeof(float) * 3);
                            float * ptr = (float *)(_data.get());
                            for (uint32_t x = 0; x < this->size*3; x+=3) {
                                this->data.push_back(acre::vector3<float>(ptr+x));
                            }
                        }
                    } else {
                        for (uint32_t x = 0; x < this->size; x++) {
                            this->data.push_back(acre::vector3<float>(stream_));
                        }
                    }
                }
            }

            acre::vector3<float> decode_xyz(uint32_t CompressedXYZ)
            {
                const float scaleFactor = -1.0f / 511.0f;

                int x = CompressedXYZ & 0x3FF;
                int y = (CompressedXYZ >> 10) & 0x3FF;
                int z = (CompressedXYZ >> 20) & 0x3FF;
                if (x > 511) x -= 1024;
                if (y > 511) y -= 1024;
                if (z > 511) z -= 1024;

                return acre::vector3<float>(x * scaleFactor, y * scaleFactor, z * scaleFactor);
            }
        };

        template<>
        class compressed<pair<float>> : public compressed_base<pair<float>>{
        public:
            compressed() {}
            compressed(std::istream &stream_, bool compressed_ = false, bool fill_ = false, uint32_t version = 68) {
                stream_.read((char *)&this->size, sizeof(uint32_t));

                if (fill_)
                    READ_BOOL(this->fill);

                if (fill) {
                    acre::pair<float> val(stream_);
                    for (uint32_t x = 0; x < size; x++) {
                        this->data.push_back(val);
                    }
                }
                else {
                    if (version >= 64) {
                        READ_BOOL(flag);
                    }
                    if ((size * sizeof(float)*2 >= 1024 && compressed_  && version < 64) || (flag && compressed_)) {
                        
                        int32_t result = _decompress_safe(stream_, size * sizeof(float) * 2);
                        float * ptr = (float *)(this->_data.get());
                        for (uint32_t x = 0; x < size * 2; x += 2) {
                            this->data.push_back(acre::pair<float>(ptr + x));
                        }
                    }
                    else {
                        for (uint32_t x = 0; x < size; x++) {
                            this->data.push_back(acre::pair<float>(stream_));
                        }
                    }
                }
            }
        };
    }
}
