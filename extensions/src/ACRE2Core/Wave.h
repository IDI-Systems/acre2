#pragma once

#include <compat.h>

#ifdef WIN32
#include <SDKDDKVer.h>
#include "Mmsystem.h"
#endif

#include <stdio.h>
#include <string>

#ifdef __linux__
#define BYTE unsigned char
#define LPBYTE unsigned char*
#define SHORT short
#define HWAVEOUT void*
typedef struct wavehdr_tag {
  char*                 lpData;
  DWORD              dwBufferLength;
  DWORD              dwBytesRecorded;
  DWORD*             dwUser;
  DWORD              dwFlags;
  DWORD              dwLoops;
  struct wavehdr_tag    *lpNext;
  DWORD*             reserved;
} WAVEHDR, *LPWAVEHDR;
#endif

typedef struct __WAVEDESCR
{
    BYTE riff[4];
    DWORD size;
    BYTE wave[4];

} _WAVEDESCR, *_LPWAVEDESCR;

typedef struct __WAVEFORMAT
{
    BYTE id[4];
    DWORD size;
    SHORT format;
    SHORT channels;
    DWORD sampleRate;
    DWORD byteRate;
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
    BOOL Load(std::string wavFile);
    BOOL IsValid()                {return (m_lpData != NULL);}
    LPBYTE GetData()            {return m_lpData;}
    DWORD GetSize()                {return m_dwSize;}
    SHORT GetChannels()            {return m_Format.channels;}
    DWORD GetSampleRate()        {return m_Format.sampleRate;}
    SHORT GetBitsPerSample()    {return m_Format.bitsPerSample;}

private:
    // Private members
    _WAVEDESCR m_Descriptor;
    _WAVEFORMAT m_Format;
    LPBYTE m_lpData;
    DWORD m_dwSize;
    HWAVEOUT m_hWaveout;
    WAVEHDR m_WaveHeader;
    BOOL m_bStopped;
    BOOL m_bPaused;
};
