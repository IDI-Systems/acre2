class Cfg3DEN {
    class Object {
        class AttributeCategories {
            class acre_attributes {
                class Attributes {
                    class GVAR(edenSetup) {
                        property = QGVAR(edenSetup);
                        condition = "objectBrain";
                        control = "Edit";
                        typeName = "STRING";
                        displayName = CSTRING(3den_RadioSetup_DisplayName);
                        tooltip = CSTRING(3den_RadioSetup_Description);
                        defaultValue = "[[""ACRE_PRC343"",[1,1]],[""ACRE_PRC152"",1],[""ACRE_PRC117F"",1]]";
                        expression = QUOTE(_this setVariable [ARR_3(QQGVAR(setup),_value,true)]);
                    };
                };
            };
        };
    };
};
