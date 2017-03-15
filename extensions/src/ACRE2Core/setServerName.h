#pragma once

#include "IRpcFunction.h"
#include "Log.h"
#include "TextMessage.h"
#include "Engine.h"

RPC_FUNCTION(setServerName) {
	std::string name;
	name = std::string((char *) vMessage->getParameter(0));

	CEngine::getInstance()->getClient()->updateServerName(name);
	return ACRE_OK;
}
DECLARE_MEMBER(char *, Name);
};
