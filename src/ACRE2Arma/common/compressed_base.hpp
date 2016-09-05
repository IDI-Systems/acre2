#pragma once

#include "shared.hpp"
#include "vector.hpp"


namespace acre {
    class _compressed_base {
    protected:
        int _mikero_lzo1x_decompress_safe(const uint8_t*, uint8_t*, uint32_t);
        int _decompress_safe(std::istream &, uint32_t);
        bool _lzss_decompress(std::istream &, long);
        std::unique_ptr<uint8_t[]> _data;
    };
    template<typename T>
    class compressed_base : public _compressed_base {
    public:
        compressed_base() : fill(false), size(0), flag(0) {}

        T & operator[] (const int index) { return data[index]; }

        uint32_t          size;
        bool              fill;
        std::vector<T>    data;
        bool              flag;
    };
}