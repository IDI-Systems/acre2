#pragma once
#include "IRpcFunction.h"
#include "IServer.h"
#include "TextMessage.h"
#include "Engine.h"
#include <iostream>
#include <fstream>
#include <string>

RPC_FUNCTION(getTeamSpeakChannelName) {
    std::ofstream MyFile("D:\\logs\\log.txt");
    std::string id = CEngine::getInstance()->getClient()->getChannelName();
    MyFile << "Begining "<< id << std::endl; 
    vServer->sendMessage(CTextMessage::formatNewMessage("getTeamSpeakChannelName", "%s", id.c_str()));
    MyFile.close();
    return acre::Result::ok;
}
public:
    inline void setName(const char *const value) final { m_Name = value; }
    inline const char* getName() const final { return m_Name; }

protected:
    const char* m_Name;
};