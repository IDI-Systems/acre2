#include "compat.h"
//#include "Log.h"
#include "macros.h"
#include <string>
#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <algorithm>
#include "shlobj.h"
#include "Shlwapi.h"
#include <algorithm> 
#include <functional> 
#include <cctype>
#include <locale>

// trim from start
static inline std::string &ltrim(std::string &s) {
	s.erase(s.begin(), std::find_if(s.begin(), s.end(), std::not1(std::ptr_fun<int, int>(std::isspace))));
	return s;
}

// trim from end
static inline std::string &rtrim(std::string &s) {
	s.erase(std::find_if(s.rbegin(), s.rend(), std::not1(std::ptr_fun<int, int>(std::isspace))).base(), s.end());
	return s;
}

// trim from both ends
static inline std::string &trim(std::string &s) {
	return ltrim(rtrim(s));
}
#include "simplepipe_win32.hpp"

#pragma comment(lib, "shlwapi.lib")

#define PIPE_COMMAND_OPEN	0
#define PIPE_COMMAND_CLOSE	1
#define PIPE_COMMAND_WRITE	2
#define PIPE_COMMAND_READ	3
#define PIPE_COMMAND_RESET	4
#define JVON_CLIENT_START	5
#define JVON_CLIENT_STOP	6
#define JVON_SERVER_START	7
#define JVON_SERVER_STOP	8
#define JVON_CLIENT_CHECK	9
#define JVON_SERVER_CHECK	10
#define JVON_KEEPALIVE_OPEN 11
#define JVON_KEEPALIVE_CLOSE 12
#define JVON_KEEPALIVE_STATUS 13

#define FROM_PIPENAME_JVON	"\\\\.\\pipe\\acre_comm_pipe_fromJVON"
#define TO_PIPENAME_JVON	"\\\\.\\pipe\\acre_comm_pipe_toJVON"

#define FROM_PIPENAME_TS	"\\\\.\\pipe\\acre_comm_pipe_fromTS"
#define TO_PIPENAME_TS		"\\\\.\\pipe\\acre_comm_pipe_toTS"


HANDLE	writeHandle = INVALID_HANDLE_VALUE;
HANDLE	readHandle = INVALID_HANDLE_VALUE;
PipeWin *keepalivePipe = nullptr;

BOOL writeConnected, readConnected;



void ClosePipe();

extern "C" 
{
  __declspec(dllexport) void __stdcall RVExtension(char *output, int outputSize, const char *function); 
};

inline std::string get_path() {
	char moduleName[MAX_PATH];
	GetModuleFileNameA(NULL, moduleName, MAX_PATH);
	return std::string(moduleName);
}

inline std::string get_cmdline() {
	return std::string(GetCommandLineA());
}

inline std::string get_path(std::string filepath) {
	char drive[_MAX_DRIVE];
	char dir [_MAX_DIR];
	
	_splitpath(
		filepath.c_str(),
		drive,
		dir,
		NULL,
		NULL
		);
	std::string path = std::string(drive) + std::string(dir);

	return path;
}

inline std::string get_quoted(std::string text) {
	std::string::size_type    start_position = 0;
	std::string::size_type    end_position = 0;
	std::string               found_text;

	start_position = text.find("\"");
	if (start_position != std::string::npos)
	{
		++start_position; // start after the double quotes.
						  // look for end position;
		end_position = text.find("\"");
		if (end_position != std::string::npos)
		{
			found_text = text.substr(start_position, end_position - start_position);
		}
	}
	return found_text;
}
EXTERN_C IMAGE_DOS_HEADER __ImageBase;
inline std::string find_mod_file(std::string filename) {
	char module_path[MAX_PATH];
	GetModuleFileNameA((HINSTANCE)&__ImageBase, module_path, MAX_PATH);

	char drive[_MAX_DRIVE];
	char dir[_MAX_DIR];

	_splitpath(
		module_path,
		drive,
		dir,
		NULL,
		NULL
		);

	std::string path = std::string(drive) + std::string(dir) + "\\" + filename;
	if (!PathFileExistsA(path.c_str())) {
		// No mod path was set, it means they used the mod config. It *DOES* mean it relative to a folder in our path at least. 
		// So, we just search all the local folders

		WIN32_FIND_DATAA data;
		std::string path("*");
		std::string *name;
		HANDLE hFile = FindFirstFileA(path.c_str(), &data);

		if (hFile == INVALID_HANDLE_VALUE)
			return "";

		while (FindNextFile(hFile, &data) != 0 || GetLastError() != ERROR_NO_MORE_FILES) {
			if (data.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) {
				std::string fullpath = std::string(data.cFileName) + "\\" + filename;
				if (PathFileExistsA(fullpath.c_str())) {
					path = fullpath;
					break;
				}
			}
		}
	}
	return path;
}

/* THIS WAS BROKEN WHY WERNT WE JUST USING GETMODULEFILENAME!?
inline std::string parse_modlines(std::string filename) {
	// First, extract the mod paths
	//	Then test each one to see if the specified path filename exists
	std::string cmd_line = get_cmdline();
	std::string acre_mod_path;
	std::string mod_path;
	std::string par_path;

	std::string return_path;

	// BUGFIX
	// Fixes bug idi-systems/jvon#8: if its a par file, we need to parse for \r\n and just pass that modline instead. So, we handle our own modline parsing here. 
	if (cmd_line.find_first_of("-par") != std::string::npos) {	// Parse a PAR file
		par_path = cmd_line.substr(cmd_line.find("-par") + 5, cmd_line.size() - (cmd_line.find("-par") + 5));

		size_t end_index = par_path.find_first_of(" ");
		if (par_path.find_first_of(" ") == std::string::npos)
			end_index = par_path.size();
		par_path.resize(end_index);

		// We pull the par, condense the \r\n to spaces, then replace cmd_line with it
		if (PathFileExistsA(par_path.c_str())) {
			std::ifstream par_file(par_path);
			std::string par_str((std::istreambuf_iterator<char>(par_file)),
				std::istreambuf_iterator<char>());
			cmd_line = par_str;

			mod_path = cmd_line.substr(cmd_line.find("-mod") + 5, cmd_line.size() - (cmd_line.find("-mod") + 5));

			//Check for spaces OR quote in the modline.End the modline at the first instance of either.
			size_t end_index_1 = mod_path.find_first_of("\r");
			size_t end_index_2 = mod_path.find_first_of("\n");
			
			// resize to end
			size_t end_index = std::min(end_index_1, end_index_2);
			if (mod_path.find_first_of("\r") == std::string::npos && mod_path.find_first_of("\n") == std::string::npos)
				end_index = mod_path.size();
			mod_path.resize(end_index);

			// Bugfix:  trim spaces
			trim(mod_path);

			//mod_path
			std::vector<std::string> strings;
			std::stringstream mod_path_f(mod_path);

			std::string mod;
			while (getline(mod_path_f, mod, ';')) {
				std::string fullpath = mod + "\\" + filename;
				if (PathFileExistsA(fullpath.c_str())) {
					acre_mod_path = fullpath;
					break;
				}
			}
		}
	} else {		// Its a modline

		if (cmd_line.find_first_of("-mod") != std::string::npos) {
			mod_path = cmd_line.substr(cmd_line.find("-mod") + 5, cmd_line.size() - (cmd_line.find("-mod") + 5));

			//Bugfix: Fixes idi-systems/jvon#8 : Check for spaces OR quote in the modline. End the modline at the first instance of either.
			size_t end_index_1 = mod_path.find_first_of(" ");
			size_t end_index_2 = mod_path.find_first_of("\"");
			size_t end_index = std::min(end_index_1, end_index_2);
			if (mod_path.find_first_of(" ") == std::string::npos)
				end_index = mod_path.size();
			mod_path.resize(end_index);

			// Bugfix:  trim spaces
			trim(mod_path);

			//mod_path
			std::vector<std::string> strings;
			std::stringstream mod_path_f(mod_path);

			std::string mod;
			while (getline(mod_path_f, mod, ';')) {
				std::string fullpath = mod + "\\" + filename;
				if (PathFileExistsA(fullpath.c_str())) {
					acre_mod_path = fullpath;
					break;
				}
			}
		}
	}
	if(acre_mod_path.empty()) {
		// No mod path was set, it means they used the mod config. It *DOES* mean it relative to a folder in our path at least. 
		// So, we just search all the local folders

		WIN32_FIND_DATAA data;
		std::string path("*");
		std::string *name;
		HANDLE hFile = FindFirstFileA(path.c_str(), &data);

		if (hFile == INVALID_HANDLE_VALUE)
			return "";

		while (FindNextFile(hFile, &data) != 0 || GetLastError() != ERROR_NO_MORE_FILES) {
			if (data.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) {
				std::string fullpath = std::string(data.cFileName) + "\\" + filename;
				if (PathFileExistsA(fullpath.c_str())) {
					acre_mod_path = fullpath;
					break;
				}
			}
		}
	}

	return acre_mod_path;
}
*/
void __stdcall RVExtension(char *output, int outputSize, const char *function)
{
	size_t id_length = 1;
	std::string functionStr = std::string(function);
	
	if (functionStr.length() > 1) {
		if (isdigit(functionStr.substr(1, 1).c_str()[0])) {
			id_length = 2;
		}
	}

	std::string id = functionStr.substr(0, id_length);
	std::string params;
	if(functionStr.length() > 1) {
		params = functionStr.substr(id_length, functionStr.length() - id_length);
	}

	int command = atoi(id.c_str());

	switch(command) {
		
		case PIPE_COMMAND_WRITE: {
			if(writeConnected) {
				if(params.length() > 0) {
					DWORD cbWritten;
					BOOL ret;
					//DEBUG("Writing [%s] to pipe [%d]\n", params.c_str(), hPipe);
			
					// Send a message to the pipe server. 
					ret = WriteFile( 
					writeHandle,                  // pipe handle 
					params.c_str(),					// message 
					params.length(),			// message length 
					&cbWritten,             // bytes written 
					NULL);                  // not overlapped 
					if(cbWritten != params.length()) {
						FlushFileBuffers(writeHandle);
						//printf("FLUSHING!\n");
					}
					//printf("WriteFile: %d %d of %d\n", GetLastError(), cbWritten, params.length());
					//FlushFileBuffers(hPipe);
					if ( ! ret) {
						//DEBUG("WriteFile failed, [%d]\n", GetLastError());
						ClosePipe();
						strncpy(output,"0",outputSize);
						return;
					}
					strncpy(output,"1",outputSize);
				}
			} else {
				ClosePipe();
				strncpy(output,"-1",outputSize);
			}
			return;
		}
		case PIPE_COMMAND_READ: {
			if(readConnected) {
				DWORD cbRead;
				DWORD err;
				BOOL ret;
				char *value = new char[4096];
				//DEBUG("Read from pipe [%d]\n", hPipe);
				ret = ReadFile(readHandle, (LPVOID)value, 4096, &cbRead, NULL);
				if ( ! ret) {
					err = GetLastError();
					if (err == ERROR_BROKEN_PIPE) {
						ClosePipe();
					}
					//DEBUG("ReadFile failed, [%08x]\r\n", err);
				}
				if(cbRead != 0) {
					//DEBUG("Read data: %s\n", value);
					strncpy(output,value,cbRead);
				} else {
					if(err == 232) {
						strncpy(output,"_JERR_NULL",outputSize);
					} else {
						//LOG("PIPE ERROR: %d\r\n", err);
						strncpy(output,"_JERR_FALSE",outputSize);
					}
				}
				delete value;
			} else {
				ClosePipe();
				strncpy(output,"_JERR_NOCONNECT",outputSize);
			}
			return;
		}
		case PIPE_COMMAND_OPEN: {
			BOOL ret;
			int tries = 0;
			if(readConnected || writeConnected) {
				ClosePipe();
				//Sleep(100);
			}
			std::string fromPipeName = FROM_PIPENAME_TS;
			std::string toPipeName = TO_PIPENAME_TS;

			if (params == "jvon") {
				fromPipeName = FROM_PIPENAME_JVON;
				toPipeName = TO_PIPENAME_JVON;
			}
			
			if (readHandle != INVALID_HANDLE_VALUE) {
				CloseHandle(readHandle);
				readConnected = false;
			}
			if(!readConnected) {
				while (tries < 1) {
					readHandle = CreateFileA( 
						fromPipeName.c_str(),		// pipe name 
						GENERIC_READ | GENERIC_WRITE, 
						0,              // no sharing 
						NULL,           // default security attributes
						OPEN_EXISTING,  // opens existing pipe 
						0,              // default attributes 
						NULL);          // no template file 
					if(readHandle != INVALID_HANDLE_VALUE) {
						DWORD dwModeRead = PIPE_NOWAIT | PIPE_READMODE_MESSAGE;
						ret = SetNamedPipeHandleState( 
								readHandle,    // pipe handle 
								&dwModeRead,  // new pipe mode 
								NULL,     // don't set maximum bytes 
								NULL);    // don't set maximum time 
						if ( ! ret) {
							//printf("READ PIPE MODE ERROR: %d\n", GetLastError());
							sprintf(output, "Read SetNamedPipeHandleState WinErrCode: %d", GetLastError());
							return;
						}
						//printf("READ CONNECTED\n");
						readConnected = TRUE;
						break;
					} else {
						if(GetLastError() == ERROR_PIPE_BUSY) {
							//if (!WaitNamedPipeA(fromPipeName.c_str(), NMPWAIT_USE_DEFAULT_WAIT))
								 tries++;
						} else {
							//printf("READ CONNECT ERROR: %d\n", GetLastError());
							sprintf(output, "Read CreateFileA WinErrCode: %d", GetLastError());
							return;
						}
					}
				}
				if(!readConnected) {
					sprintf(output, "Read Loop CreateFileA WinErrCode: %d", GetLastError());
					return;
				}
			}
			if (writeHandle != INVALID_HANDLE_VALUE) {
				CloseHandle(writeHandle);
				writeConnected = false;
			}
			if(!writeConnected) {
				tries = 0;
				while(tries < 1) {
					writeHandle = CreateFileA( 
						toPipeName.c_str(),		// pipe name 
						GENERIC_WRITE | GENERIC_READ,
						0,              // no sharing 
						NULL,           // default security attributes
						OPEN_EXISTING,  // opens existing pipe 
						0,              // default attributes 
						NULL);          // no template file 

					if(writeHandle != INVALID_HANDLE_VALUE) {
						DWORD dwModeWrite = PIPE_READMODE_MESSAGE;
						ret = SetNamedPipeHandleState( 
								writeHandle,    // pipe handle 
								&dwModeWrite,  // new pipe mode 
								NULL,     // don't set maximum bytes 
								NULL);    // don't set maximum time 
						if ( ! ret) {
							//printf("WRITE PIPE MODE ERROR: %d\n", GetLastError());
							sprintf(output, "Write SetNamedPipeHandleState WinErrCode: %d", GetLastError());
							return;
						}
						writeConnected = TRUE;
						break;
						//printf("WRITE CONNECTED\n");
					} else {
						if(GetLastError() == ERROR_PIPE_BUSY) {
							//if (!WaitNamedPipeA(fromPipeName.c_str(), NMPWAIT_USE_DEFAULT_WAIT))
								 tries++;
						} else {
							sprintf(output, "Write CreateFileA WinErrCode: %d", GetLastError());
							return;
						}
					}
				}
				if(!writeConnected) {
					sprintf(output, "Write Loop CreateFileA WinErrCode: %d", GetLastError());
					return;
				}
			}
			if(writeConnected && readConnected) {
				strncpy(output,"1",outputSize);
			} else {
				strncpy(output,"0",outputSize);
			}
			return;
		}
		case PIPE_COMMAND_CLOSE: {
			//printf("CLOSING\n");
			ClosePipe();
			return;
		}
		case PIPE_COMMAND_RESET: {
			ClosePipe();
			writeHandle = INVALID_HANDLE_VALUE;
			readHandle = INVALID_HANDLE_VALUE;
			return;
		}
		case JVON_CLIENT_START: {
			PROCESS_INFORMATION procInfo;
			STARTUPINFOA startInfo = { 0 };

			std::string bootstrapper_exe = find_mod_file("jvon\\bootstrapper_win32.exe");
			std::string startin_path = get_path(bootstrapper_exe);

			startInfo.cb = sizeof(startInfo);
			std::string cmd;
			cmd = bootstrapper_exe + " -r -b \"" + params + "\"";
			
			BOOL res = CreateProcessA(NULL,
				(LPSTR)cmd.c_str(),
				NULL,
				NULL,
				false,
				NORMAL_PRIORITY_CLASS,
				NULL,
				startin_path.c_str(),
				&startInfo,
				&procInfo);
			if (res) {
				strncpy(output, "1", outputSize);
			} else {
				sprintf(output, "CreateProcessA WinErrCode: %d, path={'%s'}, startin={'%s'}", GetLastError(), bootstrapper_exe.c_str(), startin_path.c_str());
			}
			return;
		}
		case JVON_CLIENT_STOP: {
			PROCESS_INFORMATION procInfo;
			STARTUPINFOA startInfo = { 0 };

			std::string bootstrapper_exe = find_mod_file("jvon\\bootstrapper_win32.exe");
			std::string startin_path = get_path(bootstrapper_exe);

			startInfo.cb = sizeof(startInfo);
			std::string cmd;
			cmd = bootstrapper_exe + " -s";
			BOOL res = CreateProcessA(NULL,
				(LPSTR)cmd.c_str(),
				NULL,
				NULL,
				false,
				NORMAL_PRIORITY_CLASS,
				NULL,
				startin_path.c_str(),
				&startInfo,
				&procInfo);

			if (res) {
				strncpy(output, "1", outputSize);
			} else {
				sprintf(output, "CreateProcessA WinErrCode: %d, path={'%s'}, startin={'%s'}", GetLastError(), bootstrapper_exe.c_str(), startin_path.c_str());
			}

			return;
		}
		case JVON_CLIENT_CHECK: {
			std::string bootstrapper_exe = find_mod_file("jvon\\bootstrapper_win32.exe");
			std::string client_exe = find_mod_file("jvon\\client_win32.exe");
			if (PathFileExistsA(bootstrapper_exe.c_str()) && PathFileExistsA(client_exe.c_str())) {
				strncpy(output, "1", outputSize);
			} else {
				strncpy(output, "0", outputSize);
			}

			return;
		}
		case JVON_SERVER_CHECK: {
			std::string bootstrapper_exe = find_mod_file("jvon\\bootstrapper_win32.exe");
			std::string server_exe = find_mod_file("jvon\\server_win32.exe");
			if (PathFileExistsA(bootstrapper_exe.c_str()) && PathFileExistsA(server_exe.c_str())) {
				strncpy(output, "1", outputSize);
			}
			else {
				strncpy(output, "0", outputSize);
			}

			return;
		}
		case JVON_KEEPALIVE_OPEN: {
			HANDLE _hPipe;
			if ((_hPipe = PipePair::OpenPipeClient(L"jvon_bootstrapper_win32_keepalive", true, true)) == INVALID_HANDLE_VALUE) {
				for (int tries = 0; tries < 4; tries++) {
					if (GetLastError() == ERROR_FILE_NOT_FOUND) {
						if ((_hPipe = PipePair::OpenPipeClient(L"jvon_bootstrapper_win32_keepalive", true, true)) != INVALID_HANDLE_VALUE) {
							break;
						}
					} else {
						break;
					}
					//Sleep(1000);
				}
				if (_hPipe == INVALID_HANDLE_VALUE) {
					sprintf(output, "PipePair::OpenPipeClient WinErrCode: %d", GetLastError());
					return;
				}
			}
			keepalivePipe = new PipeWin();
			keepalivePipe->OpenClient(_hPipe);
			sprintf(output, "1");

			return;
		}
		case JVON_KEEPALIVE_CLOSE: {
			if (keepalivePipe) {
				delete keepalivePipe;
				keepalivePipe = nullptr;
			}
			sprintf(output, "1");
			return;
		}
		case JVON_KEEPALIVE_STATUS: {
			if (keepalivePipe) {
				if(keepalivePipe->IsConnected() && keepalivePipe->CheckStatus())
					sprintf(output, "1");
				else
					sprintf(output, "0");
			} else {
				sprintf(output, "0");
			}
			
			return;
		}
		default:
			return;
	}
}

void ClosePipe() {

	if (writeHandle != INVALID_HANDLE_VALUE) {
		FlushFileBuffers(writeHandle);
		DisconnectNamedPipe(writeHandle);
		CloseHandle(writeHandle);
		writeHandle = INVALID_HANDLE_VALUE;
	}
	if (readHandle != INVALID_HANDLE_VALUE) {
		FlushFileBuffers(readHandle);
		DisconnectNamedPipe(readHandle);
		CloseHandle(readHandle);
		readHandle = INVALID_HANDLE_VALUE;
	}

	writeConnected = FALSE;
	readConnected = FALSE;
}


void Init(void) {
	//g_Log = (Log *)new Log("ACRE2Arma.log");
	//LOG("* Logging engine initialized.");
	writeConnected = FALSE;
	readConnected = FALSE;
}

void Cleanup(void) {

}


BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
					 )
{
	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
		Init();
		break;
	case DLL_THREAD_ATTACH:
	case DLL_THREAD_DETACH:
	case DLL_PROCESS_DETACH:
		Cleanup();
		break;
	}
	return TRUE;
}
