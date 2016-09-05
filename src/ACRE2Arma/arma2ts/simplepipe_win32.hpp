#pragma once

#include <cstdint>
#include <string>
#include <vector>

#include <Winsock2.h>

class PipePair {
public:
	PipePair(bool inherit_fd2 = false, bool blocking = true);
	HANDLE fd1() const { return srv_; }
	HANDLE fd2() const { return cln_; }

	static HANDLE OpenPipeServer(const wchar_t* name, bool low_integrity = true, bool blocking = true);
	static HANDLE OpenPipeClient(const wchar_t* name, bool inherit, bool impersonate);

private:
	HANDLE srv_;
	HANDLE cln_;
};

class PipeWin {
public:
	PipeWin();
	~PipeWin();

	bool OpenClient(HANDLE pipe);
	bool OpenServer(HANDLE pipe, bool connect = false);

	bool Write(const void* buf, size_t sz);
	bool Read(void* buf, size_t* sz);

	bool CheckStatus();
	bool IsConnected() const { return INVALID_HANDLE_VALUE != pipe_; }

private:
	HANDLE pipe_;
};


class PipeTransport : public PipeWin {
public:
	static const size_t kBufferSz = 4096;

	size_t Send(const void* buf, size_t sz) {
	return Write(buf, sz) ? -1 : 0;
	}

	char* Receive(size_t* size);

private:
	std::vector<char> buf_;
};