---
title: Babel
---

The Babel System uses a local API system that must be executed on all clients equally except for where the definition of a individual persons language is concerned, which can differ between clients. Language IDs are sent during the start of speaking events, with non-timely updates applied if a person changes languages in the middle of a conversation. It is imperative that languages be added in the same order on all machines, including JIP, otherwise the numerical values sent during speaking events will not match their literal values on the client. It is best to avoid manipulating the list of languages available after mission init or JIP init.

The following code snippet, will take care of unit side switching. It can be useful for Zeus controlled AI that need to speak a different language than the actual player unit.

```C++
["unit", {
    params ["_player"];
    switch ((getNumber (configFile >> "CfgVehicles" >> (typeOf _player) >> "side"))) do {
        case 1: { ["en"] call acre_api_fnc_babelSetSpokenLanguages; };
        case 0: { ["ru"] call acre_api_fnc_babelSetSpokenLanguages; };
        case 2: { ["ab"] call acre_api_fnc_babelSetSpokenLanguages; };
        default {  ["ab","en","ru"] call acre_api_fnc_babelSetSpokenLanguages; };
    };
}, true] call CBA_fnc_addPlayerEventHandler;
```