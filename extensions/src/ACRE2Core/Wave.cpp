#include <SDKDDKVer.h>
#include <stdio.h>
#include <tchar.h>
#include "Wave.h"
#include "math.h"
#include <fstream>


CWave::CWave(void)
{
    // Init members
    memset(&m_Descriptor, 0, sizeof(_WAVEDESCR));
    memset(&m_Format, 0, sizeof(_WAVEFORMAT));
    m_lpData = NULL;
    m_dwSize = 0;
    m_hWaveout = NULL;
    memset(&m_WaveHeader, 0, sizeof(WAVEHDR));
    m_bPaused = false;
    m_bStopped = true;
}

CWave::~CWave(void)
{
    // Close output device
    if (IsValid())
    {
        // Clear sound data buffer
        free(m_lpData);
        m_lpData = NULL;
        m_dwSize = 0;
    }
}

bool CWave::Load(std::string wavFile)
{
    bool bResult = false;



    std::ifstream file;
    file.open(wavFile, std::fstream::in | std::fstream::binary);
    if (file.bad() || !file.is_open())
        return false;

    file.read((char *)this->m_Descriptor.riff, sizeof(this->m_Descriptor.riff));
    file.read((char *)&this->m_Descriptor.size, sizeof(this->m_Descriptor.size));
    file.read((char *)this->m_Descriptor.wave, sizeof(this->m_Descriptor.wave));

    char testChunk[4];

    file.read(testChunk, 4);


    while (strncmp(testChunk, "fmt", 3) != 0 && !file.eof()) {
        file.read(testChunk, 4);
    }
    if (strncmp(testChunk, "fmt", 3) == 0) {
        memcpy(this->m_Format.id, testChunk, sizeof(testChunk));
        file.read((char *)&this->m_Format.size, sizeof(this->m_Format.size));
        file.read((char *)&this->m_Format.format, sizeof(this->m_Format.format));
        file.read((char *)&this->m_Format.channels, sizeof(this->m_Format.channels));
        file.read((char *)&this->m_Format.sampleRate, sizeof(this->m_Format.sampleRate));
        file.read((char *)&this->m_Format.byteRate, sizeof(this->m_Format.byteRate));
        file.read((char *)&this->m_Format.blockAlign, sizeof(this->m_Format.blockAlign));
        file.read((char *)&this->m_Format.bitsPerSample, sizeof(this->m_Format.bitsPerSample));

        if (this->m_Format.size == 18) {
            file.seekg(2, std::ifstream::cur);
        }

        file.read(testChunk, 4);

        while (strncmp(testChunk, "data", 4) != 0 && !file.eof()) {
            file.read(testChunk, 4);
        }
        if (strncmp(testChunk, "data", 4) == 0) {
            file.read((char *)&this->m_dwSize, sizeof(this->m_dwSize));
            if (this->m_dwSize%2 == 1) {
                this->m_dwSize -= 1;
            }
            this->m_lpData = new BYTE[this->m_dwSize];
            memset(this->m_lpData, 0x00, this->m_dwSize*sizeof(BYTE));
            file.read((char *)this->m_lpData, this->m_dwSize);
            file.close();
            bResult = true;
        }
    }

    
    return bResult;
}

