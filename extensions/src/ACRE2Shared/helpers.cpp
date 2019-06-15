#include "helpers.h"

#pragma comment (lib, "version.lib")
bool getModuleVersion(short &major, short &minor, short &patch) {
#ifdef _WIN32
    // Module version info code donated by dedmen on 2019-06-14
    char fileName[_MAX_PATH];
    const unsigned long sizeFileName = GetModuleFileName(nullptr, fileName, _MAX_PATH);
    fileName[sizeFileName] = NULL;

    unsigned long handle = 0;
    const unsigned long sizeVersionInfo = GetFileVersionInfoSize(fileName, &handle);

    unsigned char* versionInfo = new unsigned char[sizeVersionInfo];
    const bool ret = GetFileVersionInfo(fileName, handle, sizeVersionInfo, versionInfo);

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

    short tsmajor = 0;
    short tsminor = 0;
    short tspatch = 0;
    if (!getModuleVersion(tsmajor, tsminor, tspatch)) {
        return api;
    }

    // API matrix
    if (tsminor == 0) {
        if (tspatch <= 13) {
            api = 19;
        } else if (tspatch <= 19) {
            api = 20;
        } else if (tspatch == 20) {
            api = 21;
        }
    } else if (tsminor <= 2) {
        api = 22;
    } else {
        api = 23;
    }

    return api;
}
