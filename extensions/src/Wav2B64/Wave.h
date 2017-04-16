#pragma once

#include <Windows.h>
#include "stdafx.h"
#include "Mmsystem.h"
#include <string>


typedef struct __WAVEDESCR
{
    BYTE riff[4];
    uint32_t size;
    BYTE wave[4];

} _WAVEDESCR, *_LPWAVEDESCR;

typedef struct __WAVEFORMAT
{
    BYTE id[4];
    uint32_t size;
    SHORT format;
    SHORT channels;
    uint32_t sampleRate;
    uint32_t byteRate;
    SHORT blockAlign;
    SHORT bitsPerSample;

} _WAVEFORMAT, *_LPWAVEFORMAT;



class CWave
{
public:
    CWave(void);
    virtual ~CWave(void);

public:
    // Public methods
    bool Load(std::string wavFile);
    bool IsValid()                {return (m_lpData != NULL);}
    LPBYTE GetData()            {return m_lpData;}
    uint32_t GetSize()                {return m_dwSize;}
    SHORT GetChannels()            {return m_Format.channels;}
    uint32_t GetSampleRate()        {return m_Format.sampleRate;}
    SHORT GetBitsPerSample()    {return m_Format.bitsPerSample;}

private:
    // Private members
    _WAVEDESCR m_Descriptor;
    _WAVEFORMAT m_Format;
    LPBYTE m_lpData;
    uint32_t m_dwSize;
    HWAVEOUT m_hWaveout;
    WAVEHDR m_WaveHeader;
    bool m_bStopped;
    bool m_bPaused;
};
