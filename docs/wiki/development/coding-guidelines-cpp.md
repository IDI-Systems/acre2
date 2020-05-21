---
title: Coding Guidelines (C++)
---

_Disclaimer: Not all ACRE2's code complies with the below coding guidelines, we are working towards improving as much as we can!_

Majority of the [SQF Code Style Guidelines](coding-guidelines-sqf#code-style) also apply to C++ code! Differences and C++-specific styles are noted on this page.

## Code Indentation

All indents should be four normal spaces.

## Variable Names

All variable names should follow `snake_formatting`, with all letters in lowercase. Variable names should not start with a number.

Examples:

```c++
uint32_t my_number = 1;
std::string test_string = "abc";
```

### Arguments

Arguments to any function, method, constructor, etc should be suffixed with a single `_`.

Examples:

```c++
void some_function(uint32_t arg_);

class test_class {
public:
    test_class(std::string string_);
};
```

## Control Braces

Opening braces should always be on the same line as their block identifier (such as `if`, `else`, `for`, etc). All closing braces should be on their own line.

Examples:

```c++
if (test) {
    // do something
}
else {
    // something else
}

for (auto it : some_list_) {
    // blah blah
}

void some_function() {
    // implementation
}
```

## Namespaces

All namespaces should be descendants of `acre::`. Namespaces that are meant to hold internal or implementation specific code not exposed readily to end users should be prefixed with two (2) underscores `__`.

```c++
namespace acre {
    namespace __my_helpers {
        // internal helper functions
    }
    namespace my_functionality {
        // exposed namespace that might implement above helpers
    }
}
```

## Classes

All classes should strictly maintain separation between declarations and definitions. There should always be a corresponding `.cpp` file for every `.hpp` file that defines a class. Furthermore it is recommended, but not required that all classes be implemented in their own declaration and definition files. Developers should make judgement calls on when they feel a class should be split out into its own files.

### Protected/Private Members/Methods

All protected/private members and methods should be prefixed with a single `_` to provide easy identification that the value is not in the public scope.

Example:

```c++
//test_class.hpp
class test_class {
public:
    test_class(uint32_t init_);
protected:
    uint32_t _val;
};

//test_class.cpp
test_class::test_class(uint32_t init_) : _val(init_) {};
```

## Templates

All templates should use capital letters or words that start with capital letters that describe what they are are templating.

Example:

```c++
template<typename T, size_t Size>
class stack_array {
public:
    T array_holder[Size];
};
```
