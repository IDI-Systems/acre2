class CfgFunctions {
    class ADDON {
        class General {
            PATHTO_FNC(isInitialized);

            PATHTO_FNC(setupMission);

            PATHTO_FNC(getMultiPushToTalkAssignment);
            PATHTO_FNC(setMultiPushToTalkAssignment);

            PATHTO_FNC(setPTTDelay);
            PATHTO_FNC(getPTTDelay);

            PATHTO_FNC(setRevealToAI);
            PATHTO_FNC(getRevealToAI);

            PATHTO_FNC(setLossModelScale);
            PATHTO_FNC(setFullDuplex);
            PATHTO_FNC(setInterference);
            PATHTO_FNC(ignoreAntennaDirection);

            PATHTO_FNC(setCustomSignalFunc);

            PATHTO_FNC(isRadio);
            PATHTO_FNC(hasRadio);
            PATHTO_FNC(hasKindOfRadio);
            PATHTO_FNC(isKindOf);

            PATHTO_FNC(getBaseRadio);
            PATHTO_FNC(isBaseRadio);
            PATHTO_FNC(hasBaseRadio);
            PATHTO_FNC(getRadioByType);

            PATHTO_FNC(setItemRadioReplacement);
            PATHTO_FNC(getDisplayName);

            PATHTO_FNC(setGlobalVolume);
            PATHTO_FNC(getGlobalVolume);
        };

        class Radios {
            PATHTO_FNC(getAllRadios);
            PATHTO_FNC(getCurrentRadio);
            PATHTO_FNC(setCurrentRadio);
            PATHTO_FNC(getCurrentRadioList);

            PATHTO_FNC(setRadioChannel);
            PATHTO_FNC(getRadioChannel);

            PATHTO_FNC(setCurrentRadioChannelNumber);
            PATHTO_FNC(getCurrentRadioChannelNumber);
        };
        class Presets {
            PATHTO_FNC(setPreset);
            PATHTO_FNC(getPreset);
            PATHTO_FNC(copyPreset);

            PATHTO_FNC(setPresetData);
            PATHTO_FNC(getPresetData);

            PATHTO_FNC(setPresetChannelData);
            PATHTO_FNC(getPresetChannelData);

            PATHTO_FNC(setPresetChannelField);
            PATHTO_FNC(getPresetChannelField);
        };
        class Speaking {
            PATHTO_FNC(isBroadcasting);
            PATHTO_FNC(isSpeaking);

            PATHTO_FNC(getRadioSpatial);
            PATHTO_FNC(setRadioSpatial);

            PATHTO_FNC(isSpectator);
            PATHTO_FNC(setSpectator);
        };
        class DirectVoiceCurve {
            PATHTO_FNC(getSelectableVoiceCurve);
            PATHTO_FNC(setSelectableVoiceCurve);

            PATHTO_FNC(setCurveModel);
            PATHTO_FNC(setCurveModelScale);
        };
        class Babel {
            PATHTO_FNC(babelSetupMission);
            PATHTO_FNC(babelSetSpokenLanguages);
            PATHTO_FNC(babelGetLanguageId);
            PATHTO_FNC(babelGetLanguageName);
            PATHTO_FNC(babelGetSpeakingLanguageId);
            PATHTO_FNC(babelSetSpeakingLanguage);
            PATHTO_FNC(babelAddLanguageType);
        };
    };


    // Module Functions
    class AcreModules {
        class GVAR(mission_setup) {
            PATHTO_FNC(basicMissionSetup);
            PATHTO_FNC(difficultySettings);
            PATHTO_FNC(nameChannels);
        };
    };
};
