#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

DFUNC(getAntennaDirMan) = {
    private ["_forwardV", "_upV"];
    params ["_obj"];
    //@TODO: This is a hack fix for vehicles having funky up vectors when people are inside...
    if(vehicle _obj == _obj) then {
        _spinePos = (_obj selectionPosition "Spine3");
        _upV = _spinePos vectorFromTo (_obj selectionPosition "Neck");

        _upP = _upV call cba_fnc_vect2polar;
        _upP set[2, (_upP select 2)-90];
        _forwardV = _upP call cba_fnc_polar2vect;

        _forwardV = (ATLtoASL (_obj modelToWorldVisual _spinePos)) vectorFromTo (ATLtoASL (_obj modelToWorldVisual (_spinePos vectorAdd _forwardV)));
        _upV = (ATLtoASL (_obj modelToWorldVisual _spinePos)) vectorFromTo (ATLtoASL (_obj modelToWorldVisual (_spinePos vectorAdd _upV)));
    } else {
        _forwardV = vectorDir (vehicle _obj);
        _upV = vectorUp (vehicle _obj);
    };
    [_forwardV, _upV];
};

ADDON = true;
