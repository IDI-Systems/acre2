---
title: Mission Making Intro
---

## Introduction

When making missions with ACRE2 there are a few things you should be aware of to prevent problems with your missions. For this page we will also assume that you are loosely familiar with the basic features of ACRE, notably [babel](/wiki/user/babel). If you aren't familiar with the basic features of ACRE2 please [read this first](/wiki/user/feature-list). We have split this page up into several parts starting with the basics and simple cases and slowly progressing into more detail, at the end we'll give some full examples.

The default behaviour of ACRE2 is to replace any vanilla radio items (classname: `"ItemRadio"`) (which all the vanilla Arma 3 military units have) with AN/PRC 343 radios. If you want players to have custom radios you must add them yourself. All radios by default are set to the same settings and this allow players on other teams to hear each other on the radios. All players will also start out speaking the same babel language.

*Several modules are provided by ACRE2 to cater for typical simple setups. If you would rather avoid using the API I'd recommend checking them out first.*

For simple mission setups where you just wish to quickly ensure that different teams speak different languages and/or use different radio frequencies so that they can't hear either other on the same channel numbers; we created a simple function you can call.

```
[true, true] call acre_api_fnc_setupMission;
```
The first option is used to indicate if each side should have their own unique language
The second is is used to indicate if the radio channels for each team should be on different frequencies. So that players on other teams can not hear your communications.

Most API calls in ACRE2 only support being called on the client to which they are local. So it is advised to run all ACRE2 for setting up radios and languages in init.sqf so that they are run on all clients.

**List of things you can do with the ACRE2 mission API (but not limited to):**
* Give units different radios
* Change the settings of the radio before the unit gets it (Channel names/frequencies/transmission power)
* Change the radio channel to a particular channel (useful for channel allocation scripts)
* Assign players to speak different languages
* Enable spectator mode (Spectators have their own chat but they can also hear players speaking near their camera position)

## Radio Settings

### How to properly add radios to units

All radios in ACRE2 are items and must be added via the 'addItem' command e.g. 
```
 player addItem "ACRE_PRC343"; 
```
Note: The 'linkItem' command is not supported in ACRE2 as the linked radio slot has been removed by ACRE2. Here is a list the ACRE2 Base radio class-names:
```
ACRE_PRC343
ACRE_PRC148
ACRE_PRC152
ACRE_PRC77
ACRE_PRC117F
```

NOTE: ACRE2 provides every radio that is in use by a player with a unique ID. ACRE2 will automatically replace the base radios with versions that have these IDs. You will most likely break ACRE2 if you attempt to give any unit a radio with an ID, instead only use the base classes listed above.
e.g. "ACRE_PRC343" to "ACRE_PRC343_ID_1"

### How to setup different radio settings

Every radio that a player uses in ACRE2 has its own settings. Every channel on a radio can have different frequencies to that of another radio of the same base type. ACRE2 allows you set the default settings on a radio by creating radio setting 'presets'. ACRE2 by default has 4 presets for every radio with all the frequencies being offset for each preset, so that you can use different presets for different teams without having the teams hearing each other on the same channel numbers. To ensure that a player gets a radio with a specific preset change the default preset before giving the radio e.g.
```
["ACRE_PRC152", "default2"] call acre_api_fnc_setPreset;
player addItem "ACRE_PRC152";
```

List of default preset names (note presets are unique to a base class radio).
```
default
default2
default3
default4
```
`default2`/`default3`/`default4` should be used if you want to have frequencies that are independent of other presets , typically in the case for pvp missions.

You can also create and modify your own presets by copying the default presets. Here we create a new preset 'my_new_preset' from the 'default' preset.
```
["ACRE_PRC152", "default", "my_new_preset"] call acre_api_fnc_copyPreset;
```

You can then edit that preset's channel settings (For a full list of available channel settings see the wiki-page for the radio you are interested in). This example will set the display name of channel 1 on the 152 radio to "PLTNET 1" for the preset 'my_new_preset'.
```
["ACRE_PRC152", "my_new_preset", 1, "label", "PLTNET 1"] call 
acre_api_fnc_setPresetChannelField;
```
The three common channel settings are:
```
label - The channel name typically unused for on radios without screens.
frequencyTX - Frequency (MHz) the channel broadcasts on.
frequencyRX - Frequency (MHz) the channel listens to.
```

Putting this all together, we can give the player a 152 radio that uses frequencies from the default2 preset and changes the display name of channel 1 to 'PLTNET 1':
```
["ACRE_PRC152", "default2", "my_new_preset"] call acre_api_fnc_copyPreset;
["ACRE_PRC152", "my_new_preset", 1, "label", "PLTNET 1"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC152", "my_new_preset", 1, "frequencyRX", 60.1] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC152", "my_new_preset", 1, "frequencyTX", 60.1] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC152", "my_new_preset"] call acre_api_fnc_setPreset;
player addItem "ACRE_PRC152";
```

### Changing the current radio channel on mission start

Another common task is having the radios set to the correct channels at mission start. The ACRE2 API provides a function just for this purpose 'acre_api_fnc_setRadioChannel'. It requires the ID of a specific radio to carry out its task, for example the following would set that specific radio to channel 5.
```
["ACRE_PRC152_ID_123", 5] call acre_api_fnc_setRadioChannel;
```
The challenge here is that the IDs are provided by the server and will be unknown to the mission maker and could be different for different playthroughs of the same mission. The radio IDs are also not provided immediately, so we must wait until the radios are setup. The following code snippet addresses all these problems.
```
waitUntil { ([] call acre_api_fnc_isInitialized) };
[(["ACRE_PRC343"] call acre_api_fnc_getRadioByType), 2] call acre_api_fnc_setRadioChannel;
```
['acre_api_fnc_isInitialized'](/wiki/frameworks/functions-list#acre_api_fnc_isinitialized) will return true once all the radios have been converted to versions with unique IDs. The ['acre_api_fnc_getRadioByType'](/wiki/frameworks/functions-list#acre_api_fnc_getradiobytype) function will take a a radio base class and return the first IDed radio that the local player has matching the radio type.

## Babel

### Simple setup

For setups where you would like to just set the same languages spoken by the entire team you can use the ['acre_api_fnc_babelSetupMission'](/wiki/frameworks/functions-list#acre_api_fnc_babelsetupmission) function.

Example: This function creates the languages and will check the local unit and setup their languages automatically to match the settings.
```
[ [west, "English", "French"], [east, "Russian"], [civilian, "French"] ] call acre_api_fnc_babelSetupMission;
```

### Defining the languages

Babel is straightforward to setup, first you must define the languages available. Here we create three languages to be used, we provide a name to reference with them in code and their display name. Note: You must define all the languages you use for every client.
```
["en","English"] call acre_api_fnc_babelAddLanguageType;
["fa","Farsi"] call acre_api_fnc_babelAddLanguageType;
["gr","Greek"] call acre_api_fnc_babelAddLanguageType;
```

### Setting the speaking languages of a unit

There are two main commands API commands for setting the languages of a unit. Firstly ['acre_api_fnc_babelSetSpokenLanguages'](/wiki/frameworks/functions-list#acre_api_fnc_babelsetspokenlanguages) is used to specify what languages a unit can understand, and then ['acre_api_fnc_babelSetSpeakingLanguage'](/wiki/frameworks/functions-list#acre_api_fnc_babelsetspeakinglanguage) should be used to set the language the unit speaks at mission start.

For a unit we wish to speak 'English' we would call the following of code. 
```
["en"] call acre_api_fnc_babelSetSpokenLanguages;
["en"] call acre_api_fnc_babelSetSpeakingLanguage;
```
If we want a unit to speak multiple languages we can easily add more in:
```
["en", "fa", "gr"] call acre_api_fnc_babelSetSpokenLanguages;
["en"] call acre_api_fnc_babelSetSpeakingLanguage;
```

## Examples

- Included in the `@ACRE2/extras/examples/` folder you should find some sample scripts.
- [ACRE2 API Functions List](functions-list)
