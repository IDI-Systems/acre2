#include "script_component.hpp"

if (hasInterface) then {
    #include "XEH_PREPServer.hpp"
} else {
    if (isServer) then {
        #include "XEH_PREPClient.hpp"
    };
};
