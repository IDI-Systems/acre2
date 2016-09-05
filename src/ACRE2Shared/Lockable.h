#pragma once
#include "compat.h"

#include <mutex>


class CLockable {
private:
	std::recursive_mutex m_lockable_mutex;
public:
	void lock( void ) {
		m_lockable_mutex.lock();
	};

	void unlock( void ) {
		m_lockable_mutex.unlock();
	};
};