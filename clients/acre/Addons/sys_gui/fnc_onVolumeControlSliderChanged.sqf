#include "script_component.hpp"

GVAR(VolumeControl_Level) = round (_this select 1);
call FUNC(setVolumeSliderColor);