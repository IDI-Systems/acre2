class CfgVehicles {
    class Man;
    class CAManBase: Man {
        class ACE_SelfActions {
            class GVAR(remoteEars) {
                displayName = CSTRING(Remote);
                condition = QUOTE(acre_current_player isNotEqualTo player && {acre_player isEqualTo player});
                statement = QUOTE([false] call FUNC(setUsePlayer));
            };
            class GVAR(playerEars) {
                displayName = CSTRING(Player);
                condition = QUOTE(acre_current_player isNotEqualTo player && {acre_player isNotEqualTo player});
                statement = QUOTE([true] call FUNC(setUsePlayer));
            };
        };
    };
};
