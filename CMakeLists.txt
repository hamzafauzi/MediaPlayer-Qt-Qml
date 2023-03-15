cmake_minimum_required(VERSION 3.16)

project(MediaPlayer VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Quick QuickControls2 Multimedia)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick QuickControls2 Multimedia)

set(PROJECT_SOURCES
    main.cpp
    qml.qrc
)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(MediaPlayer
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
    )
else()
    if(ANDROID)
        add_library(MediaPlayer SHARED
            ${PROJECT_SOURCES}
        )
    else()
        add_executable(MediaPlayer
          ${PROJECT_SOURCES}
        )
    endif()
endif()

if(QT_VERSION_MAJOR EQUAL 6)
    set(resource_files
        "main_qt6.qml"
    )
else()
    set(resource_files
        "main.qml"
    )
endif()


target_link_libraries(MediaPlayer PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Quick
    Qt${QT_VERSION_MAJOR}::Multimedia
)

if(QT_VERSION_MAJOR EQUAL 6)
    qt_import_qml_plugins(MediaPlayer)
    qt_finalize_executable(MediaPlayer)
endif()
