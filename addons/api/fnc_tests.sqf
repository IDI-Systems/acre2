/*
 * Author: ACRE2Team
 * This function is used to test the API functions. Test results will be outputted to the global variable acre_api_testResults.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_api_fnc_tests;
 *
 * Public: No
 */
#include "script_component.hpp"

GVAR(testResults) = [];

#define ASSERT_BOOL(val1,val2)         (val1 == val2)
#define ASSERT_STRING(val1,val2)    (val1 == val2)
#define ASSERT_TYPE(val1,val2)        ((typeName val1) == val2)
#define PASS(fncName)                PUSH(GVAR(testResults), ARR_2(#fncName, true))
#define    FAIL(fncName)                PUSH(GVAR(testResults), ARR_2(#fncName, false))

/*
acre_api_fnc_getBaseRadio
parameters: radioId string
return: parent class string
*/
_test = ["ACRE_PRC343_ID_1"] call EFUNC(api,getBaseRadio);
if(ASSERT_STRING(_test,"ACRE_PRC343")) then {
    PASS(acre_api_fnc_getBaseRadio);
} else {
    FAIL(acre_api_fnc_getBaseRadio);
};

/*
acre_api_fnc_getBaseRadio
parameters: radioId string
return: parent class string
*/
_test = ["ACRE_PRC343"] call EFUNC(api,hasKindOfRadio);
if(ASSERT_BOOL(_test,true)) then {
    PASS(acre_api_fnc_hasKindOfradio);
} else {
    FAIL(acre_api_fnc_hasKindOfRadio);
};

/*
acre_api_fnc_getCurrentRadio
parameters: none
return: radioId string
*/
_test = [] call EFUNC(api,getCurrentRadio);
if(ASSERT_TYPE(_test,"STRING")) then {
    PASS(acre_api_fnc_getCurrentRadio);
} else {
    FAIL(acre_api_fnc_getCurrentRadio);
};

/*
acre_api_fnc_getCurrentRadioList
parameters: none
return: array of radioIds
*/
_test = [] call EFUNC(api,getCurrentRadioList);
if(ASSERT_TYPE(_test,"ARRAY")) then {
    PASS(acre_api_fnc_getCurrentRadioList);
} else {
    FAIL(acre_api_fnc_getCurrentRadioList);
};

/*
acre_api_fnc_getCurrentRadioList
parameters: none
return: array of radioIds
*/
_test = [] call EFUNC(api,getCurrentRadioList);
if(ASSERT_TYPE(_test,"ARRAY")) then {
    PASS(acre_api_fnc_getCurrentRadioList);
} else {
    FAIL(acre_api_fnc_getCurrentRadioList);
};

/*
acre_api_fnc_getDefaultChannels
parameters: none
return: array of radioIds
*/
_test = [] call EFUNC(api,getDefaultChannels);
if(ASSERT_TYPE(_test,"ARRAY")) then {
    PASS(acre_api_fnc_getDefaultChannels);
} else {
    FAIL(acre_api_fnc_getDefaultChannels);
};
