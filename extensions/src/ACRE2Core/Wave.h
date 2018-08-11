#pragma once

#include <Windows.h>
#include <SDKDDKVer.h>
#include <stdio.h>
#include <tchar.h>
#include "Mmsystem.h"
#include <string>
#include "Types.h"

typedef struct __waveDescr
{
    uint8_t riff[4];
    uint32_t size;
    uint8_t wave[4];

} waveDescr_t, *lpWaveDescr_t;

typedef struct __waveFormat
{
    uint8_t id[4];
    uint32_t size;
    int16_t format;
    int16_t channels;
    uint32_t sampleRate;
    uint32_t byteRate;
    int16_t blockAlign;
    int16_t bitsPerSample;
} waveFormat_t, *lpwaveformat_t;



class CWave {
public:
    CWave(void);
    virtual ~CWave(void);

    // Public methods
    bool     load(const std::string &wavFile);
    bool     isValid() const          {return m_lpData != NULL;}
    uint8_t* getData() const          {return m_lpData;}
    uint32_t getSize() const          {return m_dwSize;}
    int16_t  getChannels() const      {return m_Format.channels;}
    uint32_t getSampleRate() const    {return m_Format.sampleRate;}
    int16_t  getBitsPerSample() const {return m_Format.bitsPerSample;}

private:
    // Private members
    waveDescr_t  m_descriptor;
    waveFormat_t m_format;
    uint8_t*     m_lpData;
    uint32_t     m_dwSize;
    HWAVEOUT     m_hWaveout;
    WAVEHDR      m_waveHeader;
    bool         m_bStopped;
    bool         m_bPaused;
};
