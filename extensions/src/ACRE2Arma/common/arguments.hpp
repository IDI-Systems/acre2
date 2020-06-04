#pragma once

#include "shared.hpp"
#include "vector.hpp"

#include <vector>
#include <string>

namespace acre {
    class argument_accessor {
    public:
        argument_accessor(const uint32_t index, const std::vector<std::string> & ar) : _index(index), _args(ar) { }

        const std::string & as_string() const { return _args[_index]; }
        operator const std::string &() const { return as_string(); }

        float to_float(const std::string & val) const { float res = 0.0f; std::istringstream iss(val); iss >> res; return res; }
        float as_float() const { return to_float(_args[_index]); }
        operator float() const { return as_float(); }

        int as_int() const { return atoi(_args[_index].c_str()); }
        operator int() const { return as_int(); }

        int as_uint32() const { return (uint32_t)atoi(_args[_index].c_str()); }
        operator uint32_t() const { return as_uint32(); }

        acre::vector3<float> as_vector() const {
            std::vector<std::string> t = acre::split(_args[_index], ';');
            return acre::vector3<float>(to_float(t[0]),
                to_float(t[1]),
                to_float(t[2]));
        }
        operator acre::vector3<float>() const { return as_vector(); }

    protected:
        const uint32_t                      _index;
        const std::vector<std::string> &    _args;
    };

    class arguments {
    public:
        arguments(const std::string & str) : _internal_index(0) {
            _args = acre::split(str, ',');
            for (size_t i = 0; i < _args.size(); i++) {
                _args[i] = trim(_args[i]);
            }
        }
        arguments(const char** argv, std::int32_t argc) : _internal_index(0) {
            for (std::int32_t i = 0; i < argc; i++) {
                std::string arg_string(argv[i]);
                if (arg_string.size() > 2 && arg_string.at(0) == '\"' && arg_string.at(arg_string.size() - 1) == '\"') {
                    arg_string = arg_string.substr(1, arg_string.size() - 2);  // callExtensionArgs will add quotes to strings
                } 
                std::vector<std::string> arg_split = acre::split(arg_string, ',');
                _args.insert(_args.end(), arg_split.begin(), arg_split.end());
            }
        }

        size_t size() const { return _args.size(); }

        const argument_accessor operator[] (int index) const { return argument_accessor(index, _args); }
        //argument_accessor operator[] (int index) const { return argument_accessor(index, _args); }


        float to_float(const std::string & val) const { float res = 0.0f; std::istringstream iss(val); iss >> res; return res; }

        const std::string & as_string() { return _args[_internal_index++]; }
        float as_float() { return to_float(_args[_internal_index++]); }
        int as_int() { return atoi(_args[_internal_index++].c_str()); }
        int as_uint32() { return (uint32_t)atoi(_args[_internal_index++].c_str()); }

        const std::string & as_string(uint32_t _index) const { return _args[_index]; }
        float as_float(uint32_t _index) const { return to_float(_args[_index]); }
        int as_int(uint32_t _index) const { return atoi(_args[_index].c_str()); }
        int as_uint32(uint32_t _index) const { return (uint32_t)atoi(_args[_index].c_str()); }

        


        acre::vector3<float> as_vector(uint32_t _index) const {
            std::vector<std::string> t = acre::split(_args[_index], ';');
            return acre::vector3<float>(to_float(t[0]), to_float(t[1]), to_float(t[2]));
        }

        const std::string to_string() const { // For Debugging
            std::stringstream ss;
            for (std::uint32_t i = 0U; i < _args.size(); i++) {
                ss << _args[i] << ",";
            }
            return ss.str();
        }

        std::string create(const std::string & command) const {
            std::stringstream ss;
            ss << command << ":";

            for (auto & v : _args) {
                ss << v << ",";
            }

            // Remove the trailing ,
            std::string result = ss.str();
            result.erase(result.length());

            return result;
        }
        static std::string create(const std::string & command, const arguments & args) {
            return args.create(command);
        }
        

    protected:
        std::vector<std::string> _args;
        uint32_t                 _internal_index;
    };
}
