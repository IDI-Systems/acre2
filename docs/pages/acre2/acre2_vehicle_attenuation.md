---
title: Vehicle Attenuation
permalink: acre2_vehicle_attenuation.html
sidebar: acre2_sidebar
folder: acre2
---

Vehicle attenuation is the system where people outside and inside of a vehicle hear each other at reduced volumes. The old implementation was to simply use the `insideSoundCoef` in the vehicle config. This value was used by the game engine to determine the sound level heard internally.

Arma 3 has introduced new config options for sound attenuation that replace the previous system. Every vehicle has a config property `attenuationEffectType` which references an attenuation effect. Each attenuation effect has its own class in `ConfigFile >> CfgSoundEffects >> AttenuationsEffects`. We added a new config parameter for these effects to define the attenuation used in ACRE. If a config does not have one defined it uses the `acreDefaultAttenuation` property. If the value is 1, the sound will be blocked completely and if it is 0 no sound will be absorbed.

Note the system also takes into account the sound effects on a turret using the value of `soundAttenuationTurret`. There is also the option to disable attenuation on a turret using `disableSoundAttenuation = 1;`.

The default config is listed below:

```cpp
class CfgSoundEffects {
    class AttenuationsEffects {
        acreDefaultAttenuation = 0;
        class CarAttenuation {
            acreAttenuation = 0.5;
        };
        class SemiOpenCarAttenuation {
            acreAttenuation = 0;
        };
        class SemiOpenCarAttenuation2 {
            acreAttenuation = 0;
        };
        class OpenCarAttenuation {
            acreAttenuation = 0;
        };
        class TankAttenuation {
            acreAttenuation = 0.6;
        };
        class HeliAttenuation {
            acreAttenuation = 0.6;
        };
        class OpenHeliAttenuation {
            acreAttenuation = 0.1;
        };
        class SemiOpenHeliAttenuation {
            acreAttenuation = 0.4;
        };
        class HeliAttenuationGunner {
            acreAttenuation = 0.15;
        };
        class HeliAttenuationRamp {
            acreAttenuation = 0.15;
        };
        class PlaneAttenuation {
            acreAttenuation = 0.6;
        };
        class RHS_CarAttenuation {
            acreAttenuation = 0.5;
        };
        class CUP_UAZ_CarAttenuation {
            acreAttenuation = 0;
        };
        class CUP_Ural_CarAttenuation {
            acreAttenuation = 0;
        };
    };
};
```

{% include links.html %}
