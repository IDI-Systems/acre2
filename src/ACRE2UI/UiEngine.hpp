#pragma once

#include <cstdlib>

class UiEngine {
public:
	static unsigned int launch(void *, void *);
	static unsigned int launch_welcome();

	static unsigned int initialize();
};