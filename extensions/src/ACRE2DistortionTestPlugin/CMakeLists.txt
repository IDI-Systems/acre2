cmake_minimum_required (VERSION 3.10)

set(ACRE_NAME "ACRE2DistortionTestPlugin")

acre_set_build_output()
acre_set_linker_options()

enable_language(ASM_MASM)
file(GLOB_RECURSE SOURCES *.h *.hpp *.c *.cpp *.asm inc/*)

include_directories(inc)

add_library( ${ACRE_NAME} MODULE ${SOURCES} ${GLOBAL_SOURCES})
target_link_libraries(${ACRE_NAME} ACRE2Core ACRE2Shared x3daudio)
set_target_properties(${ACRE_NAME} PROPERTIES FOLDER Extras LINK_FLAGS -SAFESEH:NO)
