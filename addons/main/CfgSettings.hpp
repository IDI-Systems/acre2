class CfgSettings {
    class CBA {
        class Versioning {
            class PREFIX {
                class dependencies {
                    CBA[] = {"cba_main", REQUIRED_CBA_VERSION, "(true)"};

                    compat_sogpf[] = {"acre_sys_sog", {VERSION_AR}, "isClass (configFile >> 'CfgPatches' >> 'data_f_vietnam')"};
                };
            };
        };
    };
};
