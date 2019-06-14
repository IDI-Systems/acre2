#include "helpers.h"

#pragma comment (lib, "version.lib")
bool getModuleVersion(short &major, short &minor, short &patch) {
#ifdef _WIN32
    // Module version info code donated by dedmen on 2019-06-14
    char fileName[_MAX_PATH];
    auto size = GetModuleFileName(nullptr, fileName, _MAX_PATH);

    fileName[size] = NULL;
    unsigned long handle = 0;
    size = GetFileVersionInfoSize(fileName, &handle);

    unsigned char* versionInfo = new unsigned char[size];
    bool ret = GetFileVersionInfo(fileName, handle, size, versionInfo);

    if (ret) {
        unsigned int len = 0;
        VS_FIXEDFILEINFO* vsfi = nullptr;
        VerQueryValueW(versionInfo, L"\\", reinterpret_cast<void**>(&vsfi), &len);

        major = HIWORD(vsfi->dwFileVersionMS);
        minor = LOWORD(vsfi->dwFileVersionMS);
        patch = HIWORD(vsfi->dwFileVersionLS);
    }

    delete[] versionInfo;
    return ret;

#else
    // TODO Linux version reading if we ever release Linux extensions
    return false;
#endif
}

int getTSAPIVersion() {
    int api = TS3_PLUGIN_API_VERSION;

    short tsmajor, tsminor, tspatch;
    if (!getModuleVersion(tsmajor, tsminor, tspatch)) {
        return api;
    }

    // API matrix
    if (tsminor == 0) {
        if      (tspatch <= 13) api = 19;
        else if (tspatch <= 19) api = 20;
        else if (tspatch == 20) api = 21;
    }
    else if (tsminor <= 2) api = 22;
    else if (tsminor >= 3) api = 23;

    return api;
}
