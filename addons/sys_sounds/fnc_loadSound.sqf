#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Function to send a b64 sound to the teamspeak plugin to be loaded. Once loaded the sound will always be available.
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

params ["_className",["_returnFunction",nil],["_force",false]];

// If teamspeak is connected.
if (EGVAR(sys_core,ts3id) != -1) then { 
    if (!(_className in GVAR(loadedSounds)) && {!_force}) then {
        private _fileName = getText(configFile >> "CfgAcreSounds" >> _className >> "sound");
        if (_fileName != "") then {
            [] call (compile loadFile _fileName);
            if (!isNil "ACRE_B64_FILE") then {
                TRACE_2("Lounding Sound File", _className, _fileName);
                if (!isNil "_returnFunction") then {
                    HASH_SET(GVAR(callBacks),_className,_returnFunction);
                };
                {
                    ["loadSound", [_className, _forEachIndex+1, count(ACRE_B64_FILE), _x]] call EFUNC(sys_rpc,callRemoteProcedure);
                } forEach ACRE_B64_FILE;
                ACRE_B64_FILE = nil;
                TRACE_2("Sound File Sent", _className, _fileName);
            };
        };
    };
} else {
    //teamspeak is not connected store in a buffer.
    if (isNil QGVAR(soundLoadBuffer)) then {
        GVAR(soundLoadBuffer) = [_this];
        [{EGVAR(sys_core,ts3id) != -1}, {
            {
                _x call FUNC(loadSound);
            } forEach (GVAR(soundLoadBuffer));
            GVAR(soundLoadBuffer) = nil;
        },[]] call CBA_fnc_waitUntilAndExecute;
    } else {
        GVAR(soundLoadBuffer) pushBackUnique _this;
    };
};
