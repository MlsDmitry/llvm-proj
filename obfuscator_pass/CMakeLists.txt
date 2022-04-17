llvm_map_components_to_libnames(llvm_libs support core irreader)

file(GLOB SOURCES "src/*.c" "src/*.cpp")
file(GLOB HEADERS "src/*.h" "src/*.hpp")

add_library(obfuscator SHARED
    ${SOURCES}
)

target_include_directories(obfuscator PRIVATE "${HEADERS}")
target_link_libraries(obfuscator ${llvm_libs})