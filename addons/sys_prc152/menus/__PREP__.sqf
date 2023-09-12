#include "..\script_component.hpp"

PREP_MODULE(menus,defaultButtonPress);
PREP_MODULE(menus,onButtonPress);

PREP_MODULE(menus,changeMode);
PREP_MODULE(menus,changeValueAck);
PREP_MODULE(menus,changeMenu);
PREP_MODULE(menus,renderMenu);
PREP_MODULE(menus,createMenu);
PREP_MODULE(menus,verifyIsMenu);

PREP_MODULE(menus,clearDisplay);
PREP_MODULE(menus,formatText);
PREP_MODULE(menus,renderText);
PREP_MODULE(menus,setRowText);
PREP_MODULE(menus,drawCursor);
PREP_MODULE(menus,toggleIcon);

PREP_MODULE(menus,dynamicCall);
PREP_MODULE(menus,callCompleteFunctor);
PREP_MODULE(menus,callEntryFunctor);
PREP_MODULE(menus,callButtonFunctor);
PREP_MODULE(menus,callRenderFunctor);
PREP_MODULE(menus,callSingleActionCompleteFunctor);

PREP_MODULE(menus,toggleButtonPressDown);
PREP_MODULE(menus,toggleButtonPressUp);

PREP_MODULE(menus,delayFunction);
PREP_MODULE(menus,timerFunction);

// Performance counters
CREATE_COUNTER(buttonPress);
CREATE_COUNTER(clearDisplay);

CREATE_COUNTER(renderText);
CREATE_COUNTER(setRowText);
CREATE_COUNTER(formatText);

CREATE_COUNTER(renderMenu_Display);

CREATE_COUNTER(renderMenu_Static);
CREATE_COUNTER(renderMenu_Static_setText);
CREATE_COUNTER(renderMenu_Static_Functor);

CREATE_COUNTER(onButtonPress_Display_GuiEvents);
CREATE_COUNTER(onButtonPress_Display_PRE_UP);
CREATE_COUNTER(onButtonPress_Display_PRE_DOWN);
