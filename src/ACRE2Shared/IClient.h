#pragma once

#include "compat.h"

#include "Types.h"
#include "Macros.h"
#include "ACRE_VECTOR.h"
#include <list>
#include <string>

class IClient {
public:

	virtual ACRE_RESULT initialize( void ) = 0;

	virtual ACRE_RESULT setMuted(ACRE_ID id, BOOL muted) = 0;
	virtual ACRE_RESULT setMuted(std::list<ACRE_ID> idList, BOOL muted) = 0;

	virtual ACRE_RESULT getMuted(ACRE_ID id) = 0;

	virtual ACRE_RESULT stop() = 0;
	virtual ACRE_RESULT start(ACRE_ID id) = 0;

	virtual ACRE_RESULT enableMicrophone(BOOL status) = 0;

	virtual ACRE_RESULT microphoneOpen(BOOL status) = 0;

	virtual ACRE_RESULT localStartSpeaking(ACRE_SPEAKING_TYPE speakingType) = 0;
	virtual ACRE_RESULT localStartSpeaking(ACRE_SPEAKING_TYPE speakingType, std::string radioId) = 0;
	virtual ACRE_RESULT localStopSpeaking(ACRE_SPEAKING_TYPE speakingType) = 0;

	virtual std::string getTempFilePath( void ) = 0;
	virtual std::string getConfigFilePath(void) = 0;

	virtual std::string getUniqueId() = 0;

	virtual ACRE_RESULT playSound(std::string path, ACRE_VECTOR position, float volume, int looping) = 0;

	virtual ACRE_RESULT unMuteAll( void ) = 0;

	DECLARE_INTERFACE_MEMBER(ACRE_STATE, State);

};