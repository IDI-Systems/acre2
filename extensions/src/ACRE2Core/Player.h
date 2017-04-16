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
    void init(ACRE_ID id);
public:
    std::array<CSoundChannelMono *, 32> channels;

    CPlayer(ACRE_ID id);
    CPlayer( void );

    void clearSoundChannels();
    ~CPlayer( void ) {
        clearSoundChannels();
    };

    DECLARE_MEMBER(ACRE_ID, Id);
    DECLARE_MEMBER(ACRE_VECTOR, WorldPosition);
    DECLARE_MEMBER(ACRE_VECTOR, HeadVector);
    DECLARE_MEMBER(ACRE_SPEAKING_TYPE, SpeakingType);

    DECLARE_MEMBER(ACRE_VOLUME, Volume);
    DECLARE_MEMBER(ACRE_VOLUME, PreviousVolume);
    DECLARE_MEMBER(ACRE_VOLUME, SignalQuality);
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
