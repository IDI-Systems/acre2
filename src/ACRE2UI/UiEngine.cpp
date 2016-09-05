#include "MainWindow.hpp"
#include "WelcomeDialog.hpp"
#include "UiEngine.hpp"

#include "SoundEngine.h"

MainWindow *g_configWindow;

unsigned int UiEngine::initialize() {
	Q_INIT_RESOURCE(resources);

	return ACRE_OK;
}

unsigned int UiEngine::launch(void* handle, void* qParentWidget) {
	
	g_configWindow = new MainWindow(static_cast<QWidget *>(qParentWidget));
	g_configWindow->show();

	return ACRE_OK;
}

unsigned int UiEngine::launch_welcome() {

	WelcomeDialog *welcomeDialog = new WelcomeDialog();
	welcomeDialog->show();

	return ACRE_OK;
}