cmake_minimum_required(VERSION 3.30)

include(FetchContent)
FetchContent_Declare(
    godot-cpp
    GIT_REPOSITORY  https://github.com/godotengine/godot-cpp.git
    GIT_TAG         4.5
    GIT_SHALLOW     TRUE
)
FetchContent_MakeAvailable(godot-cpp)

set(PROJECT_NAME gd_audio_analyzer)

project(${PROJECT_NAME} LANGUAGES C CXX)

include(${CMAKE_SOURCE_DIR}/vcpkg/scripts/buildsystems/vcpkg.cmake)

set( CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/godot/addons/${PROJECT_NAME}")

set( INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/" )

add_subdirectory(code)

# add_subdirectory(templates)
