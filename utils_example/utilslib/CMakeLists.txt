cmake_minimum_required(VERSION 3.7 FATAL_ERROR)
project(math_library VERSION 1.0.0 LANGUAGES C)
add_library(utils SHARED math.c math.def strings.c strings.def)

set_target_properties(utils PROPERTIES
    PUBLIC_HEADER utils.h
    VERSION ${PROJECT_VERSION}
    SOVERSION 1
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
    OUTPUT_NAME "utils"
    XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "Hex_Identity_ID_Goes_Here"
)
