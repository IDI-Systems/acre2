---
title: Coding Guidelines (SQF)
---

_Disclaimer: Not all ACRE2's code complies with the below coding guidelines, we are working towards improving as much as we can!_

## Naming Conventions

### Variable Names

#### Global Variable naming

Global variables used in a specific component only shall start with the ACRE prefix followed by the component, separated by underscores. Global variables shall not contain the `fnc_` prefix if the value is not callable code. In case where global variables are used in multiple modules, component may be omitted.

Example: `acre_component_myVariableName` or `acre_myVariableName`

_For ACRE this is done automatically through the usage of the GVAR macro family._

#### Private Variable naming

To make code as readable as possible, try to use self explanatory variable names and avoid using single character variable names.

Example: `_velocity` instead of `_v`

#### Function naming

Internal functions shall start with the ACRE prefix followed by the component, separated by underscores, as well as the `fnc_` prefix behind the component name. Public API functions should not have the component specified.

Example: `PREFIX_COMPONENT_fnc_functionName` or `PREFIX_fnc_functionName`

_For ACRE this is done automatically through the usage of the PREP macro._

### Files & Config

#### SQF File extension

Files containing sqf scripts will always have a file name extension of `.sqf`.

#### Header files

All header files will always have the file name extension of `.hpp`.

#### Own SQF File

All functions shall be put in their own .sqf file.

#### Config elements

Config files shall be split up into different header files, each with the name of the config and be included in the `config.cpp` of the component.

Example:

```cpp
#include "CfgAcreComponents.hpp"
```

And in `CfgAcreComponents.hpp`:

```cpp
class CfgAcreComponents {
    // Content
};
```


## Code Style

### Braces placement

Braces `{ }` which enclose a code block will have the first bracket placed behind the statement in case of `if`, `switch` statements or `while`, `waitUntil` and `for` loops. The second brace will be placed on the same column as the statement but on a separate line.

- Opening brace on the same line as keyword
- Closing brace in own line, same level of indentation as keyword

**Yes:**

```cpp
class Something: Or {
    class Other {
        foo = "bar";
    };
};
```

**No:**

```cpp
class Something : Or
{
    class Other
    {
        foo = "bar";
    };
};
```

**Also no:**

```cpp
class Something : Or {
    class Other {
        foo = "bar";
        };
    };
```

When using `if`/`else`, it is encouraged to put `else` on the same line as the closing brace to save space:

```cpp
if (alive player) then {
    player setDamage 1;
} else {
    hint ":(";
};
```

In cases where there are a lot of one-liner classes, it is allowed to use something like this to save space:

```cpp
class One {foo = 1;};
class Two {foo = 2;};
class Three {foo = 3;};
```

#### Reasoning

Putting the opening brace in it's own line wastes a lot of space, and keeping the closing brace on the same level as the keyword makes it easier to recognize what exactly the brace closes.

### Indentation

Ever new scope should be on a new indent. This will make the code easier to understand and read. Indentations consist of 4 spaces. Tabs are not allowed.

Good example:

```cpp
call {
    call {
        if (condition) then {
            code
        };
    };
};
```

Bad Example:

```cpp
call {
        call {
        if (condition) then {
            code
        };
        };
};
```

### Inline comments

Inline comments should use `//`. Usage of `/* */` is allowed for larger comment blocks.

Example:

```cpp
//// Comment   // < incorrect
// Comment     // < correct
/* Comment */  // < correct
```

### Comments in code

All code should be documented by comments that describe what is being done. This can be done through the function header and/or inline comments.

Comments within the code should be used when they are describing a complex and critical section of code or if the subject code does something a certain way because of a specific reason. Unnecessary comments in the code are not allowed.

Good:

```sqf
// find the object with the most damage inflicted
_highestObj = objNull;
_highestDmg = -1;
{
    if (damage _x > _highestDmg) then {
        _highestDmg = damage _x;
        _highestObj = _x;
    };
} foreach _units;
```

Good:

```sqf
// Check if the unit is an engineer
(_obj getvariable [QGVAR(engineerSkill), 0] >= 1);
```

Bad:

```sqf
// Get the engineer skill and check if it is above 1
(_obj getvariable [QGVAR(engineerSkill), 0] >= 1);
```

Bad:

```sqf
// Get the variable myValue from the object
_myValue = _obj getvariable [QGVAR(myValue), 0];
```

Bad:

```sqf
// Loop through all units to increase the myValue variable
{
    _x setvariable [QGVAR(myValue), (_x getvariable [QGVAR(myValue), 0]) + 1];
} forEach _units;
```

### Brackets around code

When making use of brackets `( )`, use as few as possible, unless doing so decreases readability of the code. Avoid statements such as:

```sqf
if (!(_value)) then { };
```

However the following is allowed:

```sqf
_value = (_array select 0) select 1;
```

Any conditions in statements should always be wrapped around brackets.
Example:

```sqf
if (!_value) then {};
if (_value) then {};
```


### Magic Numbers

There should be no magic numbers. Any magic number should be put in a define either on top of the .sqf file (below the header), or in the script_component.hpp file in the root directory of the component (recommended) in case it is used in multiple locations.

Magic numbers are any of the following:

- A constant numerical or text value used to identify a file format or protocol
- Distinctive unique values that are unlikely to be mistaken for other meanings
- Unique values with unexplained meaning or multiple occurrences which could (preferably) be replaced with named constants

[Source](http://en.wikipedia.org/wiki/Magic_number_%28programming%29)

## Code Standards

### Error testing

If a function returns error information, then that error information will be tested.

### Unreachable Code

There shall be no unreachable code.

### Function Parameters

Parameters of functions must be retrieved through the usage of the `param` or `params` commands. If the function is part of the public API, parameters must be checked on allowed data types and values through the usage of the `param` and `params` commands.

### Return Values

Functions and code blocks that specific a return a value must have a meaningful return value. If no meaningful return value, the function should return nil.

### Private Variables

All private variables shall make use of the `private` keyword on initialization. When declaring a private variable before initialization, usage of the private array syntax is allowed. All private variables must be either initialized using the private keyword, or declared using the private array syntax. Exceptions to this rule are variables obtained from an array. Note that this may only be down by making use of the `params` command family, as this ensures the variable is declared as private.

Good:

```sqf
private _myVariable = "hello world";
```

Good:

```sqf
_myArray params ["_elementOne", "_elementTwo"];
```

Bad:

```sqf
_elementOne = _myArray select 0;
_elementTwo = _myArray select 1;
```

### Lines of Code

Any one function shall contain no more than 250 lines of code, excluding the function header and any includes.

### `getVariable`

When using `getVariable`, there should either be a default value given in the statement or the return value should be checked for correct data type as well as return value. A default value may not be given after a nil check.

Bad:

```sqf
_return = obj getvariable "varName";
if (isnil "_return") then {_return = 0 };
```

Good:

```sqf
_return = obj getvariable ["varName", 0];
```

Good:

```sqf
_return = obj getvariable "varName";
if (isnil "_return") exitwith {};
```

### Global Variables

Global variables should not be used to pass along information from one function to another. Use arguments instead.

Bad:

```sqf
fnc_example = {
    hint GVAR(myVariable);
};
```

```sqf
GVAR(myVariable) = "hello my variable";
call fnc_example;
```

Good:

```sqf
fnc_example = {
   params ["_content"];
   hint _content;
};
```

```sqf
["hello my variable"] call fnc_example;
```

### Temporary Objects & Variables

Unnecessary temporary objects or variables should be avoided.

### Commented out Code

Code that is not used (commented out) shall be deleted.

### Logging

Functions should whenever possible and logical, make use of logging functionality through the logging and debugging macros from CBA and ACRE.

### Constant Private Variables

Constant private variables that are used more as once should be put in a #define.

### Code used more than once

Any piece of code that could/is used more than once, should be put in a function and its separate `.sqf` file, unless this code is less as 5 lines and used only in a per frame handler.


## Design considerations

### Readability vs Performance

This is a large open source project that will get many different maintainers in it's lifespan. When writing code, keep in mind that other developers also need to be able to understand your code. Balancing readability and performance of code is a non black and white subject. The rule of thumb is:

* When improving performance of code that sacrifices readability (or vice-versa), first see if the design of the implementation is done in the best possible way.
* Document that change with the reasoning in the code.

### Scheduled vs Unscheduled

Avoid the usage of scheduled space as much as possible and stay in unscheduled. This is to provide a smooth experience to the user by guaranteeing code to run when we want it. See Performance considerations, Spawn & ExecVm for more information.

This also helps avoid various bugs as a result of unguaranteed execution sequences when running multiple scripts.

### Hashes

When a key value pair is required, make use of the Hash implementation.

Hashes are a variable type that store key value pairs. They are not implemented natively in SQF, so there are a number of macros and functions for their usage in ACRE2. If you are unfamiliar with the idea, they are similar in function to `setVariable`/`getVariable` but do not require an object to use.

The following example is a simple usage using our macros which will be explained further below.

```sqf
_hash = HASHCREATE;
HASH_SET(_hash, "key", "value");
if (HASH_HASKEY(_hash, "key")) then {
    player sideChat format ["val: %1", HASH_GET(_hash, "key"); // will print out "val: value"
};
HASH_REM(_hash, "key");
if (HASH_HASKEY(_hash, "key")) then {
    // this will never execute because we removed the hash key/val pair "key"
};
```

A description of the above macros is below.

| Macro  |  Use |
| -------|---------|
|`HASHCREATE` | Creates an empty hash.|
|`HASH_SET(hash,key,val)` | Sets the hash key to that value, a key can be anything, even objects. |
|`HASH_GET(hash,key)` | Returns the value of that key (or nil if it doesn't exist). |
|`HASH_HASKEY(hash,key)` | Returns true/false if that key exists in the hash. |
|`HASH_REM(hash,key)` | Removes that hash key.|

#### Hashlists

A hashlist is an extension of a hash. It is a list of hashes! The reason for having this special type of storage container rather than using a normal array is that an array of normal hashes that are are similar will duplicate a large amount of data in their storage of keys. A hashlist on the other hand uses a common list of keys and an array of unique value containers. The following will demonstrate it's usage.

```sqf
_defaultKeys = ["key1","key2","key3"];
// create a new hashlist using the above keys as default
_hashList = HASHLIST_CREATELIST(_defaultKeys);

//lets get a blank hash template out of this hashlist
_hash = HASHLIST_CREATEHASH(_hashList);

//_hash is now a standard hash...
HASH_SET(_hash, "key1", "1");

//to store it to the list we need to push it to the list
HASHLIST_PUSH(_hashList, _hash);

//now lets get it out and store it in something else for fun
//it was pushed to an empty list, so it's index is 0
_anotherHash = HASHLIST_SELECT(_hashList, 0);

// this should print "val: 1"
player sideChat format["val: %1", HASH_GET(_anotherHash, "key1")];

//Say we need to add a new key to the hashlist
//that we didn't initialize it with? We can simply
//set a new key using the standard HASH_SET macro
HASH_SET(_anotherHash, "anotherKey", "another value");
```

As you can see above working with hashlists are fairly simple, a more in depth explanation of the macros is below.

| Macro  |  Use |
| -------|---------|
|`HASHLIST_CREATELIST(keys)` | Creates a new hashlist with the default keys, pass [] for no default keys. |
|`HASHLIST_CREATEHASH(hashlist)` | Returns a blank hash template from a hashlist. |
|`HASHLIST_PUSH(hashList,hash)` | Pushes a new hash onto the end of the list. |
|`HASHLIST_SELECT(hashlist,index)` | Returns the hash at that index in the list. |
|`HASHLIST_SET(hashlist,index,hash)` | Sets a specific index to that hash. |

##### A note on pass by reference and hashes


Hashes and hashlists are implemented with SQF arrays, and as such they are passed by reference to other functions. Remember to make copies (using the + operator) if you intend for the hash or hashlist to be modified with out the need for changing the original value.


## Performance Considerations

### Adding Elements to Arrays

When adding new elements to an array, `pushBack` shall be used instead of the binary addition or set. When adding multiple elements to an array `append` may be used instead of `pushBack`.

Good:

```sqf
_a pushBack _value;
```

Also good:

```sqf
_a append [1,2,3];
```

Bad:

```sqf
_a set [ count _a, _value];
_a = a + _[value];
```

When adding an new element to a dynamic location in an array or when the index is pre-calculated, `set` may be used.

When adding multiple elements to an array, the binary addition may be used for the entire addition.

### `createVehicle`

`createVehicle` array shall be used instead of `createVehicle`.

### Unscheduled vs Scheduled

All code that has a visible effect for the user or requires time specific guaranteed execution shall be written in unscheduled space.

### Avoid `spawn` & `execVM`

`execVM` and `spawn` are to be avoided wherever possible.

### Empty Arrays

When checking if an array is empty, `isEqualTo` shall be used.

### `for` Loops

```sqf
for "_y" from # to # step # do { ... }
```

shall be used instead of

```sqf
for [{ ... },{ ... },{ ... }] do { ... };
```

whenever possible.

### `while` Loops

`while` is only allowed when used to perform a unknown finite amount of steps with unknown or variable increments. Infinite `while` loops are not allowed.

Good:

```sqf
_original = _obj getvariable [QGVAR(value), 0];
while {_original < _weaponThreshold} do {
    _original = [_original, _weaponClass] call FUNC(getNewValue);
}
```

Bad:

```sqf
while {true} do {
    // anything
};
```

### `waitUntil`

The `waitUntil` command shall not be used. Instead, make use of a per-frame handler:

```sqf
[{
    params ["_args", "_id"];
    _args params ["_unit"];

    if (_unit getvariable [QGVAR(myVariable), false]) exitwith {
        [_id] call CBA_fnc_removePerFrameHandler;

        // Execute any code
    };
}, [_unit], 0] call CBA_fnc_addPerFrameHandler;
```
