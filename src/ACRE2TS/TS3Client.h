#pragma once

#include "IClient.h"
#include "TsFunctions.h"
#include <thread>
#include <string>

class CTS3Client: public IClient {
public:
	
	//static TS3Functions ts3Functions;

	CTS3Client() { };
	~CTS3Client() { };

	ACRE_RESULT initialize( void );

	ACRE_RESULT setMuted(ACRE_ID id, BOOL muted);
	ACRE_RESULT setMuted(std::list<ACRE_ID> idList, BOOL muted);

	ACRE_RESULT getMuted(ACRE_ID id);

	ACRE_RESULT stop();
	ACRE_RESULT start(ACRE_ID id);

	ACRE_RESULT exPersistVersion( void );

	ACRE_RESULT enableMicrophone(BOOL status);

	BOOL getInputStatus();

	ACRE_RESULT localStartSpeaking(ACRE_SPEAKING_TYPE speakingType);
	ACRE_RESULT localStartSpeaking(ACRE_SPEAKING_TYPE speakingType, std::string radioId);
	ACRE_RESULT localStopSpeaking( ACRE_SPEAKING_TYPE speakingType );

	std::string getTempFilePath( void );
	std::string getConfigFilePath(void);
	
	ACRE_RESULT playSound(std::string path, ACRE_VECTOR position, float volume, int looping);

	std::string getUniqueId( );

	BOOL getVAD();

	ACRE_RESULT microphoneOpen(BOOL status);

	ACRE_RESULT unMuteAll( void );

	DECLARE_MEMBER(BOOL, hadVAD);
	DECLARE_MEMBER(BOOL, InputActive);
	DECLARE_MEMBER(ACRE_STATE, State);
	DECLARE_MEMBER(BOOL, OnRadio);
	DECLARE_MEMBER(int, TsSpeakingState);
	DECLARE_MEMBER(BOOL, RadioPTTDown);
	DECLARE_MEMBER(BOOL, MainPTTDown);
	DECLARE_MEMBER(BOOL, DirectFirst);
	DECLARE_MEMBER(BOOL, HitTSSpeakingEvent);
	DECLARE_MEMBER(BOOL, IsX3DInitialized);
	DECLARE_MEMBER(UINT32, SpeakerMask)
protected:
	std::thread m_versionThreadHandle;
	char *m_vadLevel;
};