#pragma once

#include "MumbleAPI_v_1_0_x.h"
#define MUMBLE_PLUGIN_NO_DEFAULT_FUNCTION_DEFINITIONS
#include "MumblePlugin_v_1_1_x.h"


#include <Tracy.hpp>

#ifndef TRACY_ENABLE
#define API_CALL(function, ...)             mumAPI.function(__VA_ARGS__)
#else
#define API_CALL(function, ...)                               \
    [&]() mutable {                                           \
        ZoneScopedN("Mumble API function \"" #function "\""); \
        return mumAPI.function(__VA_ARGS__);                  \
    }()
#endif
