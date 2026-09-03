cmake_minimum_required(VERSION 3.20)
project(AnimFix VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W3 /permissive-")

set(SOURCES
    AISGG/dllmain.cpp
    AISGG/AnimFixSystem.cpp
    AISGG/GameHook.cpp
    AISGG/pch.cpp
)

set(HEADERS
    AISGG/framework.h
    AISGG/pch.h
    AISGG/AnimFixSystem.h
    AISGG/GameHook.h
)

add_library(AnimFix SHARED ${SOURCES} ${HEADERS})
set_target_properties(AnimFix PROPERTIES OUTPUT_NAME "AnimFix" SUFFIX ".asi")

target_precompile_headers(AnimFix PRIVATE AISGG/pch.h)

target_compile_definitions(AnimFix PRIVATE
    _WINDOWS
    _USRDLL
    AnimFix_EXPORTS
)

set_target_properties(AnimFix PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin/$<CONFIG>"
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin/$<CONFIG>"
)
