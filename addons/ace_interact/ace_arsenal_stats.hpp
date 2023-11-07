 class ace_arsenal_stats {
    class statBase;
    class GVAR(frequencyRange): statBase {
        scope = 2;
        stats[] = {QEGVAR(arsenalStats,frequencyMin), QEGVAR(arsenalStats,frequencyMax)};
        displayName= CSTRING(arsenalStats_frequencyRange);
        showText = 1;
        textStatement = QUOTE(call FUNC(arsenalStats_frequencyRange));
        condition = QUOTE((getNumber(_this select 1 >> 'acre_isRadio')) == 1);
        tabs[] = {{}, {7}}; // Misc-Items on right tab
    };
    class GVAR(transmitPower): statBase {
        scope = 2;
        stats[] = {QEGVAR(arsenalStats,transmitPower)};
        displayName= CSTRING(arsenalStats_transmitPower);
        showText = 1;
        textStatement = QUOTE(call FUNC(arsenalStats_transmitPower));
        condition = QUOTE((getNumber(_this select 1 >> 'acre_isRadio')) == 1);
        tabs[] = {{}, {7}};
    };
    class GVAR(effectiveRange): statBase {
        scope = 2;
        stats[] = {QEGVAR(arsenalStats,effectiveRange)};
        displayName= CSTRING(arsenalStats_effectiveRange);
        showText = 1;
        textStatement = QUOTE(getText ((_this select 1) >> (_this select 0 select 0)));
        condition = QUOTE((getNumber(_this select 1 >> 'acre_isRadio')) == 1);
        tabs[] = {{}, {7}};
    };
    class GVAR(externalSpeaker): statBase {
        scope = 2;
        stats[] = {QEGVAR(arsenalStats,externalSpeaker)};
        displayName= CSTRING(arsenalStats_externalSpeaker);
        showText = 1;
        textStatement = QUOTE(call FUNC(arsenalStats_externalSpeaker));
        condition = QUOTE((getNumber(_this select 1 >> 'acre_isRadio')) == 1);
        tabs[] = {{}, {7}};
    };
 };
