class ACE_ZeusActions {
    class ACRE_Interact {
        displayName = ECSTRING(ace_interact,radios);
        condition = QUOTE(_player call EFUNC(api,hasRadio));
        exceptions[] = {"isNotInside", "isNotSitting"};
        statement = "true";
        insertChildren = QUOTE(_this call EFUNC(ace_interact,radioListChildrenActions));
        priority = 0.1;
        icon = ICON_RADIO_CALL;
    };
    class ACRE_Zeus {
        displayName = "ACRE";
        condition = "true";
        statement = "true";
    };
};
