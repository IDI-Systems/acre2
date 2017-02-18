
#include "script_component.hpp"
#define PREP_MENU(menuType) [] call compile preprocessFileLineNumbers QPATHTOF(menus\types\menuType.sqf)


// Menu hash stuff
GVAR(Menus) = HASH_CREATE;

PREP_MENU(Static);
PREP_MENU(Display);
PREP_MENU(List);

PREP_MENU(ActionSeries);
PREP_MENU(Selection);
PREP_MENU(Alphanumeric);
PREP_MENU(Number);
PREP_MENU(Frequency);
PREP_MENU(ChangeValueAck);


PREP_MODULE(menus,onButtonPress);
PREP_MODULE(menus,defaultButtonPress);

PREP_MODULE(menus,changeValueAck);
PREP_MODULE(menus,changeMode);
PREP_MODULE(menus,changeMenu);
PREP_MODULE(menus,renderMenu);
PREP_MODULE(menus,createMenu);

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

PREP_MODULE(menus,delayFunction);
PREP_MODULE(menus,timerFunction);

PREP_MODULE(menus,toggleButtonPressDown);
PREP_MODULE(menus,toggleButtonPressUp);
