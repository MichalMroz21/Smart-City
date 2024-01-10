cmake_minimum_required(VERSION 3.16)

macro(add_files file file_collection)

    file (RELATIVE_PATH _relPath "${PROJECT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}")

    if (_relPath)
        list (APPEND ${file_collection} "${_relPath}/${file}")
    else()
        list (APPEND ${file_collection} "${file}")
    endif()

    if (_relPath)
        set (${file_collection} ${${file_collection}} PARENT_SCOPE)
    endif()

endmacro()

project(SmartCity VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 REQUIRED COMPONENTS Quick Sql Concurrent Location)

qt_standard_project_setup()
qt_policy(SET QTP0001 NEW) #use new policy (old is deprecated)

qt_add_executable(appSmartCity)

add_subdirectory(src)
add_subdirectory(include)
add_subdirectory(src_gui)
add_subdirectory(assets)

qt_add_qml_module(appSmartCity
    URI SmartCity
    VERSION 1.0
    RESOURCE_PREFIX "/"

    QML_FILES ${QML_FILES}
    RESOURCES ${RESOURCES}
    SOURCES src_gui/path.h src_gui/path.cpp
    SOURCES src_gui/place.h src_gui/place.cpp
)

#CMakeConfig.hpp - constants from cmake for the entire project to use
add_definitions(-DROOT_PATH_CMAKE=${CMAKE_CURRENT_SOURCE_DIR})

target_include_directories(appSmartCity PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(appSmartCity
    PRIVATE Qt6::Quick
    PRIVATE Qt${QT_VERSION_MAJOR}::Sql
    PRIVATE Qt${QT_VERSION_MAJOR}::Concurrent
    PRIVATE Qt6::Location
)

set_target_properties(appSmartCity PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appSmartCity
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

install(TARGETS appSmartCity
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
