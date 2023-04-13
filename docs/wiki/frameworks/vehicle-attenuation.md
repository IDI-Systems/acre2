---
title: Vehicle Attenuation
---

## Introduction

Vehicle attenuation is the system where people outside and inside of a vehicle hear each other at reduced volumes. The old implementation was to simply use the `insideSoundCoef` in the vehicle config. This value was used by the game engine to determine the sound level heard internally.

Arma 3 has introduced new config options for sound attenuation that replace the previous system.


## Attenuation config

### Attenuation effect types

Every vehicle has a config property `attenuationEffectType` which references an attenuation effect. Each attenuation effect has its own class in `ConfigFile >> CfgSoundEffects >> AttenuationsEffects`. We added new config parameters for these effects to define the attenuation used in ACRE2.

ACRE2 defines two attenuation values in `CfgSoundEffects`:

1. `acreAttenuation`: A value ranging 0-1 which is used to determine the attenuation between people inside and outside of the vehicles.
2. `acreAttenuationTurnedOut`: A value ranging 0-1 which is used to determine the attenuation between people inside (turned in) and turned out in the same vehicle (refers to [isTurnedOut command](https://community.bistudio.com/wiki/isTurnedOut)).

If the value is `1`, the sound will be blocked completely and if it is `0` no sound will be absorbed.

If a config for a specific `attenuationEffectType` does not exist, the default values `acreDefaultAttenuation` and `acreDefaultAttenuationTurnedOut` will be used. The default config can be found on [GitHub](https://github.com/IDI-Systems/acre2/blob/master/addons/sys_attenuate/CfgSoundEffects.hpp).

{% include note.html content="The system also takes into account the sound effects on a turret using the value of `soundAttenuationTurret`. There is also the option to disable attenuation on a turret using `disableSoundAttenuation = 1;`" %}

### Compartments

ACRE2 also provides a system to adjust the attenuation between compartments. A compartment is a virtual space where vehicle seats can be grouped together. A vehicle can have multiple compartments. BI already provides compartments. Each compartment is called `CompartmentX` where `X` is a number. It is up to the developer of the vehicle to use compartments.

ACRE2 adds compartment config parameters for every vehicle that look something like this:

```cpp
class CfgVehicles {
    class ParentVehicle;
    class MyVehicle: ParentVehicle {
        class ACRE {
            // Attenuation between players inside (turned in) separate in compartments
            class attenuation {
                class Compartment1  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment2  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment3  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment4  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
            };

            // Attenuation between a turned out player and turned in player sitting in separate compartments
            class attenuationTurnedOut {
                class Compartment1  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment2  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment3  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment4  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
            };
        };
    };
};
```

In this case the `attenuation` class defines the attenuation between players inside (turned in) separate compartments and `attenuationTurnedOut` between a player which is turned out and one that is sitting inside in a separate compartment.

If two players talk with each other from separate compartments, the attenuation between the speaker and the local unit (listener) 
is first determined by the speaker compartment class and then by the listener compartment parameter (`... >> _speakerCompartment >> _listenerCompartment`).


## Illustration

### IFV with one compartment

Let's illustrate all the attenuation systems. First we will keep it simple and look at a vehicle with only one compartment. The following picture represents all possible scenarios a player can talk to another one. A connection <i class="fa fa-arrows-h fa-lg"></i> of the same color is the same scenario. For easier explanation, we will consider the vehicle an IFV or tank but the concepts are applicable to other types of vehicles too.

{% include image.html file="attenuation/attenuation_one_comp.jpg" alt="IFV attenuation with one compartment" caption="Attenuation system in an IFV with one compartment." %}

Let's start with the person outside the vehicle named Bob who talks to Tom (<span style="color:#74007b">_**violet**_ <i class="fa fa-arrows-h fa-lg"></i></span>). Because Tom is turned out, the attenuation is `0` (hardcoded). If Bob talks to Kim or vice versa (<span style="color:#b147c4">_**pink**_ <i class="fa fa-arrows-h fa-lg"></i></span>) the attenuation value is `acreAttenuation` which is defined in the config `ConfigFile >> CfgSoundEffects >> AttenuationsEffects >> TankAttenuation >> acreAttenuation`. In our case this value is `0.6`.

Because everyone is in one compartment, there is no attenuation (hardcoded) between Chad, Jim and Kim (<span style="color:#30509e">_**blue**_ <i class="fa fa-arrows-h fa-lg"></i></span>).

Tom and Hans are turned out. All players turned out have no attenuation (hardcoded) between them (<span style="color:#277131">_**green**_ <i class="fa fa-arrows-h fa-lg"></i></span>). If Tom or Hans talk to someone inside e.g. Jim (<span style="color:#804400">_**brown**_ <i class="fa fa-arrows-h fa-lg"></i></span>) the attenuation value is `acreAttenuationTurnedOut` defined in `ConfigFile >> CfgSoundEffects >> AttenuationsEffects >> TankAttenuation >> acreAttenuationTurnedOut`, so `0.3`.

### IFV with two compartments

Now let's split the vehicle in two compartments. Hans and Chad will be in `Compartment1` and Jim, Kim, Tom will be in `Compartment2`. The scenarios for Bob did not change, so we leave him out.

{% include image.html file="attenuation/attenuation_two_comp.jpg" alt="IFV attenuation with two compartments" caption="Attenuation system in an IFV with two compartments." %}

Chad talks to Jim (<span style="color:#cf0808">_**red**_ <i class="fa fa-arrows-h fa-lg"></i></span>). Because they are in separate compartments the attenuation value is looked up in the config `ConfigFile >> CfgVehicles >> myTank >> ACRE >> attenuation >> Compartment1 >> Compartment2` (from the perspective of Jim) which is `1` meaning that Jim cannot hear Chad. 

The same applies between Hans and Jim (<span style="color:#e3aa2b">_**yellow**_ <i class="fa fa-arrows-h fa-lg"></i></span>) 
but the config `ConfigFile >> CfgVehicles >> myTank >> ACRE >> attenuationTurnedOut >> Compartment1 >> Compartment2` is looked up which is also `1`.

{% include note.html content="The path in the <span style='color:#e3aa2b'>_**yellow**_</span> scenario is different because the value is looked up in the `attenuationTurnedOut` class instead of `attenuation`." %}
