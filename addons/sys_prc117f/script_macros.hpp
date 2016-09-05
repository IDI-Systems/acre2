#define GET_STATE(id)            ([GVAR(currentRadioId), "getState", id] call acre_sys_data_fnc_dataEvent)
#define SET_STATE(id, val)        ([GVAR(currentRadioId), "setState", [id, val]] call acre_sys_data_fnc_dataEvent)
#define SET_STATE_CRIT(id, val)    ([GVAR(currentRadioId), "setStateCritical", [id, val]] call acre_sys_data_fnc_dataEvent)

#define GET_STATE_DEF(id, default)    ([id, default] call FUNC(getDefaultState))


