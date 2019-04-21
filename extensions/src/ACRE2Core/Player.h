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
    void init(acre_id_t id);
public:
    std::array<CSoundChannelMono *, 32> channels;

    CPlayer(acre_id_t id);
    CPlayer( void );
    
    void clearSoundChannels();
    ~CPlayer( void ) {
        clearSoundChannels();
    };

    DECLARE_MEMBER(acre_id_t, Id);
    DECLARE_MEMBER(ACRE_VECTOR, WorldPosition);
    DECLARE_MEMBER(ACRE_VECTOR, HeadVector);
    DECLARE_MEMBER(AcreSpeaking, SpeakingType);

    DECLARE_MEMBER(acre_volume_t, Volume);
    DECLARE_MEMBER(acre_volume_t, PreviousVolume);
    DECLARE_MEMBER(acre_volume_t, SignalQuality);
    DECLARE_MEMBER(char *, SignalModel);
    DECLARE_MEMBER(BOOL, IsLoudSpeaker);

    DECLARE_MEMBER(std::string, CurrentRadioId);

    DECLARE_MEMBER(char *, name);
    DECLARE_MEMBER(float, AmplitudeCoef);

    DECLARE_MEMBER(float, AttenAverageSum);
    DECLARE_MEMBER(int, AttenCount);
    DECLARE_MEMBER(float, SelectableCurveScale);
    DECLARE_MEMBER(std::string, NetId);
    DECLARE_MEMBER(std::string, InitType);
};