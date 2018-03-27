/* inih -- simple .INI file parser

inih is released under the New BSD license (see LICENSE.txt). Go to the project
home page for more info:

http://code.google.com/p/inih/

*/

#include <stdio.h>
#include <ctype.h>
#include <string.h>


#include "ini.h"

#if !INI_USE_STACK
#include <stdlib.h>
#endif

#define MAX_SECTION 50
#define MAX_NAME 50

/* Strip whitespace int8_ts off end of given string, in place. Return s. */
static int8_t* rstrip(int8_t* s)
{
    int8_t* p = s + strlen(s);
    while (p > s && isspace((uint8_t)(*--p)))
        *p = '\0';
    return s;
}

/* Return pointer to first non-whitespace int8_t in given string. */
static int8_t* lskip(const int8_t* s)
{
    while (*s && isspace((uint8_t)(*s)))
        s++;
    return (int8_t*)s;
}

/* Return pointer to first int8_t c or ';' comment in given string, or pointer to
   null at end of string if neither found. ';' must be prefixed by a whitespace
   int8_tacter to register as a comment. */
static int8_t* find_int8_t_or_comment(const int8_t* s, int8_t c)
{
    int32_t was_whitespace = 0;
    while (*s && *s != c && !(was_whitespace && *s == ';')) {
        was_whitespace = isspace((uint8_t)(*s));
        s++;
    }
    return (int8_t*)s;
}

/* See documentation in header file. */
int32_t ini_parse_file(FILE* file,
                   int32_t (*handler)(void*, const int8_t*, const int8_t*,
                                  const int8_t*),
                   void* user)
{
    /* Uses a fair bit of stack (use heap instead if you need to) */
#if INI_USE_STACK
    int8_t line[INI_MAX_LINE];
#else
    int8_t* line;
#endif
    int8_t section[MAX_SECTION] = "";
    int8_t prev_name[MAX_NAME] = "";

    int8_t* start;
    int8_t* end;
    int8_t* name;
    int8_t* value;
    int32_t lineno = 0;
    int32_t error = 0;

#if !INI_USE_STACK
    line = (int8_t*)malloc(INI_MAX_LINE);
    if (!line) {
        return -2;
    }
#endif

    /* Scan through file line by line */
    while (fgets(line, INI_MAX_LINE, file) != NULL) {
        lineno++;

        start = line;
#if INI_ALLOW_BOM
        if (lineno == 1 && (uint8_t)start[0] == 0xEF &&
                           (uint8_t)start[1] == 0xBB &&
                           (uint8_t)start[2] == 0xBF) {
            start += 3;
        }
#endif
        start = lskip(rstrip(start));

        if (*start == ';' || *start == '#') {
            /* Per Python ConfigParser, allow '#' comments at start of line */
        }
#if INI_ALLOW_MULTILINE
        else if (*prev_name && *start && start > line) {
            /* Non-black line with leading whitespace, treat as continuation
               of previous name's value (as per Python ConfigParser). */
            if (!handler(user, section, prev_name, start) && !error)
                error = lineno;
        }
#endif
        else if (*start == '[') {
            /* A "[section]" line */
            end = find_int8_t_or_comment(start + 1, ']');
            if (*end == ']') {
                *end = '\0';
                strncpy(section, start + 1, sizeof(section));
                *prev_name = '\0';
            }
            else if (!error) {
                /* No ']' found on section line */
                error = lineno;
            }
        }
        else if (*start && *start != ';') {
            /* Not a comment, must be a name[=:]value pair */
            end = find_int8_t_or_comment(start, '=');
            if (*end != '=') {
                end = find_int8_t_or_comment(start, ':');
            }
            if (*end == '=' || *end == ':') {
                *end = '\0';
                name = rstrip(start);
                value = lskip(end + 1);
                end = find_int8_t_or_comment(value, '\0');
                if (*end == ';')
                    *end = '\0';
                rstrip(value);

                /* Valid name[=:]value pair found, call handler */
                strncpy(prev_name, name, sizeof(prev_name));
                if (!handler(user, section, name, value) && !error)
                    error = lineno;
            }
            else if (!error) {
                /* No '=' or ':' found on name[=:]value line */
                error = lineno;
            }
        }

#if INI_STOP_ON_FIRST_ERROR
        if (error)
            break;
#endif
    }

#if !INI_USE_STACK
    free(line);
#endif

    return error;
}

/* See documentation in header file. */
int32_t ini_parse(const int8_t* filename,
              int32_t (*handler)(void*, const int8_t*, const int8_t*, const int8_t*),
              void* user)
{
    FILE* file;
    int32_t error;
    file = fopen(filename, "r");
    if (!file)
        return -1;
    error = ini_parse_file(file, handler, user);
    fclose(file);
    return error;
}
