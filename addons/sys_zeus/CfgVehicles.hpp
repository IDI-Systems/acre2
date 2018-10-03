class CfgVehicles {
    class ACE_ZeusActions {
        class ACRE_ZeusEars {
            displayName = "ACRE";
            condition = QUOTE(true);
            statment = "";
            class ACRE_SpectatorEars {
                displayName = CSTRINGS(spectatorEars);
                condition = QUOTE(!ACRE_IS_SPECTATOR);
                statement = QUOTE([true] call EFUNC(api,setSpectator));
            };
            class ACRE_ZeusEars {
                displayName = CSTRINGS(zeusEars);
                condition = QUOTE(ACRE_IS_SPECTATOR);
                statement = QUOTE([false] call EFUNC(api,setSpectator));
            };
        };
    };

    class Man;
    class CAManBase: Man {
        class ACE_SelfActions {
            class ACRE_RemoteEars {
                displayName = CSTRING(remote);
                condition = QUOTE(!(acre_current_player isEqualTo player) && {!(acre_player isEqualTo player)});
                statement = QUOTE([true] call FUNC(setUsePlayer));
            };
            class ACRE_PlayerEars {
                displayName = CSTRING(player);
                condition = QUOTE(!(acre_current_player isEqualTo player) && {acre_current_player isEqualTo player});
                statement = QUOTE([false] call FUNC(setUsePlayer));
            };
        };
    };
};
