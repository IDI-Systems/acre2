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

    acre_result_t readKeyLoop();

    acre_result_t initialize( void );
    acre_result_t shutdown( void );
    acre_result_t release( void ) { return acre_result_ok; };

    acre_result_t setKeyBind(string eventName, int keyCode, BOOL shift, BOOL ctrl, BOOL alt);
    acre_result_t removeKeyBind(string eventName);

    acre_result_t clearKeybinds( void );

    DECLARE_MEMBER(BOOL, ShuttingDown);

protected:
    concurrency::concurrent_unordered_map<string, ACRE_KEY_ENTRY *> m_keyMap;
    std::thread m_keyboardReadThread;
};
*/