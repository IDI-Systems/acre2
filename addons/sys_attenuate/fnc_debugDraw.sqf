#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Draws debug information and hints about attenuation values
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_attenuate_fnc_debugDraw;
 *
 * Public: No
 */

private _speakers = allUnits;
private _vehicleSpeakers = (_speakers) select {_x in (crew (vehicle acre_player))};
private _outsideSpeakers = (_speakers - _vehicleSpeakers);

private _hintMsg = [];
_hintMsg pushBack "<t align='left' size='1.15' color='#68bbff' font='PuristaMedium'>ACRE Attenuation</t><br/><br />";

// Print player's vehicle role and compartment
if (!isNull objectParent acre_player) then {
    _hintMsg pushBack "<t align='left' size='1.15' color='#68bbff' font='PuristaMedium'>Vehicle</t><br/>";
    {
        _hintMsg pushBack (format ["<t align='left' font='PuristaMedium'>%1</t><t align='right' font='PuristaBold'>%2</t><br/>", 
            format ["%1 (%2, %3)", name _x select [0, 10], [_x] call CBA_fnc_vehicleRole, [_x] call acre_sys_core_fnc_getCompartment],
            ([_x] call acre_sys_attenuate_fnc_getUnitAttenuate)
        ]);
    } forEach _vehicleSpeakers;
};

// Print speakers or outside speakers and their roles
private _fnc_getSpeakerText = {
    params ["_unit"];

    private _name = name _unit select [0, 10];
    if (!isNull objectParent _unit) then {
        _name = _name + format[" <t color='#0051a1'>(vehicle, %1)</t>", [_unit] call CBA_fnc_vehicleRole];
    };

    format ["<t align='left' font='PuristaMedium'>%1</t><t align='right' font='PuristaBold'>%2</t><br/>", 
        _name,
        ([_unit] call acre_sys_attenuate_fnc_getUnitAttenuate)
    ]
};

if (count _outsideSpeakers > 0) then {
    _hintMsg pushBack (format["<t align='left' size='1.15' color='#68bbff' font='PuristaMedium'>%1</t><br/>", ["Outside", "Speakers"] select (isNull objectParent acre_player)]);
    {
        _hintMsg pushBack ([_x] call _fnc_getSpeakerText);
    } forEach _outsideSpeakers;
};

_hintMsg pushBack "<br/>";

// Print vehicle classname and compartment config values
private _type = typeOf (vehicle acre_player);
private _config = configFile >> "CfgVehicles" >> (typeOf (vehicle acre_player));
private _compartments = ["Compartment1","Compartment2","Compartment3","Compartment4"] apply {
    ["", _x] select (isClass (_config >> "ACRE" >> "attenuation" >> _x))
};
_compartments = _compartments - [""];

private _compartmentsCount = count _compartments;
if (_compartmentsCount > 0) then {
    _hintMsg pushBack (format["<t align='left' size='1.15' color='#68bbff' font='PuristaMedium'>%1</t><br/>", _type]);
};

{
    private _rootAtt = _x;
    private _attConfig = _config >> "ACRE" >> "attenuation" >> _rootAtt;

    _hintMsg pushBack (format ["<t align='left' size='1.15' color='#68bbff' font='PuristaMedium'>%1</t><br/>", _rootAtt]);

    {
        private _attenuation = getNumber(_attConfig >> _x);
        if (_attenuation > 0) then {
            _hintMsg pushBack (format ["<t align='left' font='PuristaMedium'> %2 = %3",  _rootAtt select [11], _x select [11], _attenuation]);
            
            if (_forEachIndex == (_compartmentsCount - 1)) then {
                _hintMsg pushBack "</t>";
            } else {
                _hintMsg pushBack "    |  </t>";
            };
        };
    } forEach _compartments;
    _hintMsg pushBack "<br/>";
} forEach _compartments;

_compartmentsTurnedOut = ["Compartment1","Compartment2","Compartment3","Compartment4"] apply {
    ["", _x] select (isClass (_config >> "ACRE" >> "attenuationTurnedOut" >> _x))
};
_compartmentsTurnedOut = _compartmentsTurnedOut - [""];

private _compartmentsTurnedOutCount = count _compartmentsTurnedOut;
if (_compartmentsTurnedOutCount > 0) then {
    _hintMsg pushBack (format ["<t align='left' size='1.15' color='#0051a1' font='PuristaMedium'>%1</t><br/>", "Turned Out"]);
};

{
    private _rootAtt = _x;
    private _attConfig = _config >> "ACRE" >> "attenuationTurnedOut" >> _rootAtt;

    _hintMsg pushBack (format ["<t align='left' size='1.15' color='#68bbff' font='PuristaMedium'>%1</t><br/>", _x]);

    {
        private _attenuation = getNumber(_attConfig >> _x);
        if (_attenuation > 0) then {
            _hintMsg pushBack (format ["<t align='left' font='PuristaMedium'> %2 = %3",  _rootAtt select [11], _x select [11], _attenuation]);
            
            if (_forEachIndex == (_compartmentsCount - 1)) then {
                _hintMsg pushBack "</t>";
            } else {
                _hintMsg pushBack "    |  </t>";
            };
        };
    } forEach _compartmentsTurnedOut;
    _hintMsg pushBack "<br/>";
} forEach _compartmentsTurnedOut;

hintSilent parseText (_hintMsg joinString "");

// Draw attenuation values for all speakers
{
    private _dir = (getDir (missionNamespace getVariable ["BIS_DEBUG_CAM", acre_player])) - (getDir _x);
    private _atten = [_x] call acre_sys_attenuate_fnc_getUnitAttenuate;
    private _color = [0, 1 - _atten, _atten, _atten + .6];
    private _text = format ["%1: %2", (name _x) select [0,10], _atten];
    drawIcon3D ["\a3\ui_f\data\GUI\Cfg\Hints\icon_text\group_1_ca.paa", _color, _x modelToWorldVisual [0,0,0], 1, 1, _dir, _text, 1, 0.04, "RobotoCondensed"];
} forEach _speakers;
