/*
    Copyright © 2010,International Development & Integration Systems, LLC
    All rights reserved.
    http://www.idi-systems.com/

    For personal use only. Military or commercial use is STRICTLY
    prohibited. Redistribution or modification of source code is 
    STRICTLY prohibited.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
    FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
    COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES INCLUDING,
    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
    ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
    POSSIBILITY OF SUCH DAMAGE.
*/
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

#define ERRORDATA(c)    private ["_callFrom", "_lineNo"];\
                        _callFrom = "";\
                        _lineNo = -1;\
                        if((count _this) > c) then {\
                            _callFrom = _this select c;\
                            _lineNo = _this select c+1;\
                        };