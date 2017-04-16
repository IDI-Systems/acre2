/*#include "KeyHandlerEngine.h"
#include "Engine.h"
#include "TextMessage.h"

CKeyHandlerEngine::CKeyHandlerEngine() {
    this->setShuttingDown(false);
}

CKeyHandlerEngine::~CKeyHandlerEngine() {
    this->shutdown();
}

ACRE_RESULT CKeyHandlerEngine::initialize() {
    LOG("Starting Keyboard Handler...");
    this->m_keyboardReadThread = std::thread(&CKeyHandlerEngine::readKeyLoop, this);
    return ACRE_OK;
}

ACRE_RESULT CKeyHandlerEngine::readKeyLoop() {
    while (!this->getShuttingDown()) {
        if (CEngine::getInstance()->getGameServer() && CEngine::getInstance()->getGameServer()->getConnected()) { 
            for (auto it = this->m_keyMap.begin(); it != this->m_keyMap.end(); ++it) {
                ACRE_KEY_ENTRY *keyEntry = it->second;
                short currentKeyState = ACRE_KEY_UP;
                if (GetAsyncKeyState(keyEntry->keyCode) & 0x8000) {
                    bool shiftState = (GetAsyncKeyState(VK_SHIFT) & 0x8000);
                    bool ctrlState = (GetAsyncKeyState(VK_CONTROL) & 0x8000);
                    bool altState = (GetAsyncKeyState(VK_MENU) & 0x8000);

                    // This should check if modifiers are set/not set and also make sure if someone is using a modifier its ok.
                    if ((keyEntry->shift && !shiftState) || (!keyEntry->shift && shiftState && keyEntry->keyCode != VK_SHIFT)) {
                        continue;
                    }
                    if ((keyEntry->ctrl && !ctrlState) || (!keyEntry->ctrl && ctrlState && keyEntry->keyCode != VK_CONTROL)) {
                        continue;
                    }
                    if ((keyEntry->alt && !altState) || (!keyEntry->alt && altState && keyEntry->keyCode != VK_MENU)) {
                        continue;
                    }

                    // If everything above is good, we have a valid key stroke.
                    currentKeyState = ACRE_KEY_DOWN;
                }
                if (keyEntry->keyState != currentKeyState) {
                    if (currentKeyState == ACRE_KEY_DOWN) {
                        keyEntry->keyState = ACRE_KEY_DOWN;
                        TRACE("Key Down: %s", keyEntry->eventName.c_str());
                    } else {
                        keyEntry->keyState = ACRE_KEY_UP;
                        TRACE("Key Up: %s", keyEntry->eventName.c_str());
                    }
                    CEngine::getInstance()->getGameServer()->sendMessage( CTextMessage::formatNewMessage("keyBoardEvent", 
                            "%s,%d,",
                            keyEntry->eventName.c_str(),
                            currentKeyState
                            ) 
                        );
                }
            }
            Sleep(50);
        } else {
            Sleep(1000);
        }
    }
    return ACRE_OK;
}

ACRE_RESULT CKeyHandlerEngine::shutdown() {
    this->setShuttingDown(true);
    if (this->m_keyboardReadThread.joinable()) {
        this->m_keyboardReadThread.join();
    }
    this->setShuttingDown(false);
    return ACRE_OK;
}

ACRE_RESULT CKeyHandlerEngine::setKeyBind(string eventName, int keyCode, bool shift, bool ctrl, bool alt) {
    auto it = this->m_keyMap.find(eventName);
    if (it == this->m_keyMap.end()) {
        ACRE_KEY_ENTRY *newEntry = new ACRE_KEY_ENTRY();
        newEntry->eventName = eventName;
        newEntry->keyCode = keyCode;
        newEntry->shift = shift;
        newEntry->ctrl = ctrl;
        newEntry->alt = alt;

        newEntry->keyState = ACRE_KEY_UP;

        this->m_keyMap.insert(std::pair<string, ACRE_KEY_ENTRY *>(eventName, newEntry));
    } else {
        ACRE_KEY_ENTRY *existingEntry = it->second;
        // see if anything has changed in the keybind, if so update the existing entry
        if (
            keyCode != existingEntry->keyCode ||
            shift != existingEntry->shift ||
            alt != existingEntry->alt ||
            ctrl != existingEntry->ctrl
            ) {
                existingEntry->keyCode = keyCode;
                existingEntry->shift = shift;
                existingEntry->ctrl = ctrl;
                existingEntry->alt = alt;
        }
    }
    return ACRE_OK;
}

ACRE_RESULT CKeyHandlerEngine::removeKeyBind(string eventName) {
    this->lock();
    auto it = this->m_keyMap.find(eventName);
    if (it != this->m_keyMap.end()) {
        this->m_keyMap.unsafe_erase(it);
    }
    this->unlock();

    return ACRE_OK;
}

ACRE_RESULT CKeyHandlerEngine::clearKeybinds( void ) {
    this->lock();
    this->m_keyMap.clear();
    this->unlock();
    return ACRE_OK;
}
*/