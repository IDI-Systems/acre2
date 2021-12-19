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

struct MumbleStringWrapper mumble_getName() {
	static const char *name = ACRE_NAME;

	MumbleStringWrapper wrapper;
	wrapper.data = name;
	wrapper.size = strlen(name);
	wrapper.needsReleasing = false;

    return wrapper;
}

mumble_version_t mumble_getAPIVersion() {
    return MUMBLE_PLUGIN_API_VERSION;
}

mumble_version_t mumble_getVersion() {
    return mumble_version_t{ACRE_VERSION_MAJOR, ACRE_VERSION_MINOR, ACRE_VERSION_SUBMINOR};
}

mumble_version_t mumble_getPluginFunctionsVersion() {
    return MUMBLE_PLUGIN_FUNCTIONS_VERSION;
}