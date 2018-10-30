#pragma once

#include "Macros.h"
#include "Singleton.h"
#include "Lockable.h"

#include "SoundEngine.h"
#include "ini_reader.hpp"

class CAcreSettings :
    public TSingleton<CAcreSettings>, public CLockable {
public:
    CAcreSettings();
    ~CAcreSettings();

    ACRE_RESULT save();
    ACRE_RESULT load();
    ACRE_RESULT save(const std::string &filename) const;
    ACRE_RESULT load(const std::string &filename);

    DECLARE_MEMBER(std::string, LastVersion);

    DECLARE_MEMBER(float32_t, GlobalVolume);
    DECLARE_MEMBER(float32_t, PremixGlobalVolume);

    DECLARE_MEMBER(bool, DisablePosition);
    DECLARE_MEMBER(bool, DisableMuting);
    DECLARE_MEMBER(bool, DisableRadioFilter);
    DECLARE_MEMBER(bool, DisableUnmuteClients);
    DECLARE_MEMBER(bool, DisableTS3ChannelSwitch);

    DECLARE_MEMBER(bool, EnableAudioTest);

    DECLARE_MEMBER(std::string, Path);
};
