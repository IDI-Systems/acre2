class CfgFunctions {
    class ADDON {
        class General {
            PATHTO_FNC(isInitialized);

            PATHTO_FNC(setupMission);

            PATHTO_FNC(addDisplayPassthroughKeys);
            PATHTO_FNC(addNotificationDisplay);

            PATHTO_FNC(getMultiPushToTalkAssignment);
            PATHTO_FNC(setMultiPushToTalkAssignment);

            PATHTO_FNC(setPTTDelay);
            PATHTO_FNC(getPTTDelay);

            PATHTO_FNC(getRevealToAI);

            PATHTO_FNC(setCustomSignalFunc);

            PATHTO_FNC(isRadio);
            PATHTO_FNC(hasRadio);
            PATHTO_FNC(hasKindOfRadio);
            PATHTO_FNC(isKindOf);

            PATHTO_FNC(getBaseRadio);
            PATHTO_FNC(isBaseRadio);
            PATHTO_FNC(hasBaseRadio);
            PATHTO_FNC(getRadioByType);

            PATHTO_FNC(filterUnitLoadout);

            PATHTO_FNC(setItemRadioReplacement);
            PATHTO_FNC(getDisplayName);

            PATHTO_FNC(setGlobalVolume);
            PATHTO_FNC(getGlobalVolume);
        };

        class Radios {
            PATHTO_FNC(getAllRadios);
            PATHTO_FNC(getAllRadiosByType);
            PATHTO_FNC(getCurrentRadio);
            PATHTO_FNC(setCurrentRadio);
            PATHTO_FNC(getCurrentRadioList);

            PATHTO_FNC(setRadioChannel);
            PATHTO_FNC(getRadioChannel);

            PATHTO_FNC(setRadioVolume);
            PATHTO_FNC(getRadioVolume);

            PATHTO_FNC(setCurrentRadioChannelNumber);
            PATHTO_FNC(getCurrentRadioChannelNumber);

            PATHTO_FNC(setRadioAudioSource);
            PATHTO_FNC(getRadioAudioSource);
            PATHTO_FNC(setRadioSpeaker);
            PATHTO_FNC(isRadioSpeaker);
        };

        class Racks {
            PATHTO_FNC(addRackToVehicle);
            PATHTO_FNC(areVehicleRacksInitialized);
            PATHTO_FNC(getMountedRackRadio);
            PATHTO_FNC(getVehicleRacks);
            PATHTO_FNC(initVehicleRacks);
            PATHTO_FNC(isRackRadioRemovable);
            PATHTO_FNC(mountRackRadio);
            PATHTO_FNC(removeRackFromVehicle);
            PATHTO_FNC(unmountRackRadio);
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

            PATHTO_FNC(setVehicleRacksPreset);
            PATHTO_FNC(getVehicleRacksPreset);
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

        class Spectator {
            PATHTO_FNC(addSpectatorRadio);
            PATHTO_FNC(removeAllSpectatorRadios);
            PATHTO_FNC(removeSpectatorRadio);
        };

        class GodMode {
            PATHTO_FNC(godModeConfigureAccess);
            PATHTO_FNC(godModeModifyGroup);
            PATHTO_FNC(godModeNameGroup);
            PATHTO_FNC(godModeSendText);
            PATHTO_FNC(godModeGetGroupTargets);
        };

        class VOIP {
            PATHTO_FNC(getVOIPChannelName);
            PATHTO_FNC(getVOIPChannelUID);
            PATHTO_FNC(getVOIPServerName);
            PATHTO_FNC(getVOIPServerUID);
            PATHTO_FNC(isVOIPConnected);
        };
    };


    // Module Functions
    class AcreModules {
        class GVAR(mission_setup) {
            PATHTO_FNC(basicMissionSetup);
            PATHTO_FNC(nameChannels);
        };
    };
};
