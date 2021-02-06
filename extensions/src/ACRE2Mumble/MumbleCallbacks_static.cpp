#include "Engine.h"
#include "Macros.h"
#include "MumbleFunctions.h"
#include "Player.h"
#include "Types.h"
#include "compat.h"

#ifdef USE_ACRE2UI
#include "UiEngine.hpp"
#endif

#include "Log.h"

const char *mumble_getName() {
    return ACRE_NAME;
}

version_t mumble_getAPIVersion() {
    return MUMBLE_PLUGIN_API_VERSION;
}

version_t mumble_getVersion() {
    return version_t{ACRE_VERSION_MAJOR, ACRE_VERSION_MINOR, ACRE_VERSION_SUBMINOR};
}
