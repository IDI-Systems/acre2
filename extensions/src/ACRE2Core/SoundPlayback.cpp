#include "SoundPlayback.h"
#include "Engine.h"
#include "Wave.h"
#include "SoundEngine.h"
#include "SoundMonoChannel.h"

#include <string>


ACRE_RESULT CSoundPlayback::buildSound(std::string id, std::string content) {
    SoundItem *item;
    if (m_itemMap.find(id) == m_itemMap.end()) {
        item = new SoundItem();
        item->loaded = FALSE;
        item->id = id;
        m_itemMap.insert(std::pair<std::string, SoundItem *>(id, item));
    } else {
        item = m_itemMap.find(id)->second;
    }
    if (!item->loaded) {
        item->base64 += content;
    }

    return ACRE_OK;
}

ACRE_RESULT CSoundPlayback::loadSound(const std::string &ac_id) {
    SoundItem *item;
    if (m_itemMap.find(ac_id) == m_itemMap.end()) {
        return ACRE_ERROR;
    }
    item = m_itemMap.find(ac_id)->second;

    std::vector<int8_t> decoded = base64_decode(item->base64);


    std::string tempPath = CEngine::getInstance()->getClient()->getTempFilePath();
    tempPath += "\\";
    tempPath += ac_id;
    std::ofstream out(tempPath, std::ios::out | std::ios::binary);
    if (!out.is_open()) {
        return ACRE_ERROR;
    }
    out.write((char *) &decoded[0], decoded.size());
    out.close();

    item->base64 = "";
    item->tempPath = tempPath;

    return ACRE_OK;
}

ACRE_RESULT CSoundPlayback::playSound(const std::string &ac_id, const ACRE_VECTOR ac_position, const ACRE_VECTOR ac_direction, const float32_t ac_volume, const bool ac_isWorld) {
    std::string tempPath = CEngine::getInstance()->getClient()->getTempFilePath();
    tempPath += "\\";
    tempPath += ac_id;
    CWave waveFile;
    if (waveFile.load(tempPath)) {
        CSoundChannelMono *tempChannel;
        CEngine::getInstance()->getSoundEngine()->getSoundMixer()->lock();
        CEngine::getInstance()->getSoundEngine()->getSoundMixer()->acquireChannel(&tempChannel, waveFile.getSize()/sizeof(int16_t), true);
        tempChannel->setEffectInsert(0, "acre_volume");
        tempChannel->getEffectInsert(0)->setParam("volume", ac_volume);
        tempChannel->setMixdownEffectInsert(0, "acre_positional");

        tempChannel->getMixdownEffectInsert(0)->setParam("speakerPosX", ac_position.x);
        tempChannel->getMixdownEffectInsert(0)->setParam("speakerPosY", ac_position.y);
        tempChannel->getMixdownEffectInsert(0)->setParam("speakerPosZ", ac_position.z);

        tempChannel->getMixdownEffectInsert(0)->setParam("headVectorX", ac_direction.x);
        tempChannel->getMixdownEffectInsert(0)->setParam("headVectorY", ac_direction.y);
        tempChannel->getMixdownEffectInsert(0)->setParam("headVectorZ", ac_direction.z);

        if (ac_isWorld) {
            tempChannel->getMixdownEffectInsert(0)->setParam("isWorld", 0x00000001);
            tempChannel->getMixdownEffectInsert(0)->setParam("speakingType", ACRE_SPEAKING_RADIO);
        } else {
            tempChannel->getMixdownEffectInsert(0)->setParam("isWorld", 0x00000000);
        }

        tempChannel->In((short *)waveFile.getData(), waveFile.getSize()/sizeof(short));
        CEngine::getInstance()->getSoundEngine()->getSoundMixer()->unlock();
        return ACRE_OK;
    }
    return ACRE_ERROR;
}

bool CSoundPlayback::is_base64(const uint8_t c) {
    return (isalnum(c) || (c == '+') || (c == '/'));
}


std::vector<int8_t> CSoundPlayback::base64_decode(std::string const& encoded_string) {
    int32_t in_len = (int32_t) encoded_string.size();
    int32_t i = 0;
    int32_t j = 0;
    int32_t in_ = 0;
    uint8_t char_array_4[4], char_array_3[3];
    //std::string ret;
    std::vector<int8_t> ret;
  

    while (in_len-- && ( encoded_string[in_] != '=') && is_base64(encoded_string[in_])) {
        char_array_4[i++] = encoded_string[in_]; in_++;
        if (i ==4) {
            for (i = 0; i <4; i++)
            char_array_4[i] = (uint8_t) m_base64_chars.find(char_array_4[i]);

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
            char_array_4[j] = (uint8_t) m_base64_chars.find(char_array_4[j]);

        char_array_3[0] = (char_array_4[0] << 2) + ((char_array_4[1] & 0x30) >> 4);
        char_array_3[1] = ((char_array_4[1] & 0xf) << 4) + ((char_array_4[2] & 0x3c) >> 2);
        char_array_3[2] = ((char_array_4[2] & 0x3) << 6) + char_array_4[3];

        for (j = 0; (j < i - 1); j++) ret.push_back(char_array_3[j]);
    }

    return ret;
}
