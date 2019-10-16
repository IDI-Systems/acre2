; API versions compatibility, selecting correct API function for used API version
; onPluginCommandEvent wrapper donated by dedmen on 2019-06-13

IFDEF RAX

option casemap :none

_TEXT    SEGMENT

    EXTERN ts3plugin_onPluginCommandEvent:          PROC;
    EXTERN ts3plugin_onPluginCommandEvent_v23:      PROC;
    EXTERN onPluginCommandEvent_v23:                BYTE;

    PUBLIC ts3plugin_onPluginCommandEventProc
    ts3plugin_onPluginCommandEventProc PROC EXPORT

        CMP onPluginCommandEvent_v23, 00
        jne _func_v23;
        jmp ts3plugin_onPluginCommandEvent;
_func_v23:
    jmp ts3plugin_onPluginCommandEvent_v23;

    ts3plugin_onPluginCommandEventProc ENDP

ELSE
.686
option casemap :none

_TEXT    SEGMENT

    EXTERN _ts3plugin_onPluginCommandEvent:         PROC;
    EXTERN _ts3plugin_onPluginCommandEvent_v23:     PROC;
    EXTERN _onPluginCommandEvent_v23:               BYTE;

    PUBLIC ts3plugin_onPluginCommandEventProc
    ts3plugin_onPluginCommandEventProc PROC FAR EXPORT

        CMP _onPluginCommandEvent_v23, 00
        jne _func_v23;
        jmp _ts3plugin_onPluginCommandEvent;
_func_v23:
    jmp _ts3plugin_onPluginCommandEvent_v23;

    ts3plugin_onPluginCommandEventProc ENDP

ENDIF


_TEXT    ENDS
END
