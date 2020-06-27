cmake_minimum_required (VERSION 3.0)

set(ACRE_NAME "MumbleTest")

acre_set_build_output()
acre_set_linker_options()

enable_language(ASM_MASM)
file(GLOB_RECURSE SOURCES *.h *.hpp *.c *.cpp *.asm testPlugin/*)

include_directories(testPlugin)

add_library( ${ACRE_NAME} MODULE ${SOURCES} ${GLOBAL_SOURCES})
set_target_properties(${ACRE_NAME} PROPERTIES FOLDER Extras LINK_FLAGS -SAFESEH:NO)
