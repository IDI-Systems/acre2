#include "script_component.hpp"

params ["_display"];

// Key handling compatibility for Vanilla Spectator (EG Spectator)
[_display] call FUNC(addDisplayPassthroughKeys);
