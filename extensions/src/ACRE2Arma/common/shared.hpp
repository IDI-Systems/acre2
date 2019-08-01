#pragma once

#include "targetver.h"
#include <assert.h>
#include <stdio.h>
#include <string>
#include <vector>
#include <list>
#include <map>
#include <unordered_map>
#include <memory>
#include <cmath>
#include <cstdint>
#include <streambuf>
#include "logging.hpp"

#ifdef _DEBUG
#define ZERO_OUTPUT()    { memset(output, 0x00, outputSize); }
#define EXTENSION_RETURN() {output[outputSize-1] = 0x00; } return;
#else
#define ZERO_OUTPUT()
#define EXTENSION_RETURN() return;
#endif

#ifdef _WINDOWS
#define sleep(x) Sleep(x)
#endif

namespace acre {
    template<typename T>
    struct array_deleter {
        void operator ()(T const * p) {
            delete[] p;
        }
    };

    std::vector<std::string> &split(const std::string &s, char delim, std::vector<std::string> &elems);
    std::vector<std::string> split(const std::string &s, char delim);

    // Trim from start
    static inline std::string &ltrim(std::string &s) {
        s.erase(s.begin(), std::find_if(s.begin(), s.end(), [](int32_t c) { return !std::isspace(c); }));
        return s;
    }

    // Trim from end
    static inline std::string &rtrim(std::string &s) {
        s.erase(std::find_if(s.rbegin(), s.rend(), [](int32_t c) {return !std::isspace(c); }).base(), s.end());
        return s;
    }

    // Trim from both ends
    static inline std::string &trim(std::string &s) {
        return ltrim(rtrim(s));
    }

    inline void runtime_assert(bool result);

    struct exception {
        exception(const uint32_t code_, const std::string & text_) : code(code_), text(text_) {}

        exception & operator= (const exception& other) {
            code = other.code;
            text = other.text;
            return *this;
        }
        bool operator == (const exception &r) const { return code == r.code; }

        uint32_t    code;
        std::string text;
    };
} /* namespace acre */

#ifdef _DEBUG
#define ACRE_ASSERT assert()
#else
#define ACRE_ASSERT acre::runtime_assert()
#endif
