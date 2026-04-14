set(CMAKE_C_STANDARD 23)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_RELEASE ON)
set(CMAKE_COLOR_DIAGNOSTICS ON)
set(CMAKE_COLOR_MAKEFILE ON)

set(BUILD_PATH ${CMAKE_SOURCE_DIR}/godot/addons/gd_audio_analyzer)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${BUILD_PATH}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${BUILD_PATH}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${BUILD_PATH}")

# Prefer vcpkg's FFTW3 config package. If unavailable, fall back to a system/Homebrew install.
find_package(FFTW3 CONFIG QUIET)
if(TARGET FFTW3::fftw3)
    set(FFTW_TARGET FFTW3::fftw3)
else()
    find_path(FFTW_INCLUDE_DIR NAMES fftw3.h)
    find_library(FFTW_LIBRARY NAMES fftw3 fftw)

    if(NOT FFTW_INCLUDE_DIR OR NOT FFTW_LIBRARY)
        message(FATAL_ERROR "FFTW not found. Install via vcpkg (fftw3) or Homebrew (fftw).")
    endif()

    add_library(FFTW::fftw UNKNOWN IMPORTED)
    set_target_properties(FFTW::fftw PROPERTIES
        IMPORTED_LOCATION "${FFTW_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${FFTW_INCLUDE_DIR}"
    )
    set(FFTW_TARGET FFTW::fftw)
endif()

find_package(portaudio CONFIG QUIET)
if(TARGET portaudio)
    set(PORTAUDIO_TARGET portaudio)
elseif(TARGET PortAudio::PortAudio)
    set(PORTAUDIO_TARGET PortAudio::PortAudio)
else()
    find_path(PORTAUDIO_INCLUDE_DIR NAMES portaudio.h)
    find_library(PORTAUDIO_LIBRARY NAMES portaudio portaudio_static)

    if(NOT PORTAUDIO_INCLUDE_DIR OR NOT PORTAUDIO_LIBRARY)
        message(FATAL_ERROR "PortAudio not found. Install via vcpkg (portaudio) or Homebrew (portaudio).")
    endif()

    add_library(PortAudio::PortAudio UNKNOWN IMPORTED)
    set_target_properties(PortAudio::PortAudio PROPERTIES
        IMPORTED_LOCATION "${PORTAUDIO_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${PORTAUDIO_INCLUDE_DIR}"
    )
    set(PORTAUDIO_TARGET PortAudio::PortAudio)
endif()

file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/src/*.c*")
file(GLOB_RECURSE HEADERS CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/src/*.h*")

add_library(${PROJECT_NAME} SHARED ${SOURCES} ${HEADERS})

target_link_libraries(${PROJECT_NAME} PRIVATE godot-cpp)
target_link_libraries(${PROJECT_NAME} PRIVATE ${FFTW_TARGET})
target_link_libraries(${PROJECT_NAME} PRIVATE ${PORTAUDIO_TARGET})
target_include_directories(${PROJECT_NAME}
    PUBLIC
    
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

# Install library, extension file, and support files in ${CMAKE_INSTALL_PREFIX}/${PROJECT_NAME}
message( STATUS "Install directory: ${INSTALL_DIR}")

# install( TARGETS ${PROJECT_NAME}
#     LIBRARY
#         DESTINATION ${INSTALL_DIR}/
#     RUNTIME
#         DESTINATION ${INSTALL_DIR}/
# )

# install(
#     DIRECTORY ${CMAKE_BINARY_DIR}/code/Debug
#     DESTINATION ${INSTALL_DIR}
# )
