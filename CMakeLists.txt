cmake_minimum_required(VERSION 3.27)
project(aeslib)
enable_language(ASM)

set(CMAKE_CXX_STANDARD 20)

add_executable(aes128 aes128.c aes/aes128.s)