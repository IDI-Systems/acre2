#pragma once

#include "compat.h"
#include "Player.h"
#include "Types.h"
#include "Lockable.h"


class ISoundEngine :
    public CLockable
{
public:
    virtual ~ISoundEngine(){}

    virtual ARNE_RESULT set_Position(CPlayer *, ARNE_VECTOR *) = 0;
    virtual ARNE_RESULT get_Position(CPlayer *, ARNE_VECTOR *) = 0;

    virtual ARNE_RESULT set_Distortion(CPlayer *, float) = 0;
    virtual ARNE_RESULT get_Distortion(CPlayer *, float *) = 0;

    virtual ARNE_RESULT set_Volume(CPlayer *, float) = 0;
    virtual ARNE_RESULT get_Volume(CPlayer *, float *) = 0;
    virtual ARNE_RESULT set_Volume(ARNE_ID, float) = 0;
    virtual ARNE_RESULT get_Volume(ARNE_ID, float *) = 0;

    virtual ARNE_RESULT set_Muted(CPlayer *, bool) = 0;
    virtual ARNE_RESULT get_Muted(CPlayer *, bool *) = 0;
    virtual ARNE_RESULT set_Muted(ARNE_ID, bool) = 0;
    virtual ARNE_RESULT get_Muted(ARNE_ID, bool *) = 0;

    virtual ARNE_RESULT set_AllMuted(bool) = 0;
    
    virtual ARNE_RESULT startSpeaking(void) = 0;
    virtual ARNE_RESULT stopSpeaking(void) = 0;
    
    virtual ARNE_RESULT startSpeaking(CPlayer *) = 0;
    virtual ARNE_RESULT stopSpeaking(CPlayer *) = 0;

    virtual ARNE_RESULT playSquawk(CPlayer *, ARNE_SQUAWK, float, ARNE_VECTOR) = 0;

    virtual ARNE_RESULT disableInput(void) = 0;
    virtual ARNE_RESULT enableInput(void) = 0;
    virtual ARNE_RESULT get_InputStatus(bool *) = 0;

    virtual ARNE_RESULT        get_SoundData(CPlayer *, VOID **) = 0;
    virtual VOID *            get_SoundData(CPlayer *) = 0;
    virtual ARNE_RESULT        freeSoundData(CPlayer *) = 0;

    
    //
    // Game client connection/disconnection event functions
    //
    virtual ARNE_RESULT        onClientGameConnected(void) = 0;
    virtual ARNE_RESULT        onClientGameDisconnected(void) = 0;

    
    virtual int get_CurveModel() = 0;
    virtual void set_CurveModel(int model) = 0;

    virtual float get_CurveScale() = 0;
    virtual void set_CurveScale(float scale) = 0;
};