cmake_minimum_required(VERSION 3.20)
project(consumer LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 告诉 find_package 去哪里找 <prefix>/lib/cmake/hellocmake/hellocmakeConfig.cmake 
# 也可以在配置阶段通过-DCMAKE_PREFIX_PATH="D:/workspace/hellocmake/producer/build/install"指定
#list(APPEND CMAKE_PREFIX_PATH "D:/workspace/hellocmake/producer/build/install")

find_package(hellocmake CONFIG REQUIRED)

add_executable(app main.cpp)
target_link_libraries(app PRIVATE hellocmake)#使用find_package后不再需要指定头文件和库路径


