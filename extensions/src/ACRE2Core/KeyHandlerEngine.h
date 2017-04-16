#pragma once
/*
#include "compat.h"
#include "Macros.h"
#include "Lockable.h"
#include "Types.h"
#include "IMessage.h"
#include "IServer.h"
#include <string>
#include <thread>
#include <concurrent_unordered_map.h>

using namespace std;

typedef struct ACRE_KEY_ENTRY {
    string eventName;
    int keyCode;
    bool shift;
    bool ctrl;
    bool alt;

    short keyState;
} *PACRE_KEY_ENTRY;

enum { ACRE_KEY_UP, ACRE_KEY_DOWN };

class CKeyHandlerEngine : public CLockable {
public:
    CKeyHandlerEngine();
    ~CKeyHandlerEngine();

    ACRE_RESULT readKeyLoop();

    ACRE_RESULT initialize( void );
    ACRE_RESULT shutdown( void );
    ACRE_RESULT release( void ) { return ACRE_OK; };

    ACRE_RESULT setKeyBind(string eventName, int keyCode, bool shift, bool ctrl, bool alt);
    ACRE_RESULT removeKeyBind(string eventName);

    ACRE_RESULT clearKeybinds( void );

    DECLARE_MEMBER(bool, ShuttingDown);

protected:
    concurrency::concurrent_unordered_map<string, ACRE_KEY_ENTRY *> m_keyMap;
    std::thread m_keyboardReadThread;
};
*/