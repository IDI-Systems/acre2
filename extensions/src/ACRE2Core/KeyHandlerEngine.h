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
    BOOL shift;
    BOOL ctrl;
    BOOL alt;

    short keyState;
} *PACRE_KEY_ENTRY;

enum { ACRE_KEY_UP, ACRE_KEY_DOWN };

class CKeyHandlerEngine : public CLockable {
public:
    CKeyHandlerEngine();
    ~CKeyHandlerEngine();

    acre::Result readKeyLoop();

    acre::Result initialize( void );
    acre::Result shutdown( void );
    acre::Result release( void ) { return acre::Result::ok; };

    acre::Result setKeyBind(string eventName, int keyCode, BOOL shift, BOOL ctrl, BOOL alt);
    acre::Result removeKeyBind(string eventName);

    acre::Result clearKeybinds( void );

    DECLARE_MEMBER(BOOL, ShuttingDown);

protected:
    concurrency::concurrent_unordered_map<string, ACRE_KEY_ENTRY *> m_keyMap;
    std::thread m_keyboardReadThread;
};
*/