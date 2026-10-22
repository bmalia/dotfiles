qt_add_qml_module(blobs
    URI Hematite.Blobs
    VERSION 1.0
    SOURCES
        blobgroup.cpp blobgroup.hpp
        blobshape.cpp blobshape.hpp
        blobrect.cpp blobrect.hpp
        blobinvertedrect.cpp blobinvertedrect.hpp
        blobmaterial.cpp blobmaterial.hpp
)

target_link_libraries(blobs PRIVATE Qt6::Quick)

qt_add_shaders(blobs "blob_shaders"
    BATCHABLE OPTIMIZED NOHLSL NOMSL
    GLSL "300es,330"
    PREFIX "/"
    FILES
        shaders/blob.frag
        shaders/blob.vert
)
