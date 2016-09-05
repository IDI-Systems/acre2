#include "compat.h"
//#include "Log.h"
#include "macros.h"
#include <string>
#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <algorithm>
#include "shlobj.h"
#include "Shlwapi.h"
#include <algorithm> 
#include <functional> 
#include <cctype>
#include <locale>



#pragma comment(lib, "shlwapi.lib")




void ClosePipe();

extern "C" 
{
  __declspec(dllexport) void __stdcall RVExtension(char *output, int outputSize, const char *function); 
};



void __stdcall RVExtension(char *output, int outputSize, const char *function)
{
	size_t id_length = 1;
	std::string functionStr = std::string(function);

	if (functionStr.length() > 1) {
		if (isdigit(functionStr.substr(1, 1).c_str()[0])) {
			id_length = 2;
		}
	}

	std::string id = functionStr.substr(0, id_length);
	std::string params;
	if (functionStr.length() > 1) {
		params = functionStr.substr(id_length, functionStr.length() - id_length);
	}

	int command = atoi(id.c_str());

	switch (command) {

	}
}


void Init(void) {

}

void Cleanup(void) {

}


BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
					 )
{
	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
		Init();
		break;
	case DLL_THREAD_ATTACH:
	case DLL_THREAD_DETACH:
	case DLL_PROCESS_DETACH:
		Cleanup();
		break;
	}
	return TRUE;
}
