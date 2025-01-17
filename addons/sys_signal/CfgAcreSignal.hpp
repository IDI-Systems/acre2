class CfgAcreSignal {
    class LongleyRiceRadioClimate {
        /*
         * Definition of radio climates are the following:
         *  - Equatorial: Africa, along the equator
         * -  Continental Subtropical: Sudan region
         *  - Maritime tropical: a.k.a. Maritime Subtropical (West Coast of Africa
         *  - Desert: Death Valley, NV; Sahara
         *  - Continental Temperate: Usual general U.S. (default)
         *  - Maritime Temperate Overland: California to State of Washington; West Coast of Europe including U.K.
         *  - Maritime Temperate Oversea: Maritime Temperate, Over Sea
         */
        equatorial[] = {1, {}};
        continentalSubtropical[] = {2, {}};
        maritimeTropical[] = {3,
            {"tanoa"}
        };
        desert[] = {4, {
                "clafghan",
                "esbekistan",
                "lythium",
                "takistan",
                "map_north_takistan"
            }
        };
        continentalTemperate[] = {5, {}}; // All undefined maps fall into this category
        maritimeTemperateOverland[] = {6, {
                "altis",
                "abel",
                "chernarus",
                "malden",
                "stratis"
            }
        };
        maritimeTemperateOversea[] = {7, {}};
    };
};
