// Read an INI file into easy-to-access name/value pairs.

#include <algorithm>
#include <cctype>
#include <cstdlib>
#include "ini.h"
#include "ini_reader.hpp"
#include <algorithm> 
#include <functional> 
#include <locale>

using std::string;
static inline std::string &ltrim(std::string &s) {
    s.erase(s.begin(), std::find_if(s.begin(), s.end(), std::not1(std::ptr_fun<int32_t , int32_t>(std::isspace))));
    return s;
}

// trim from end
static inline std::string &rtrim(std::string &s) {
    s.erase(std::find_if(s.rbegin(), s.rend(), std::not1(std::ptr_fun<int32_t , int32_t>(std::isspace))).base(), s.end());
    return s;
}

// trim from both ends
static inline std::string &trim(std::string &s) {
    return ltrim(rtrim(s));
}


ini_reader::ini_reader(string filename)
{
    _error = ini_parse(filename.c_str(), ValueHandler, this);
}

int32_t ini_reader::ParseError()
{
    return _error;
}

string ini_reader::Get(string section, string name, string default_value)
{
    if (ParseError() < 0)
        return default_value;

    string key = MakeKey(section, name);
    return _values.count(key) ? _values[key] : default_value;
}

int32_t ini_reader::GetInteger(string section, string name, int32_t default_value)
{
    if (ParseError() < 0)
        return default_value;

    string valstr = Get(section, name, "");
    const int8_t* value = valstr.c_str();
    int8_t* end;
    // This parses "1234" (decimal) and also "0x4D2" (hex)
    int32_t n = strtol(value, &end, 0);
    return end > value ? n : default_value;
}

double ini_reader::GetReal(string section, string name, double default_value)
{
    if (ParseError() < 0)
        return default_value;

    string valstr = Get(section, name, "");
    const int8_t* value = valstr.c_str();
    int8_t* end;
    double n = strtod(value, &end);
    return end > value ? n : default_value;
}

bool ini_reader::GetBoolean(string section, string name, bool default_value)
{
    if (ParseError() < 0)
        return default_value;

    string valstr = Get(section, name, "");
    // Convert to lower case to make string comparisons case-insensitive
    std::transform(valstr.begin(), valstr.end(), valstr.begin(), ::tolower);
    if (valstr == "true" || valstr == "yes" || valstr == "on" || valstr == "1")
        return true;
    else if (valstr == "false" || valstr == "no" || valstr == "off" || valstr == "0")
        return false;
    else
        return default_value;
}

string ini_reader::MakeKey(string section, string name)
{
    string key = section + "." + name;
    // Convert to lower case to make section/name lookups case-insensitive
    std::transform(key.begin(), key.end(), key.begin(), ::tolower);
    trim(key);

    return key;
}

int32_t ini_reader::ValueHandler(void* user, const int8_t* section, const int8_t* name,
    const int8_t* value)
{
    ini_reader* reader = (ini_reader*)user;
    string key = MakeKey(section, name);
    if (reader->_values[key].size() > 0)
        reader->_values[key] += "\n";

    // Escape quotes and/or terminating ; at the end of it
    std::string str_val = value;
    str_val.erase(remove(str_val.begin(), str_val.end(), '\"'), str_val.end());
    str_val.erase(remove(str_val.begin(), str_val.end(), ';'), str_val.end());

    trim(str_val);

    reader->_values[key] += str_val;
    return 1;
}
