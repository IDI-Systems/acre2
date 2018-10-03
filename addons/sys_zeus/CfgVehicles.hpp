class CfgVehicles {
    class Man;
    class CAManBase: Man {
        class ACE_SelfActions {
            class ACRE_RemoteEars {
                displayName = CSTRING(remote);
                condition = QUOTE(!(acre_current_player isEqualTo player) && {acre_player isEqualTo player});
                statement = QUOTE([false] call FUNC(setUsePlayer));
            };
            class ACRE_PlayerEars {
                displayName = CSTRING(player);
                condition = QUOTE(!(acre_current_player isEqualTo player) && {!(acre_player isEqualTo player)});
                statement = QUOTE([true] call FUNC(setUsePlayer));
            };
        };
    };
};
