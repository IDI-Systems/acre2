#define COMPONENT lib
#include "script_mod.hpp"

#ifdef DEBUG_ENABLED_LIB
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_LIB
    #define DEBUG_SETTINGS DEBUG_SETTINGS_LIB
#endif


#include "script_common_macros.hpp"
#define IS_ARRAY(array)    array isEqualType []
#define VALIDHASH(hash)    (IS_ARRAY(hash) && {(count hash) >= 2} && {IS_ARRAY(hash select 0)} && {IS_ARRAY(hash select 1)})
#define ERROR(msg)    throw msg + format[" @ %1:%2", _callFrom, _lineNo]
#define HANDLECATCH    diag_log text _exception; assert(exception=="")

#define ERRORDATA(c)    private _callFrom = "";\
                        private _lineNo = -1;\
                        if((count _this) > c) then {\
                            _callFrom = _this select c;\
                            _lineNo = _this select c+1;\
                        };
