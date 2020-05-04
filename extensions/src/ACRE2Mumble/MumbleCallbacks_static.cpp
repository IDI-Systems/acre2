#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "Engine.h"
#include "Player.h"


#include "MumbleFunctions.h"

#ifdef USE_ACRE2UI
    #include "UiEngine.hpp"
#endif

#include "Log.h"

const char* mumble_getName() {
    return ACRE_NAME;
}

version_t mumble_getAPIVersion() {
    return MUMBLE_PLUGIN_API_VERSION;
}


