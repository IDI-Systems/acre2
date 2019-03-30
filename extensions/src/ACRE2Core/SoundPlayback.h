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
    int dataCount;
    BOOL loaded;
    std::string id;
    std::string base64;
    std::string tempPath;
};

class CSoundPlayback : public CLockable {
public:
    CSoundPlayback() { 
        base64_chars = 
             "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
             "abcdefghijklmnopqrstuvwxyz"
             "0123456789+/"; 
    };
    ~CSoundPlayback() { };

    acre_result_t buildSound(std::string id, std::string content);
    acre_result_t loadSound(std::string id);
    acre_result_t playSound(std::string id, ACRE_VECTOR position, ACRE_VECTOR direction, float volume, bool isWorld);

private:
    std::map<std::string, SoundItem *> itemMap;
    std::string base64_chars;

    bool is_base64(unsigned char c);
    std::vector<char> base64_decode(std::string const& encoded_string);
};

