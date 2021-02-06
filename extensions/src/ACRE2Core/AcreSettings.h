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

    acre::Result save();
    acre::Result load();
    acre::Result save(std::string filename);
    acre::Result load(std::string filename);

    DECLARE_MEMBER(std::string, LastVersion);

    DECLARE_MEMBER(float, GlobalVolume);
    DECLARE_MEMBER(float, PremixGlobalVolume);

    DECLARE_MEMBER(bool, DisablePosition);
    DECLARE_MEMBER(bool, DisableMuting);
    DECLARE_MEMBER(bool, DisableRadioFilter);
    DECLARE_MEMBER(bool, DisableUnmuteClients);

    DECLARE_MEMBER(bool, DisableChannelSwitch);
    DECLARE_MEMBER(bool, EnableAudioTest);

    DECLARE_MEMBER(std::string, Path);
};
