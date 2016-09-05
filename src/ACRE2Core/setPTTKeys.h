#pragma once
#include "IRpcFunction.h"
#include "Engine.h"
#include "TextMessage.h"
#include "Log.h"

RPC_FUNCTION(setPTTKeys) {
	/*
	CEngine::getInstance()->getKeyHandlerEngine()->setKeyBind(
		std::string((char *)vMessage->getParameter(0)),
		vMessage->getParameterAsInt(1),
		vMessage->getParameterAsInt(2) ? 1 : 0,
		vMessage->getParameterAsInt(3) ? 1 : 0,
		vMessage->getParameterAsInt(4) ? 1 : 0
		);

		*/

	return ACRE_OK;
}
DECLARE_MEMBER(char *, Name);
};