#define DEFINE_FUNCTION(x) class x {  file = PATHTOF(DOUBLES(fnc,x).sqf);  }

class CfgFunctions {
    class ADDON {
        class General {
            DEFINE_FUNCTION(isInitialized);

            DEFINE_FUNCTION(setupMission);

            DEFINE_FUNCTION(getMultiPushToTalkAssignment);
            DEFINE_FUNCTION(setMultiPushToTalkAssignment);

            DEFINE_FUNCTION(setPTTDelay);
            DEFINE_FUNCTION(getPTTDelay);

            DEFINE_FUNCTION(setRevealToAI);
            DEFINE_FUNCTION(getRevealToAI);

            DEFINE_FUNCTION(setLossModelScale);
            DEFINE_FUNCTION(setFullDuplex);
            DEFINE_FUNCTION(setInterference);
            DEFINE_FUNCTION(ignoreAntennaDirection);

            DEFINE_FUNCTION(isRadio);
            DEFINE_FUNCTION(hasRadio);
            DEFINE_FUNCTION(hasKindOfRadio);
            DEFINE_FUNCTION(isKindOf);

            DEFINE_FUNCTION(getBaseRadio);
            DEFINE_FUNCTION(isBaseRadio);
            DEFINE_FUNCTION(hasBaseRadio);
            DEFINE_FUNCTION(getRadioByType);

            DEFINE_FUNCTION(setItemRadioReplacement);
            DEFINE_FUNCTION(getDisplayName);

            DEFINE_FUNCTION(setGlobalVolume);
            DEFINE_FUNCTION(getGlobalVolume);
        };

        class Radios {
            DEFINE_FUNCTION(getCurrentRadio);
            DEFINE_FUNCTION(setCurrentRadio);
            DEFINE_FUNCTION(getCurrentRadioList);

            DEFINE_FUNCTION(setRadioChannel);
            DEFINE_FUNCTION(getRadioChannel);

            DEFINE_FUNCTION(setCurrentRadioChannelNumber);
            DEFINE_FUNCTION(getCurrentRadioChannelNumber);
        };
        class Presets {
            DEFINE_FUNCTION(setPreset);
            DEFINE_FUNCTION(getPreset);
            DEFINE_FUNCTION(copyPreset);

            DEFINE_FUNCTION(setPresetData);
            DEFINE_FUNCTION(getPresetData);

            DEFINE_FUNCTION(setPresetChannelData);
            DEFINE_FUNCTION(getPresetChannelData);

            DEFINE_FUNCTION(setPresetChannelField);
            DEFINE_FUNCTION(getPresetChannelField);
        };
        class Speaking {
            DEFINE_FUNCTION(isBroadcasting);
            DEFINE_FUNCTION(isSpeaking);

            DEFINE_FUNCTION(getRadioSpatial);
            DEFINE_FUNCTION(setRadioSpatial);

            DEFINE_FUNCTION(isSpectator);
            DEFINE_FUNCTION(setSpectator);
        };
        class DirectVoiceCurve {
            DEFINE_FUNCTION(getSelectableVoiceCurve);
            DEFINE_FUNCTION(setSelectableVoiceCurve);

            DEFINE_FUNCTION(setCurveModel);
            DEFINE_FUNCTION(setCurveModelScale);
        };
        class Babel {
            DEFINE_FUNCTION(babelSetupMission);
            DEFINE_FUNCTION(babelSetSpokenLanguages);
            DEFINE_FUNCTION(babelGetLanguageId);
            DEFINE_FUNCTION(babelGetLanguageName);
            DEFINE_FUNCTION(babelGetSpeakingLanguageId);
            DEFINE_FUNCTION(babelSetSpeakingLanguage);
            DEFINE_FUNCTION(babelAddLanguageType);
        };
    };


    // Module Functions
    class AcreModules {
        class GVAR(mission_setup) {
            class basicMissionSetup { file = PATHTOF(modules\basicMissionSetup.sqf); };
            class difficultySettings { file = PATHTOF(modules\difficultySettings.sqf); };
            class nameChannels { file = PATHTOF(modules\nameChannels.sqf); };
        };
    };
};
