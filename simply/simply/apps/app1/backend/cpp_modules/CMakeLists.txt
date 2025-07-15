cmake_minimum_required(VERSION 3.10)
project(cpp_calculator)

# Find Python and pybind11
find_package(PythonLibs REQUIRED)
find_package(pybind11 REQUIRED)

# Add the C++ module
pybind11_add_module(cpp_calculator calculator.cpp)
