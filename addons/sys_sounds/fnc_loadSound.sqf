#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Loads a b64 sound into the voice extension. Once loaded the sound will always be available.
 *
 * Arguments:
 * 0: Sound classname (in CfgAcreSounds) <STRING>
 * 1: Return function <CODE>
 * 2: Force <BOOL> - Forces the sound to be loaded again.
 *
 * Return Value:
 * None
 *
 * Example:
 * ["Acre_GenericClick"] call acre_sys_sounds_fnc_loadSound
 *
 * Public: No
 */

params ["_className", ["_returnFunction", nil], ["_force", false]];

if (_className in GVAR(loadedSounds) && {!_force}) exitWith {};

private _fileName = getText (configFile >> "CfgAcreSounds" >> _className >> "sound");
if (_fileName == "") exitWith {};

// The file sets ACRE_B64_FILE to the base64 WAV, in pieces.
[] call (compile loadFile _fileName);
if (isNil "ACRE_B64_FILE") exitWith {};
private _base64 = ACRE_B64_FILE joinString "";
ACRE_B64_FILE = nil;

TRACE_2("Loading sound",_className,_fileName);
if (!isNil "_returnFunction") then {
    HASH_SET(GVAR(callBacks),_className,_returnFunction);
};
private _ok = (["sound:load", [_className, _base64]] call EFUNC(sys_io,ext)) == "true";
[_className, ["0", "1"] select _ok] call FUNC(handleLoadedSound);
