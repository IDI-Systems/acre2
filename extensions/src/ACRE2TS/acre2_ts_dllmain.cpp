//#include "compat.h"
//#include "Log.h"
#include "TsFunctions.h"

TS3Functions ts3Functions;

#pragma comment(lib, "x3daudio.lib")
#pragma comment(lib, "shlwapi.lib")

/*
[module(dll, name="acre2", version="1.0")];


bool WINAPI DllMain(HINSTANCE hInst,uint32_t reason,LPVOID) {

    if (reason == DLL_PROCESS_ATTACH){
        //g_Log = (Log *)new Log("acre.log");
    }
    if (reason == DLL_PROCESS_DETACH) { 
        
    }
    return 1;
}
*/