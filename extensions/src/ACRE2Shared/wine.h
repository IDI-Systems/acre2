#pragma once

inline bool detectWine() {
    FARPROC pwine_get_version;
    HMODULE hntdll = GetModuleHandle("ntdll.dll");
    if(hntdll) {
      if(GetProcAddress(hntdll, "wine_get_version")) {
          return 1;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
}
