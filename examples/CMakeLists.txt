cmake_minimum_required(VERSION 3.13.4)

file(GLOB SOURCES ./*.c)

add_library(example1 ${SOURCES})

# llvmir_attach_bc_target(example1 bar)