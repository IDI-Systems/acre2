#pragma once

#include "compat.h"
#include "IRpcFunction.h"
#include "Types.h"
#include "Engine.h"

RPC_FUNCTION(ext_reset) {
	ACRE_ID id;

	id = vMessage->getParameterAsInt(0);

	//
	// These checks were fucking up Because ext_reset is called on a named pipe disconnect, but this checked for a valid connection, and game, and that it was our valid ID.
	// This should just be calling unmute on EVERYONE - because it was a pipe disconnect. Pipe disconnect at the end of game, or when having issues. 
	// We don't care if a person disconnects and they unmute all their shit, this doesn't break the "mute other people not in game" issue, because they mute this person.
	//
	//if(id == CEngine::getInstance()->getSelf()->getId())
	//	return ACRE_OK;
	//if(!CEngine::getInstance()->getGameServer()->getConnected())
	//	return ACRE_OK;
	//CEngine::getInstance()->getClient()->setMuted(id, FALSE);

	// We should be calling this, but the named pipe function already calls this too
	// We leave this here so SQF can force a full unmute, though.
	CEngine::getInstance()->getClient()->unMuteAll();

	return ACRE_OK;
}
DECLARE_MEMBER(char *, Name);
};