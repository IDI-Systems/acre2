#include "helpers.h"

#pragma comment (lib, "version.lib")
bool getModuleVersion(int16_t *const major, int16_t *const minor, int16_t *const patch) {
#ifdef _WIN32
    // Module version info code originally donated by dedmen on 2019-06-14
    char fileName[_MAX_PATH];
    if (fileName == nullptr) {
        return false;
    }
    const uint64_t sizeFileName = GetModuleFileName(nullptr, fileName, _MAX_PATH);
    fileName[sizeFileName] = NULL;

    unsigned long handle = 0;
    const uint64_t sizeVersionInfo = GetFileVersionInfoSize(fileName, &handle);

    uint8_t* versionInfo = new uint8_t[sizeVersionInfo];
    if (versionInfo == nullptr) {
        return false;
    }
    const bool ret = GetFileVersionInfo(fileName, handle, sizeVersionInfo, versionInfo);

    if (ret) {
        uint32_t len = 0;
        VS_FIXEDFILEINFO* vsfi = nullptr;
        VerQueryValueW(versionInfo, L"\\", reinterpret_cast<void**>(&vsfi), &len);

        *major = HIWORD(vsfi->dwFileVersionMS);
        *minor = LOWORD(vsfi->dwFileVersionMS);
        *patch = HIWORD(vsfi->dwFileVersionLS);
    }

    delete[] versionInfo;
    return ret;

#else
    // TODO Linux version reading if we ever release Linux extensions
    return false;
#endif
}

int32_t getTSAPIVersion() {
    int32_t api = TS3_PLUGIN_API_VERSION;

    int16_t tsmajor = 0;
    int16_t tsminor = 0;
    int16_t tspatch = 0;
    if (!getModuleVersion(&tsmajor, &tsminor, &tspatch)) {
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
        api = 22; // 3.2.x
    } else if (tsminor <= 3) {
        api = 23; // 3.3.x
    } else if (tsminor <= 5) {
        api = 24; // 3.5.x
        // 25 is backwards compatible with 24
    } else {
        api = 26; // 3.6.x
    }

    return api;
}
