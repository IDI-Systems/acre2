/*
 * acreAttenuation: Use this to determine the attenution between people inside and outside vehicles.
 * acreAttenuationTurnedOut: Use this to determine the attenution between people inside (turned in) and turned out in a vehicle (refers to isTurnedOut command).
 */

class CfgSoundEffects {
    class AttenuationsEffects {
        acreDefaultAttenuation = 0;
        acreDefaultAttenuationTurnedOut = 0;

        class CarAttenuation {
            acreAttenuation = 0.5;
            acreAttenuationTurnedOut = 0.25;
        };
        class SemiOpenCarAttenuation {
            acreAttenuation = 0;
            acreAttenuationTurnedOut = 0;
        };
        class SemiOpenCarAttenuation2 {
            acreAttenuation = 0;
            acreAttenuationTurnedOut = 0;
        };
        class OpenCarAttenuation {
            acreAttenuation = 0;
            acreAttenuationTurnedOut = 0;
        };
        class TankAttenuation {
            acreAttenuation = 0.6;
            acreAttenuationTurnedOut = 0.3;
        };
        class HeliAttenuation {
            acreAttenuation = 0.6;
            acreAttenuationTurnedOut = 0.3;
        };
        class OpenHeliAttenuation {
            acreAttenuation = 0.1;
            acreAttenuationTurnedOut = 0.05;
        };
        class SemiOpenHeliAttenuation {
            acreAttenuation = 0.4;
            acreAttenuationTurnedOut = 0.2;
        };
        class HeliAttenuationGunner {
            acreAttenuation = 0.15;
            acreAttenuationTurnedOut = 0.075;
        };
        class HeliAttenuationRamp {
            acreAttenuation = 0.15;
            acreAttenuationTurnedOut = 0.075;
        };
        class PlaneAttenuation {
            acreAttenuation = 0.6;
            acreAttenuationTurnedOut = 0.3;
        };
        class RHS_CarAttenuation {
            acreAttenuation = 0.5;
            acreAttenuationTurnedOut = 0.25;
        };
        class CUP_UAZ_CarAttenuation {
            acreAttenuation = 0;
            acreAttenuationTurnedOut = 0;
        };
        class CUP_Ural_CarAttenuation {
            acreAttenuation = 0;
            acreAttenuationTurnedOut = 0;
        };
    };
};
