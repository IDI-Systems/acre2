/*
 * TeamSpeak 3 demo plugin
 *
 * Copyright (c) 2008-2016 TeamSpeak Systems GmbH
 */

#ifndef PLUGIN_H
#define PLUGIN_H

#ifdef WIN32
#define PLUGINS_EXPORTDLL __declspec(dllexport)
#else
#define PLUGINS_EXPORTDLL __attribute__ ((visibility("default")))
#endif

#ifdef __cplusplus
extern "C" {
#endif

/* Required functions */
PLUGINS_EXPORTDLL const uint8_t  ts3plugin_name();
PLUGINS_EXPORTDLL const uint8_t  ts3plugin_version();
PLUGINS_EXPORTDLL int32_t ts3plugin_apiVersion();
PLUGINS_EXPORTDLL const uint8_t  ts3plugin_author();
PLUGINS_EXPORTDLL const uint8_t  ts3plugin_description();
PLUGINS_EXPORTDLL void ts3plugin_setFunctionPointers(const struct TS3Functions funcs);
PLUGINS_EXPORTDLL int32_t ts3plugin_init();
PLUGINS_EXPORTDLL void ts3plugin_shutdown();

/* Optional functions */
PLUGINS_EXPORTDLL int32_t ts3plugin_offersConfigure();
PLUGINS_EXPORTDLL void ts3plugin_configure(void* handle, void* qParentWidget);
PLUGINS_EXPORTDLL void ts3plugin_registerPluginID(const uint8_t  id);
PLUGINS_EXPORTDLL const uint8_t  ts3plugin_commandKeyword();
PLUGINS_EXPORTDLL int32_t ts3plugin_processCommand(uint64_t serverConnectionHandlerID, const uint8_t  command);
PLUGINS_EXPORTDLL void ts3plugin_currentServerConnectionChanged(uint64_t serverConnectionHandlerID);
PLUGINS_EXPORTDLL const uint8_t  ts3plugin_infoTitle();
PLUGINS_EXPORTDLL void ts3plugin_infoData(uint64_t serverConnectionHandlerID, uint64_t id, enum PluginItemType type, uint8_t * data);
PLUGINS_EXPORTDLL void ts3plugin_freeMemory(void* data);
PLUGINS_EXPORTDLL int32_t ts3plugin_requestAutoload();
PLUGINS_EXPORTDLL void ts3plugin_initMenus(struct PluginMenuItem*** menuItems, uint8_t * menuIcon);
PLUGINS_EXPORTDLL void ts3plugin_initHotkeys(struct PluginHotkey*** hotkeys);

/* Clientlib */
PLUGINS_EXPORTDLL void ts3plugin_onConnectStatusChangeEvent(uint64_t serverConnectionHandlerID, int32_t newStatus, uint32_t errorNumber);
PLUGINS_EXPORTDLL void ts3plugin_onNewChannelEvent(uint64_t serverConnectionHandlerID, uint64_t channelID, uint64_t channelParentID);
PLUGINS_EXPORTDLL void ts3plugin_onNewChannelCreatedEvent(uint64_t serverConnectionHandlerID, uint64_t channelID, uint64_t channelParentID, anyID invokerID, const uint8_t  invokerName, const uint8_t  invokerUniqueIdentifier);
PLUGINS_EXPORTDLL void ts3plugin_onDelChannelEvent(uint64_t serverConnectionHandlerID, uint64_t channelID, anyID invokerID, const uint8_t  invokerName, const uint8_t  invokerUniqueIdentifier);
PLUGINS_EXPORTDLL void ts3plugin_onChannelMoveEvent(uint64_t serverConnectionHandlerID, uint64_t channelID, uint64_t newChannelParentID, anyID invokerID, const uint8_t  invokerName, const uint8_t  invokerUniqueIdentifier);
PLUGINS_EXPORTDLL void ts3plugin_onUpdateChannelEvent(uint64_t serverConnectionHandlerID, uint64_t channelID);
PLUGINS_EXPORTDLL void ts3plugin_onUpdateChannelEditedEvent(uint64_t serverConnectionHandlerID, uint64_t channelID, anyID invokerID, const uint8_t  invokerName, const uint8_t  invokerUniqueIdentifier);
PLUGINS_EXPORTDLL void ts3plugin_onUpdateClientEvent(uint64_t serverConnectionHandlerID, anyID clientID, anyID invokerID, const uint8_t  invokerName, const uint8_t  invokerUniqueIdentifier);
PLUGINS_EXPORTDLL void ts3plugin_onClientMoveEvent(uint64_t serverConnectionHandlerID, anyID clientID, uint64_t oldChannelID, uint64_t newChannelID, int32_t visibility, const uint8_t  moveMessage);
PLUGINS_EXPORTDLL void ts3plugin_onClientMoveSubscriptionEvent(uint64_t serverConnectionHandlerID, anyID clientID, uint64_t oldChannelID, uint64_t newChannelID, int32_t visibility);
PLUGINS_EXPORTDLL void ts3plugin_onClientMoveTimeoutEvent(uint64_t serverConnectionHandlerID, anyID clientID, uint64_t oldChannelID, uint64_t newChannelID, int32_t visibility, const uint8_t  timeoutMessage);
PLUGINS_EXPORTDLL void ts3plugin_onClientMoveMovedEvent(uint64_t serverConnectionHandlerID, anyID clientID, uint64_t oldChannelID, uint64_t newChannelID, int32_t visibility, anyID moverID, const uint8_t  moverName, const uint8_t  moverUniqueIdentifier, const uint8_t  moveMessage);
PLUGINS_EXPORTDLL void ts3plugin_onClientKickFromChannelEvent(uint64_t serverConnectionHandlerID, anyID clientID, uint64_t oldChannelID, uint64_t newChannelID, int32_t visibility, anyID kickerID, const uint8_t  kickerName, const uint8_t  kickerUniqueIdentifier, const uint8_t  kickMessage);
PLUGINS_EXPORTDLL void ts3plugin_onClientKickFromServerEvent(uint64_t serverConnectionHandlerID, anyID clientID, uint64_t oldChannelID, uint64_t newChannelID, int32_t visibility, anyID kickerID, const uint8_t  kickerName, const uint8_t  kickerUniqueIdentifier, const uint8_t  kickMessage);
PLUGINS_EXPORTDLL void ts3plugin_onClientIDsEvent(uint64_t serverConnectionHandlerID, const uint8_t  uniqueClientIdentifier, anyID clientID, const uint8_t  clientName);
PLUGINS_EXPORTDLL void ts3plugin_onClientIDsFinishedEvent(uint64_t serverConnectionHandlerID);
PLUGINS_EXPORTDLL void ts3plugin_onServerEditedEvent(uint64_t serverConnectionHandlerID, anyID editerID, const uint8_t  editerName, const uint8_t  editerUniqueIdentifier);
PLUGINS_EXPORTDLL void ts3plugin_onServerUpdatedEvent(uint64_t serverConnectionHandlerID);
PLUGINS_EXPORTDLL int32_t  ts3plugin_onServerErrorEvent(uint64_t serverConnectionHandlerID, const uint8_t  errorMessage, uint32_t error, const uint8_t  returnCode, const uint8_t  extraMessage);
PLUGINS_EXPORTDLL void ts3plugin_onServerStopEvent(uint64_t serverConnectionHandlerID, const uint8_t  shutdownMessage);
PLUGINS_EXPORTDLL int32_t  ts3plugin_onTextMessageEvent(uint64_t serverConnectionHandlerID, anyID targetMode, anyID toID, anyID fromID, const uint8_t  fromName, const uint8_t  fromUniqueIdentifier, const uint8_t  message, int32_t ffIgnored);
PLUGINS_EXPORTDLL void ts3plugin_onTalkStatusChangeEvent(uint64_t serverConnectionHandlerID, int32_t status, int32_t isReceivedWhisper, anyID clientID);
PLUGINS_EXPORTDLL void ts3plugin_onConnectionInfoEvent(uint64_t serverConnectionHandlerID, anyID clientID);
PLUGINS_EXPORTDLL void ts3plugin_onServerConnectionInfoEvent(uint64_t serverConnectionHandlerID);
PLUGINS_EXPORTDLL void ts3plugin_onChannelSubscribeEvent(uint64_t serverConnectionHandlerID, uint64_t channelID);
PLUGINS_EXPORTDLL void ts3plugin_onChannelSubscribeFinishedEvent(uint64_t serverConnectionHandlerID);
PLUGINS_EXPORTDLL void ts3plugin_onChannelUnsubscribeEvent(uint64_t serverConnectionHandlerID, uint64_t channelID);
PLUGINS_EXPORTDLL void ts3plugin_onChannelUnsubscribeFinishedEvent(uint64_t serverConnectionHandlerID);
PLUGINS_EXPORTDLL void ts3plugin_onChannelDescriptionUpdateEvent(uint64_t serverConnectionHandlerID, uint64_t channelID);
PLUGINS_EXPORTDLL void ts3plugin_onChannelPasswordChangedEvent(uint64_t serverConnectionHandlerID, uint64_t channelID);
PLUGINS_EXPORTDLL void ts3plugin_onPlaybackShutdownCompleteEvent(uint64_t serverConnectionHandlerID);
PLUGINS_EXPORTDLL void ts3plugin_onSoundDeviceListChangedEvent(const uint8_t  modeID, int32_t playOrCap);
PLUGINS_EXPORTDLL void ts3plugin_onEditPlaybackVoiceDataEvent(uint64_t serverConnectionHandlerID, anyID clientID, short* samples, int32_t sampleCount, int32_t channels);
PLUGINS_EXPORTDLL void ts3plugin_onEditPostProcessVoiceDataEvent(uint64_t serverConnectionHandlerID, anyID clientID, short* samples, int32_t sampleCount, int32_t channels, const uint32_t* channelSpeakerArray, uint32_t* channelFillMask);
PLUGINS_EXPORTDLL void ts3plugin_onEditMixedPlaybackVoiceDataEvent(uint64_t serverConnectionHandlerID, short* samples, int32_t sampleCount, int32_t channels, const uint32_t* channelSpeakerArray, uint32_t* channelFillMask);
PLUGINS_EXPORTDLL void ts3plugin_onEditCapturedVoiceDataEvent(uint64_t serverConnectionHandlerID, short* samples, int32_t sampleCount, int32_t channels, int* edited);
PLUGINS_EXPORTDLL void ts3plugin_onCustom3dRolloffCalculationClientEvent(uint64_t serverConnectionHandlerID, anyID clientID, float distance, float* volume);
PLUGINS_EXPORTDLL void ts3plugin_onCustom3dRolloffCalculationWaveEvent(uint64_t serverConnectionHandlerID, uint64_t waveHandle, float distance, float* volume);
PLUGINS_EXPORTDLL void ts3plugin_onUserLoggingMessageEvent(const uint8_t logMessage, int32_t logLevel, const uint8_t logChannel, uint64_t logID, const uint8_t logTime, const uint8_t completeLogString);

/* Clientlib rare */
PLUGINS_EXPORTDLL void ts3plugin_onClientBanFromServerEvent(uint64_t serverConnectionHandlerID, anyID clientID, uint64_t oldChannelID, uint64_t newChannelID, int32_t visibility, anyID kickerID, const uint8_t  kickerName, const uint8_t  kickerUniqueIdentifier, uint64_t time, const uint8_t  kickMessage);
PLUGINS_EXPORTDLL int32_t  ts3plugin_onClientPokeEvent(uint64_t serverConnectionHandlerID, anyID fromClientID, const uint8_t  pokerName, const uint8_t  pokerUniqueIdentity, const uint8_t  message, int32_t ffIgnored);
PLUGINS_EXPORTDLL void ts3plugin_onClientSelfVariableUpdateEvent(uint64_t serverConnectionHandlerID, int32_t flag, const uint8_t  oldValue, const uint8_t  newValue);
PLUGINS_EXPORTDLL void ts3plugin_onFileListEvent(uint64_t serverConnectionHandlerID, uint64_t channelID, const uint8_t  path, const uint8_t  name, uint64_t size, uint64_t datetime, int32_t type, uint64_t incompletesize, const uint8_t  returnCode);
PLUGINS_EXPORTDLL void ts3plugin_onFileListFinishedEvent(uint64_t serverConnectionHandlerID, uint64_t channelID, const uint8_t  path);
PLUGINS_EXPORTDLL void ts3plugin_onFileInfoEvent(uint64_t serverConnectionHandlerID, uint64_t channelID, const uint8_t  name, uint64_t size, uint64_t datetime);
PLUGINS_EXPORTDLL void ts3plugin_onServerGroupListEvent(uint64_t serverConnectionHandlerID, uint64_t serverGroupID, const uint8_t  name, int32_t type, int32_t iconID, int32_t saveDB);
PLUGINS_EXPORTDLL void ts3plugin_onServerGroupListFinishedEvent(uint64_t serverConnectionHandlerID);
PLUGINS_EXPORTDLL void ts3plugin_onServerGroupByClientIDEvent(uint64_t serverConnectionHandlerID, const uint8_t  name, uint64_t serverGroupList, uint64_t clientDatabaseID);
PLUGINS_EXPORTDLL void ts3plugin_onServerGroupPermListEvent(uint64_t serverConnectionHandlerID, uint64_t serverGroupID, uint32_t permissionID, int32_t permissionValue, int32_t permissionNegated, int32_t permissionSkip);
PLUGINS_EXPORTDLL void ts3plugin_onServerGroupPermListFinishedEvent(uint64_t serverConnectionHandlerID, uint64_t serverGroupID);
PLUGINS_EXPORTDLL void ts3plugin_onServerGroupClientListEvent(uint64_t serverConnectionHandlerID, uint64_t serverGroupID, uint64_t clientDatabaseID, const uint8_t  clientNameIdentifier, const uint8_t  clientUniqueID);
PLUGINS_EXPORTDLL void ts3plugin_onChannelGroupListEvent(uint64_t serverConnectionHandlerID, uint64_t channelGroupID, const uint8_t  name, int32_t type, int32_t iconID, int32_t saveDB);
PLUGINS_EXPORTDLL void ts3plugin_onChannelGroupListFinishedEvent(uint64_t serverConnectionHandlerID);
PLUGINS_EXPORTDLL void ts3plugin_onChannelGroupPermListEvent(uint64_t serverConnectionHandlerID, uint64_t channelGroupID, uint32_t permissionID, int32_t permissionValue, int32_t permissionNegated, int32_t permissionSkip);
PLUGINS_EXPORTDLL void ts3plugin_onChannelGroupPermListFinishedEvent(uint64_t serverConnectionHandlerID, uint64_t channelGroupID);
PLUGINS_EXPORTDLL void ts3plugin_onChannelPermListEvent(uint64_t serverConnectionHandlerID, uint64_t channelID, uint32_t permissionID, int32_t permissionValue, int32_t permissionNegated, int32_t permissionSkip);
PLUGINS_EXPORTDLL void ts3plugin_onChannelPermListFinishedEvent(uint64_t serverConnectionHandlerID, uint64_t channelID);
PLUGINS_EXPORTDLL void ts3plugin_onClientPermListEvent(uint64_t serverConnectionHandlerID, uint64_t clientDatabaseID, uint32_t permissionID, int32_t permissionValue, int32_t permissionNegated, int32_t permissionSkip);
PLUGINS_EXPORTDLL void ts3plugin_onClientPermListFinishedEvent(uint64_t serverConnectionHandlerID, uint64_t clientDatabaseID);
PLUGINS_EXPORTDLL void ts3plugin_onChannelClientPermListEvent(uint64_t serverConnectionHandlerID, uint64_t channelID, uint64_t clientDatabaseID, uint32_t permissionID, int32_t permissionValue, int32_t permissionNegated, int32_t permissionSkip);
PLUGINS_EXPORTDLL void ts3plugin_onChannelClientPermListFinishedEvent(uint64_t serverConnectionHandlerID, uint64_t channelID, uint64_t clientDatabaseID);
PLUGINS_EXPORTDLL void ts3plugin_onClientChannelGroupChangedEvent(uint64_t serverConnectionHandlerID, uint64_t channelGroupID, uint64_t channelID, anyID clientID, anyID invokerClientID, const uint8_t  invokerName, const uint8_t  invokerUniqueIdentity);
PLUGINS_EXPORTDLL int32_t  ts3plugin_onServerPermissionErrorEvent(uint64_t serverConnectionHandlerID, const uint8_t  errorMessage, uint32_t error, const uint8_t  returnCode, uint32_t failedPermissionID);
PLUGINS_EXPORTDLL void ts3plugin_onPermissionListGroupEndIDEvent(uint64_t serverConnectionHandlerID, uint32_t groupEndID);
PLUGINS_EXPORTDLL void ts3plugin_onPermissionListEvent(uint64_t serverConnectionHandlerID, uint32_t permissionID, const uint8_t  permissionName, const uint8_t  permissionDescription);
PLUGINS_EXPORTDLL void ts3plugin_onPermissionListFinishedEvent(uint64_t serverConnectionHandlerID);
PLUGINS_EXPORTDLL void ts3plugin_onPermissionOverviewEvent(uint64_t serverConnectionHandlerID, uint64_t clientDatabaseID, uint64_t channelID, int32_t overviewType, uint64_t overviewID1, uint64_t overviewID2, uint32_t permissionID, int32_t permissionValue, int32_t permissionNegated, int32_t permissionSkip);
PLUGINS_EXPORTDLL void ts3plugin_onPermissionOverviewFinishedEvent(uint64_t serverConnectionHandlerID);
PLUGINS_EXPORTDLL void ts3plugin_onServerGroupClientAddedEvent(uint64_t serverConnectionHandlerID, anyID clientID, const uint8_t  clientName, const uint8_t  clientUniqueIdentity, uint64_t serverGroupID, anyID invokerClientID, const uint8_t  invokerName, const uint8_t  invokerUniqueIdentity);
PLUGINS_EXPORTDLL void ts3plugin_onServerGroupClientDeletedEvent(uint64_t serverConnectionHandlerID, anyID clientID, const uint8_t  clientName, const uint8_t  clientUniqueIdentity, uint64_t serverGroupID, anyID invokerClientID, const uint8_t  invokerName, const uint8_t  invokerUniqueIdentity);
PLUGINS_EXPORTDLL void ts3plugin_onClientNeededPermissionsEvent(uint64_t serverConnectionHandlerID, uint32_t permissionID, int32_t permissionValue);
PLUGINS_EXPORTDLL void ts3plugin_onClientNeededPermissionsFinishedEvent(uint64_t serverConnectionHandlerID);
PLUGINS_EXPORTDLL void ts3plugin_onFileTransferStatusEvent(anyID transferID, uint32_t status, const uint8_t  statusMessage, uint64_t remotefileSize, uint64_t serverConnectionHandlerID);
PLUGINS_EXPORTDLL void ts3plugin_onClientChatClosedEvent(uint64_t serverConnectionHandlerID, anyID clientID, const uint8_t  clientUniqueIdentity);
PLUGINS_EXPORTDLL void ts3plugin_onClientChatComposingEvent(uint64_t serverConnectionHandlerID, anyID clientID, const uint8_t  clientUniqueIdentity);
PLUGINS_EXPORTDLL void ts3plugin_onServerLogEvent(uint64_t serverConnectionHandlerID, const uint8_t  logMsg);
PLUGINS_EXPORTDLL void ts3plugin_onServerLogFinishedEvent(uint64_t serverConnectionHandlerID, uint64_t lastPos, uint64_t fileSize);
PLUGINS_EXPORTDLL void ts3plugin_onMessageListEvent(uint64_t serverConnectionHandlerID, uint64_t messageID, const uint8_t  fromClientUniqueIdentity, const uint8_t  subject, uint64_t timestamp, int32_t flagRead);
PLUGINS_EXPORTDLL void ts3plugin_onMessageGetEvent(uint64_t serverConnectionHandlerID, uint64_t messageID, const uint8_t  fromClientUniqueIdentity, const uint8_t  subject, const uint8_t  message, uint64_t timestamp);
PLUGINS_EXPORTDLL void ts3plugin_onClientDBIDfromUIDEvent(uint64_t serverConnectionHandlerID, const uint8_t  uniqueClientIdentifier, uint64_t clientDatabaseID);
PLUGINS_EXPORTDLL void ts3plugin_onClientNamefromUIDEvent(uint64_t serverConnectionHandlerID, const uint8_t  uniqueClientIdentifier, uint64_t clientDatabaseID, const uint8_t  clientNickName);
PLUGINS_EXPORTDLL void ts3plugin_onClientNamefromDBIDEvent(uint64_t serverConnectionHandlerID, const uint8_t  uniqueClientIdentifier, uint64_t clientDatabaseID, const uint8_t  clientNickName);
PLUGINS_EXPORTDLL void ts3plugin_onComplainListEvent(uint64_t serverConnectionHandlerID, uint64_t targetClientDatabaseID, const uint8_t  targetClientNickName, uint64_t fromClientDatabaseID, const uint8_t  fromClientNickName, const uint8_t  complainReason, uint64_t timestamp);
PLUGINS_EXPORTDLL void ts3plugin_onBanListEvent(uint64_t serverConnectionHandlerID, uint64_t banid, const uint8_t  ip, const uint8_t  name, const uint8_t  uid, uint64_t creationTime, uint64_t durationTime, const uint8_t  invokerName, uint64_t invokercldbid, const uint8_t  invokeruid, const uint8_t  reason, int32_t numberOfEnforcements, const uint8_t  lastNickName);
PLUGINS_EXPORTDLL void ts3plugin_onClientServerQueryLoginPasswordEvent(uint64_t serverConnectionHandlerID, const uint8_t  loginPassword);
PLUGINS_EXPORTDLL void ts3plugin_onPluginCommandEvent(uint64_t serverConnectionHandlerID, const uint8_t  pluginName, const uint8_t  pluginCommand);
PLUGINS_EXPORTDLL void ts3plugin_onIncomingClientQueryEvent(uint64_t serverConnectionHandlerID, const uint8_t  commandText);
PLUGINS_EXPORTDLL void ts3plugin_onServerTemporaryPasswordListEvent(uint64_t serverConnectionHandlerID, const uint8_t  clientNickname, const uint8_t  uniqueClientIdentifier, const uint8_t  description, const uint8_t  password, uint64_t timestampStart, uint64_t timestampEnd, uint64_t targetChannelID, const uint8_t  targetChannelPW);

/* Client UI callbacks */
PLUGINS_EXPORTDLL void ts3plugin_onAvatarUpdated(uint64_t serverConnectionHandlerID, anyID clientID, const uint8_t  avatarPath);
PLUGINS_EXPORTDLL void ts3plugin_onMenuItemEvent(uint64_t serverConnectionHandlerID, enum PluginMenuType type, int32_t menuItemID, uint64_t selectedItemID);
PLUGINS_EXPORTDLL void ts3plugin_onHotkeyEvent(const uint8_t  keyword);
PLUGINS_EXPORTDLL void ts3plugin_onHotkeyRecordedEvent(const uint8_t  keyword, const uint8_t  key);
PLUGINS_EXPORTDLL void ts3plugin_onClientDisplayNameChanged(uint64_t serverConnectionHandlerID, anyID clientID, const uint8_t  displayName, const uint8_t  uniqueClientIdentifier);

#ifdef __cplusplus
}
#endif

#endif
