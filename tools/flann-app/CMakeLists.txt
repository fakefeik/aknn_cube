cmake_minimum_required (VERSION 3.1)
set (CMAKE_CXX_STANDARD 11)
project(flann-app)

add_executable(flann-app main.cpp)

target_link_libraries(flann-app hdf5)
