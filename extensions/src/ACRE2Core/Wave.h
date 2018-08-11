#pragma once

#include <Windows.h>
#include <SDKDDKVer.h>
#include <stdio.h>
#include <tchar.h>
#include "Mmsystem.h"
#include <string>
#include "Types.h"


typedef struct __WAVEDESCR
{
    uint8_t riff[4];
    uint32_t size;
    uint8_t wave[4];

} _WAVEDESCR, *_LPWAVEDESCR;

typedef struct __WAVEFORMAT
{
    uint8_t id[4];
    uint32_t size;
    int16_t format;
    int16_t channels;
    uint32_t sampleRate;
    uint32_t byteRate;
    int16_t blockAlign;
    int16_t bitsPerSample;

} _WAVEFORMAT, *_LPWAVEFORMAT;



class CWave {
public:
    CWave(void);
    virtual ~CWave(void);

public:
    // Public methods
    bool Load(const std::string &wavFile);
    bool IsValid() const             {return m_lpData != NULL;}
    uint8_t* GetData() const         {return m_lpData;}
    uint32_t GetSize() const         {return m_dwSize;}
    int16_t GetChannels() const      {return m_Format.channels;}
    uint32_t GetSampleRate() const   {return m_Format.sampleRate;}
    int16_t GetBitsPerSample() const {return m_Format.bitsPerSample;}

private:
    // Private members
    _WAVEDESCR m_Descriptor;
    _WAVEFORMAT m_Format;
    uint8_t *m_lpData;
    uint32_t m_dwSize;
    HWAVEOUT m_hWaveout;
    WAVEHDR m_WaveHeader;
    bool m_bStopped;
    bool m_bPaused;
};
