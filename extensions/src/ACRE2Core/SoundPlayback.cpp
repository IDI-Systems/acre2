#include "SoundPlayback.h"
#include "Engine.h"
#include "Wave.h"
#include "SoundEngine.h"
#include "SoundMonoChannel.h"

#include <string>


acre::Result CSoundPlayback::buildSound(std::string id, std::string content) {
    SoundItem *item;
    if (itemMap.find(id) == itemMap.end()) {
        item = new SoundItem();
        item->loaded = false;
        item->id = id;
        itemMap.insert(std::pair<std::string, SoundItem *>(id, item));
    } else {
        item = itemMap.find(id)->second;
    }
    if (!item->loaded) {
        item->base64 += content;
    }

    return acre::Result::ok;
}

acre::Result CSoundPlayback::loadSound(std::string id) {
    SoundItem *item;
    if (itemMap.find(id) == itemMap.end()) {
        return acre::Result::error;
    }
    item = itemMap.find(id)->second;

    std::vector<char> decoded = base64_decode(item->base64);


    std::string tempPath = CEngine::getInstance()->getClient()->getTempFilePath();
    tempPath += "\\";
    tempPath += id;
    std::ofstream out(tempPath, std::ios::out | std::ios::binary);
    if (!out.is_open()) {
        return acre::Result::error;
    }
    out.write(&decoded[0], decoded.size());
    out.close();

    item->base64 = "";
    item->tempPath = tempPath;

    return acre::Result::ok;
}

acre::Result CSoundPlayback::playSound(std::string id, acre::vec3_fp32_t position, acre::vec3_fp32_t direction, float volume, bool isWorld) {
    std::string tempPath = CEngine::getInstance()->getClient()->getTempFilePath();
    tempPath += "\\";
    tempPath += id;
    CWave waveFile;
    if (waveFile.Load(tempPath)) {
        CSoundChannelMono *tempChannel;
        CEngine::getInstance()->getSoundEngine()->getSoundMixer()->lock();
        CEngine::getInstance()->getSoundEngine()->getSoundMixer()->acquireChannel(&tempChannel, waveFile.GetSize()/sizeof(short), true);
        tempChannel->setEffectInsert(0, "acre_volume");
        tempChannel->getEffectInsert(0)->setParam("volume", volume);
        tempChannel->setMixdownEffectInsert(0, "acre_positional");

        tempChannel->getMixdownEffectInsert(0)->setParam("speakerPosX", position.x);
        tempChannel->getMixdownEffectInsert(0)->setParam("speakerPosY", position.y);
        tempChannel->getMixdownEffectInsert(0)->setParam("speakerPosZ", position.z);

        tempChannel->getMixdownEffectInsert(0)->setParam("headVectorX", direction.x);
        tempChannel->getMixdownEffectInsert(0)->setParam("headVectorY", direction.y);
        tempChannel->getMixdownEffectInsert(0)->setParam("headVectorZ", direction.z);

        if (isWorld) {
            tempChannel->getMixdownEffectInsert(0)->setParam("isWorld", 0x00000001);
            tempChannel->getMixdownEffectInsert(0)->setParam("speakingType", static_cast<float32_t>(acre::Speaking::radio));
        } else {
            tempChannel->getMixdownEffectInsert(0)->setParam("isWorld", 0x00000000);
        }

        tempChannel->In((short *)waveFile.GetData(), waveFile.GetSize()/sizeof(short));
        CEngine::getInstance()->getSoundEngine()->getSoundMixer()->unlock();
        return acre::Result::ok;
    }
    return acre::Result::error;
}

bool CSoundPlayback::is_base64(unsigned char c) {
    return (isalnum(c) || (c == '+') || (c == '/'));
}


std::vector<char> CSoundPlayback::base64_decode(std::string const& encoded_string) {
    int in_len = encoded_string.size();
    int i = 0;
    int j = 0;
    int in_ = 0;
    unsigned char char_array_4[4], char_array_3[3];
    //std::string ret;
    std::vector<char> ret;
  

    while (in_len-- && ( encoded_string[in_] != '=') && is_base64(encoded_string[in_])) {
        char_array_4[i++] = encoded_string[in_]; in_++;
        if (i ==4) {
            for (i = 0; i <4; i++)
            char_array_4[i] = (unsigned char)base64_chars.find(char_array_4[i]);

            char_array_3[0] = (char_array_4[0] << 2) + ((char_array_4[1] & 0x30) >> 4);
            char_array_3[1] = ((char_array_4[1] & 0xf) << 4) + ((char_array_4[2] & 0x3c) >> 2);
            char_array_3[2] = ((char_array_4[2] & 0x3) << 6) + char_array_4[3];

            for (i = 0; (i < 3); i++)
            ret.push_back(char_array_3[i]);
            i = 0;
        }
    }

    if (i) {
        for (j = i; j <4; j++)
            char_array_4[j] = 0;

        for (j = 0; j <4; j++)
            char_array_4[j] = (unsigned char)base64_chars.find(char_array_4[j]);

        char_array_3[0] = (char_array_4[0] << 2) + ((char_array_4[1] & 0x30) >> 4);
        char_array_3[1] = ((char_array_4[1] & 0xf) << 4) + ((char_array_4[2] & 0x3c) >> 2);
        char_array_3[2] = ((char_array_4[2] & 0x3) << 6) + char_array_4[3];

        for (j = 0; (j < i - 1); j++) ret.push_back(char_array_3[j]);
    }

    return ret;
}
