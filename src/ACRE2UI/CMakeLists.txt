cmake_minimum_required (VERSION 3.0)

set(ACRE_NAME "ACRE2UI")

acre_set_build_output()
acre_set_linker_options()

file(GLOB_RECURSE SOURCES *.h *.hpp *.c *.cpp)
file(GLOB_RECURSE UI_SOURCES *.ui)

if(USE_64BIT_BUILD) 
	set(CMAKE_PREFIX_PATH "D:/Qt/5.2.1/msvc2012_64")
else()
	set(CMAKE_PREFIX_PATH "D:/Qt/5.2.1/msvc2012")
endif()
find_package(Qt5Widgets 5.2.1 EXACT REQUIRED)
find_package(Qt5Core 5.2.1 EXACT REQUIRED)
find_package(Qt5Gui 5.2.1 EXACT REQUIRED)

qt5_add_resources(QRC_SOURCES resources.qrc)
QT5_WRAP_UI(UIS_HDRS ${UI_SOURCES})

add_library( ${ACRE_NAME} STATIC ${QRC_SOURCES} ${UI_SOURCES} ${SOURCES})
target_link_libraries(${ACRE_NAME} ACRE2Core ACRE2Shared x3daudio Qt5::Widgets Qt5::Core Qt5::Gui)
set_target_properties(${ACRE_NAME} PROPERTIES FOLDER ACRE2)
set_target_properties(ACRE2UI PROPERTIES AUTOMOC ON)

ADD_CUSTOM_COMMAND(TARGET ${ACRE_NAME}
          PRE_BUILD
          COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/docs/acre_welcome.html ${PROJECT_SOURCE_DIR}/src/ACRE2UI/acre_welcome.html
)