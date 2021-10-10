#pragma once


#include "compat.h"
#include "Macros.h"
#include "Lockable.h"
#include "Types.h"
#include "ACRE_VECTOR.h"
#include "SoundMonoChannel.h"
#include <array>
#include "Log.h"

class CPlayer : public CLockable {
protected:
    void init(acre::id_t id);
public:
    std::array<CSoundChannelMono *, 32> channels;

    CPlayer(acre::id_t id);
    CPlayer( void );
    
    void clearSoundChannels();
    ~CPlayer( void ) {
        clearSoundChannels();
    };

    DECLARE_MEMBER(acre::id_t, Id);
    DECLARE_MEMBER(acre::vec3_fp32_t, WorldPosition);
    DECLARE_MEMBER(acre::vec3_fp32_t, HeadVector);
    DECLARE_MEMBER(acre::Speaking, SpeakingType);

    DECLARE_MEMBER(acre::volume_t, Volume);
    DECLARE_MEMBER(acre::volume_t, PreviousVolume);
    DECLARE_MEMBER(acre::volume_t, SignalQuality);
    DECLARE_MEMBER(char *, SignalModel);
    DECLARE_MEMBER(bool, IsLoudSpeaker);

    DECLARE_MEMBER(std::string, CurrentRadioId);

    DECLARE_MEMBER(char *, name);
    DECLARE_MEMBER(float, AmplitudeCoef);

    DECLARE_MEMBER(float, AttenAverageSum);
    DECLARE_MEMBER(int, AttenCount);
    DECLARE_MEMBER(float, SelectableCurveScale);
    DECLARE_MEMBER(std::string, NetId);
    DECLARE_MEMBER(std::string, InitType);
};
