#pragma once

#include <string>

class StringConversions {
public:
    static std::wstring stringToWstring(const std::string& str);
    static std::string wStringToString(const std::wstring& wstr);
};
