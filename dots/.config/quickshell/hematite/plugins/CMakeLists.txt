cmake_minimum_required(VERSION 3.19)
project(hematite-plugins LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Quick ShaderTools)

set(QT_QML_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/qml")
qt_standard_project_setup(REQUIRES 6.5)

add_subdirectory(Blobs)
