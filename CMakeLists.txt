cmake_minimum_required(VERSION 3.27)
project(tinyaes)
enable_language(ASM)

set(CMAKE_CXX_STANDARD 20)

add_compile_options(-O3)

add_executable(aes128 aes128.c aes/aes128.s aes/aes256.s)
add_executable(aes256 aes256.c aes/aes128.s aes/aes256.s)
add_executable(ecbbench ecbbench.c aes/aes128.s aes/aes256.s)