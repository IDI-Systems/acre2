/*
These are the values percentage wise (0-1) you want to cut
when someone is listening to these positions from
inside. These apply back and forth for the person
listening as well as the person who is speaking to the
player.

For example below if you are inside a tank and you are
a gunner then you would be able to hear the commander,
cargo, and any "other" positions. For this example we
pretend that the driver is like a lot of tanks in a
seperate physical location of the vehicle. He is unable
on direct speaking to hear anyone else or talk to anyone
else.

As for people outside the tank, the attenuateOutside value
is what you cut when the speaker is inside and the same goes
for vica versa. If someone is outside this is how much is
cut when they are speaking to you.
*/

class CfgAcreAttenuation {
    class DefaultAttenuation {
        positions[] = { other };

        // default rack attenuation
        class MainRack {
            hasCrewIntercom = 0;

            class inside {
                class other     { attenuationValue = 0.5; };
                class gunner     { attenuationValue = 0.5; };
                class driver     { attenuationValue = 0.5; };
                class commander { attenuationValue = 0.5; };
                class cargo     { attenuationValue = 0.5; };
                attenuateOutside    = 0.7;
            };
            class turnedout {
                class other     { attenuationValue = 0.5; };
                class gunner     { attenuationValue = 0.5; };
                class driver     { attenuationValue = 0.5; };
                class commander { attenuationValue = 0.5; };
                class cargo     { attenuationValue = 0.5; };
                attenuateOutside    = 0.7;
            };
        };

        class gunner {
            hasCrewIntercom = 0;

            class inside {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 0;
            };
            class turnedout {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 0;
            };
        };

        class commander {
            hasCrewIntercom = 0;

            class inside {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 0;
            };
            class turnedout {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 0;
            };
        };

        class driver {
            hasCrewIntercom = 0;

            class inside {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 0;
            };
            class turnedout {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 0;
            };
        };

        class cargo {
            hasCrewIntercom = 0;

            class inside {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 0;
            };
            class turnedout {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 0;
            };
        };

        class other {
            hasCrewIntercom = 0;

            class inside {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 0;
            };
            class turnedout {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 0;
            };
        };
    };

    class Car : DefaultAttenuation {
        positions[] = { other };

        class other {
            class inside {
                class other {
                    attenuationValue = 0;
                };
                attenuateOutside    = 0.4;
            };
            class turnedout {
                attenuateOutside    = 0;
            };
        };
    };

    class Tank : DefaultAttenuation {
        positions[] = {gunner,driver,commander,cargo,other };

        class gunner {
            hasCrewIntercom = 1;

            class inside {
                class other     { attenuationValue = 0.3; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0.3; };
                attenuateOutside    = 1;
            };
            class turnedout {
                class other     { attenuationValue = 1; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 1; };
                attenuateOutside    = 0.5;
            };
        };

        class commander {
            hasCrewIntercom = 1;

            class inside {
                class other     { attenuationValue = 0.3; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0.3; };
                attenuateOutside    = 1;
            };
            class turnedout {
                class other     { attenuationValue = 1; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 1; };
                attenuateOutside    = 0.5;
            };
        };

        class driver {
            hasCrewIntercom = 1;

            class inside {
                class other     { attenuationValue = 0.3; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0.3; };
                attenuateOutside    = 1;
            };
            class turnedout {
                class other     { attenuationValue = 1; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 1; };
                attenuateOutside    = 0.5;
            };
        };

        class cargo {
            hasCrewIntercom = 0;

            class inside {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0.3; };
                class driver     { attenuationValue = 0.3; };
                class commander { attenuationValue = 0.3; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 1;
            };
            class turnedout {
                class other     { attenuationValue = 1; };
                class gunner     { attenuationValue = 1; };
                class driver     { attenuationValue = 1; };
                class commander { attenuationValue = 1; };
                class cargo     { attenuationValue = 1; };
                attenuateOutside    = 0;
            };
        };

        class other {
            hasCrewIntercom = 0;

            class inside {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0.3; };
                class driver     { attenuationValue = 0.3; };
                class commander { attenuationValue = 0.3; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 1;
            };
            class turnedout {
                class other     { attenuationValue = 1; };
                class gunner     { attenuationValue = 1; };
                class driver     { attenuationValue = 1; };
                class commander { attenuationValue = 1; };
                class cargo     { attenuationValue = 1; };
                attenuateOutside    = 0;
            };
        };
    };

    class Helicopter : DefaultAttenuation {
        positions[] = {gunner,driver,commander,cargo,other };

        class gunner {
            hasCrewIntercom = 1;

            class inside {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 0.5;
            };
            class turnedout {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 0.5;
            };
        };

        class commander {
            hasCrewIntercom = 1;

            class inside {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 0.5;
            };
            class turnedout {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 0.5;
            };
        };

        class driver {
            hasCrewIntercom = 1;

            class inside {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 0.5;
            };
            class turnedout {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 0.5;
            };
        };

        class cargo {
            hasCrewIntercom = 0;

            class inside {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 0.5;
            };
            class turnedout {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 0.5;
            };
        };

        class other {
            hasCrewIntercom = 0;

            class inside {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 0.5;
            };
            class turnedout {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 0.5;
            };
        };
    };

    class Plane : DefaultAttenuation {
        positions[] = {gunner,driver,commander,cargo,other };

        class gunner {
            hasCrewIntercom = 1;

            class inside {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 1;
            };
            class turnedout {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 1;
            };
        };

        class commander {
            hasCrewIntercom = 1;

            class inside {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 1;
            };
            class turnedout {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 1;
            };
        };

        class driver {
            hasCrewIntercom = 1;

            class inside {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 1;
            };
            class turnedout {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 1;
            };
        };

        class cargo {
            hasCrewIntercom = 0;

            class inside {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 1;
            };
            class turnedout {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 1;
            };
        };

        class other {
            hasCrewIntercom = 0;

            class inside {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 1;
            };
            class turnedout {
                class other     { attenuationValue = 0; };
                class gunner     { attenuationValue = 0; };
                class driver     { attenuationValue = 0; };
                class commander { attenuationValue = 0; };
                class cargo     { attenuationValue = 0; };
                attenuateOutside    = 1;
            };
        };
    };

    #include "CfgAcreAttenuation_Vehicles.hpp"
};
