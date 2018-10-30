#pragma once

#include "compat.h"
#include "Macros.h"
#include "Lockable.h"
#include "Types.h"
#include "ACRE_VECTOR.h"

#include <map>
#include <vector>
#include <iostream>
#include <fstream>

#include "Log.h"

struct SoundItem {
    int32_t dataCount;
    bool loaded;
    std::string id;
    std::string base64;
    std::string tempPath;
};

class CSoundPlayback : public CLockable {
public:
    CSoundPlayback() {
        m_base64_chars =
             "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
             "abcdefghijklmnopqrstuvwxyz"
             "0123456789+/";
    };
    ~CSoundPlayback() { };

    ACRE_RESULT buildSound(std::string id, std::string content);
    ACRE_RESULT loadSound(const std::string &id);
    ACRE_RESULT playSound(const std::string &id, const ACRE_VECTOR position, const ACRE_VECTOR direction, const float32_t volume, const bool isWorld);

private:
    std::map<std::string, SoundItem *> m_itemMap;
    std::string m_base64_chars;

    bool is_base64(const uint8_t c);
    std::vector<int8_t> base64_decode(std::string const& encoded_string);
};

