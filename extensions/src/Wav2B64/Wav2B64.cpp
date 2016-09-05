// Wav2B64.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
/* 
   base64.cpp and base64.h

   Copyright (C) 2004-2008 René Nyffenegger

   This source code is provided 'as-is', without any express or implied
   warranty. In no event will the author be held liable for any damages
   arising from the use of this software.

   Permission is granted to anyone to use this software for any purpose,
   including commercial applications, and to alter it and redistribute it
   freely, subject to the following restrictions:

   1. The origin of this source code must not be misrepresented; you must not
      claim that you wrote the original source code. If you use this source code
      in a product, an acknowledgment in the product documentation would be
      appreciated but is not required.

   2. Altered source versions must be plainly marked as such, and must not be
      misrepresented as being the original source code.

   3. This notice may not be removed or altered from any source distribution.

   René Nyffenegger rene.nyffenegger@adp-gmbh.ch

*/

#define _CRT_SECURE_NO_WARNINGS 1
#include <iostream>
#include <fstream>
#include <vector>
#include "Wave.h"

static const std::string base64_chars = 
             "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
             "abcdefghijklmnopqrstuvwxyz"
             "0123456789+/";


static inline bool is_base64(unsigned char c) {
  return (isalnum(c) || (c == '+') || (c == '/'));
}

std::string base64_encode(unsigned char const* bytes_to_encode, unsigned int in_len) {
  std::string ret;
  int i = 0;
  int j = 0;
  unsigned char char_array_3[3];
  unsigned char char_array_4[4];

  while (in_len--) {
    char_array_3[i++] = *(bytes_to_encode++);
    if (i == 3) {
      char_array_4[0] = (char_array_3[0] & 0xfc) >> 2;
      char_array_4[1] = ((char_array_3[0] & 0x03) << 4) + ((char_array_3[1] & 0xf0) >> 4);
      char_array_4[2] = ((char_array_3[1] & 0x0f) << 2) + ((char_array_3[2] & 0xc0) >> 6);
      char_array_4[3] = char_array_3[2] & 0x3f;

      for(i = 0; (i <4) ; i++)
        ret += base64_chars[char_array_4[i]];
      i = 0;
    }
  }

  if (i)
  {
    for(j = i; j < 3; j++)
      char_array_3[j] = '\0';

    char_array_4[0] = (char_array_3[0] & 0xfc) >> 2;
    char_array_4[1] = ((char_array_3[0] & 0x03) << 4) + ((char_array_3[1] & 0xf0) >> 4);
    char_array_4[2] = ((char_array_3[1] & 0x0f) << 2) + ((char_array_3[2] & 0xc0) >> 6);
    char_array_4[3] = char_array_3[2] & 0x3f;

    for (j = 0; (j < i + 1); j++)
      ret += base64_chars[char_array_4[j]];

    while((i++ < 3))
      ret += '=';

  }

  return ret;

}

std::vector<char> base64_decode(std::string const& encoded_string) {
  int in_len = encoded_string.size();
  int i = 0;
  int j = 0;
  int in_ = 0;
  unsigned char char_array_4[4], char_array_3[3];
  //std::string ret;
  std::vector<char> ret;
  

  while (in_len-- && ( encoded_string[in_] != '=') && is_base64(encoded_string[in_])) {
    char_array_4[i++] = encoded_string[in_]; in_++;
    if (i ==4) {
      for (i = 0; i <4; i++)
        char_array_4[i] = base64_chars.find(char_array_4[i]);

      char_array_3[0] = (char_array_4[0] << 2) + ((char_array_4[1] & 0x30) >> 4);
      char_array_3[1] = ((char_array_4[1] & 0xf) << 4) + ((char_array_4[2] & 0x3c) >> 2);
      char_array_3[2] = ((char_array_4[2] & 0x3) << 6) + char_array_4[3];

      for (i = 0; (i < 3); i++)
        ret.push_back(char_array_3[i]);
      i = 0;
    }
  }

  if (i) {
    for (j = i; j <4; j++)
      char_array_4[j] = 0;

    for (j = 0; j <4; j++)
      char_array_4[j] = base64_chars.find(char_array_4[j]);

    char_array_3[0] = (char_array_4[0] << 2) + ((char_array_4[1] & 0x30) >> 4);
    char_array_3[1] = ((char_array_4[1] & 0xf) << 4) + ((char_array_4[2] & 0x3c) >> 2);
    char_array_3[2] = ((char_array_4[2] & 0x3) << 6) + char_array_4[3];

    for (j = 0; (j < i - 1); j++) ret.push_back(char_array_3[j]);
  }

  return ret;
}


int _tmain(int argc, wchar_t* argv[])
{
    CWave checkFile;

    //printf("Loading check: %d", checkFile.Load("d:\\mic_click_other_off.wav"));
    if(argc < 2) {
        printf("Converts Wav Files into ACRE Base64 encoded sound files.\n\nUsage: Wav2B64.exe input.wav [output.b64]\n");
        return 0;
    }
    std::string inputFile = std::string((char *)argv[1]);
    std::string outputFile;
    
    std::string checkType = inputFile.substr(inputFile.length()-4);
    if(checkType.compare(".wav") != 0) {
        printf("Incorrect Input: %s\n\nInput must be .wav file.\n", inputFile.c_str());
        return 0;
    }
    if(argc == 3) {
        outputFile = std::string((char *)argv[2]);
    } else {
        outputFile = inputFile.substr(0, inputFile.length()-4);
        outputFile += ".b64";
    }

    
    

    std::ifstream file(inputFile, std::ios::in | std::ios::binary | std::ios::ate);
    if(!file.is_open()) {
        printf("Unable to open/find input file: %s\n", inputFile.c_str());
        return 0;
    }

    checkFile.Load(inputFile);

    if(checkFile.GetChannels() > 1) {
        printf("Input must be a mono channel PCM wav file.\n");
        return 0;
    }

    if(checkFile.GetBitsPerSample() != 16) {
        printf("Input must be a 16bit PCM wav file.\n");
        return 0;
    }

    if(checkFile.GetSampleRate() != 48000) {
        printf("Input must have a sample rate of 48Khz.\n");
        return 0;
    }

    

    std::ofstream out(outputFile, std::ios::out);
    if(!out.is_open()) {
        printf("Unable to open/find output file: %s\n", outputFile.c_str());
        return 0;
    }

    

    std::streampos size = file.tellg();
    char *memblock = new char[size];
    printf("Loading input (%s): ", inputFile.c_str());
    file.seekg(0, std::ios::beg);
    file.read(memblock, size);
    file.close();
    printf("complete\n");
    printf("Encoding: ");
    std::string b64 = base64_encode(reinterpret_cast<unsigned const char *>(memblock), size);
    
    std::string output = "ACRE_B64_FILE = [\n";
    int count = ceil(b64.length()/2048);
    for(int x = 0; x <= count; ++x) {
        output += "\t\""; 
        output += b64.substr(x*2048, 2048);
        output += "\",\n";
    }
    output += "\t\"\"\n];";
    printf("complete\n");
    printf("Writing output (%s): ", outputFile.c_str());
    out.write(&output[0], output.length());
    out.close();
    printf("complete\n");
    printf("Done!\n");

    return 0;
}

