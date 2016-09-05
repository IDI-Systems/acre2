
#include "script_component.hpp"

ADDON = false;

PREP_FOLDER(radio);

PREP(initializeRadio);
PREP(openGui);
PREP(closeGui);
PREP(render);
PREP(formatChannelValue);
PREP(preset_information);

PREP_FOLDER(menus);
PREP_FOLDER(farris_menus);


// *******************************
// DATA PREPERATION
//
[] call FUNC(preset_information);

GVAR(currentRadioId) = -1;

DFUNC(onKnobMouseEnter) = {
    
};
DFUNC(onKnobMouseExit) = {
    
};

ADDON = true;
