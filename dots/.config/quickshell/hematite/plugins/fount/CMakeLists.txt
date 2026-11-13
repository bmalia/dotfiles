qt_add_qml_module(fount
    URI Hematite.Fount
    VERSION 1.0
    SOURCES
        bincode.cpp bincode.hpp
        fountresultmodel.cpp fountresultmodel.hpp
        fountclient.cpp fountclient.hpp
)

target_link_libraries(fount PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::Network
)
