#include "StdAfx.h"
#include "Wave.h"
#include "math.h"
#include <fstream>


CWave::CWave(void)
{
    // Init members
    memset(&m_descriptor, 0, sizeof(__waveDescr));
    memset(&m_format, 0, sizeof(__waveFormat));
    m_lpData = NULL;
    m_dwSize = 0;
    m_hWaveout = NULL;
    memset(&m_waveHeader, 0, sizeof(WAVEHDR));
    m_bPaused = false;
    m_bStopped = true;
}

CWave::~CWave(void)
{
    // Close output device
    if (isValid()) {
        // Clear sound data buffer
        free(m_lpData);
        m_lpData = NULL;
        m_dwSize = 0;
    }
}

bool CWave::load(std::string wavFile)
{
    bool bResult = false;
    
    std::ifstream file(wavFile, std::fstream::in | std::fstream::binary);

    file.seekg (0, file.end);
    int32_t length = (int32_t) file.tellg();
    file.seekg (0, file.beg);

    file.read((char *)this->m_descriptor.riff, sizeof(this->m_descriptor.riff));
    file.read((char *)&this->m_descriptor.size, sizeof(this->m_descriptor.size));
    file.read((char *)this->m_descriptor.wave, sizeof(this->m_descriptor.wave));

    char testChunk[4];

    file.read(testChunk, 4);

    while (strncmp(testChunk, "fmt", 3) != 0 && !file.eof()) {
        file.read(testChunk, 4);
    }
    if (strncmp(testChunk, "fmt", 3) == 0) {
        memcpy(this->m_format.id, testChunk, sizeof(testChunk));
        file.read((char *)&this->m_format.size, sizeof(this->m_format.size));
        file.read((char *)&this->m_format.format, sizeof(this->m_format.format));
        file.read((char *)&this->m_format.channels, sizeof(this->m_format.channels));
        file.read((char *)&this->m_format.sampleRate, sizeof(this->m_format.sampleRate));
        file.read((char *)&this->m_format.byteRate, sizeof(this->m_format.byteRate));
        file.read((char *)&this->m_format.blockAlign, sizeof(this->m_format.blockAlign));
        file.read((char *)&this->m_format.bitsPerSample, sizeof(this->m_format.bitsPerSample));

        if (this->m_format.size == 18) {
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
            file.read((char *)this->m_lpData, this->m_dwSize);
            file.close();
            bResult = true;
        }
    }

    return bResult;
}

