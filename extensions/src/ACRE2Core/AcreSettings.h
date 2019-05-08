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

    AcreResult save();
    AcreResult load();
    AcreResult save(std::string filename);
    AcreResult load(std::string filename);

    DECLARE_MEMBER(std::string, LastVersion);

    DECLARE_MEMBER(float, GlobalVolume);
    DECLARE_MEMBER(float, PremixGlobalVolume);

    DECLARE_MEMBER(bool, DisablePosition);
    DECLARE_MEMBER(bool, DisableMuting);
    DECLARE_MEMBER(bool, DisableRadioFilter);
    DECLARE_MEMBER(bool, DisableUnmuteClients);
    DECLARE_MEMBER(bool, DisableTS3ChannelSwitch);

    DECLARE_MEMBER(bool, EnableAudioTest);

    DECLARE_MEMBER(std::string, Path);
};
