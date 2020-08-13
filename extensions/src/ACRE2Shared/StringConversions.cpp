#include "compat.h"

#include "StringConversions.h"
#include <string>

std::wstring StringConversions::stringToWstring(const std::string& str) {
    const int32_t num_chars = MultiByteToWideChar(CP_UTF8, 0, str.c_str(), str.length(), nullptr, 0);
    std::wstring wstrTo;
    if (num_chars) {
        wstrTo.resize(num_chars);
        MultiByteToWideChar(CP_UTF8, 0, str.c_str(), str.length(), &wstrTo[0], num_chars);
    }
    return wstrTo;
}

std::string StringConversions::wStringToString(const std::wstring& wstr) {
    const int32_t num_chars = WideCharToMultiByte(CP_UTF8, 0, wstr.c_str(), wstr.length(), nullptr, 0, nullptr, nullptr);
    std::string strTo;
    if (num_chars > 0) {
        strTo.resize(num_chars);
        WideCharToMultiByte(CP_UTF8, 0, wstr.c_str(), wstr.length(), &strTo[0], num_chars, nullptr, nullptr);
    }
    return strTo;
}
