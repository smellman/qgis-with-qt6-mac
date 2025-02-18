#!/bin/bash

DESC_poppler="PDF rendering library (based on the xpdf-3.0 code base)"

# version of your package
VERSION_poppler=25.01.0

LINK_poppler=libpoppler.145.dylib
LINK_poppler_cpp=libpoppler-cpp.2.dylib
# TODO: check if this is correct
LINK_poppler_qt6=libpoppler-qt6.1.dylib

# dependencies of this recipe
DEPS_poppler=(
    fontconfig
    freetype
    gettext
    jpeg
    png
    libtiff
    little_cms2
    openjpeg
    libcurl
    pkg_config
    boost
)

# url of the package
URL_poppler=https://poppler.freedesktop.org/poppler-${VERSION_poppler}.tar.xz

# md5 of the package
MD5_poppler=b4f4b132a316d844c97cfc2f4514f832

# default build path
BUILD_poppler=$BUILD_PATH/poppler/$(get_directory $URL_poppler)

# default recipe path
RECIPE_poppler=$RECIPES_PATH/poppler

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_poppler() {
    cd $BUILD_poppler

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_poppler() {
    # If lib is newer than the sourcecode skip build
    if [ ${STAGE_PATH}/lib/${LINK_poppler} -nt $BUILD_poppler/.patched ]; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_poppler() {
    try mkdir -p $BUILD_PATH/poppler/build-$ARCH
    try cd $BUILD_PATH/poppler/build-$ARCH
    push_env

    # ENABLE_UNSTABLE_API_ABI_HEADERS=ON is equivalent to enable-xpdf-headers

    try ${CMAKE} \
        -DBUILD_GTK_TESTS=OFF \
        -DENABLE_CMS=lcms2 \
        -DENABLE_GLIB=OFF \
        -DENABLE_QT5=OFF \
        -DENABLE_QT6=ON \
        -DENABLE_UNSTABLE_API_ABI_HEADERS=ON \
        -DWITH_GObjectIntrospection=ON \
        -DCMAKE_CXX_FLAGS="-std=c++11 -isystem ${STAGE_PATH}/headers" \
        $BUILD_poppler

    check_file_configuration CMakeCache.txt

    try $NINJA
    try $NINJA install

    install_name_tool -id $STAGE_PATH/lib/$LINK_poppler $STAGE_PATH/lib/$LINK_poppler
    install_name_tool -id $STAGE_PATH/lib/$LINK_poppler_cpp $STAGE_PATH/lib/$LINK_poppler_cpp
    install_name_tool -id $STAGE_PATH/lib/$LINK_poppler_qt6 $STAGE_PATH/lib/$LINK_poppler_qt6

    install_name_tool -change $BUILD_PATH/poppler/build-$ARCH/$LINK_poppler $STAGE_PATH/lib/$LINK_poppler $STAGE_PATH/lib/$LINK_poppler
    install_name_tool -change $BUILD_PATH/poppler/build-$ARCH/$LINK_poppler $STAGE_PATH/lib/$LINK_poppler $STAGE_PATH/lib/$LINK_poppler_cpp
    install_name_tool -change $BUILD_PATH/poppler/build-$ARCH/$LINK_poppler $STAGE_PATH/lib/$LINK_poppler $STAGE_PATH/lib/$LINK_poppler_qt6

    pop_env
}

# function called after all the compile have been done
function postbuild_poppler() {
    verify_binary lib/${LINK_poppler}
    verify_binary lib/${LINK_poppler_cpp}
    verify_binary lib/${LINK_poppler_qt6}
}

# function to append information to config file
function add_config_info_poppler() {
    append_to_config_file "# poppler-${VERSION_poppler}: ${DESC_poppler}"
    append_to_config_file "export VERSION_poppler=${VERSION_poppler}"
    append_to_config_file "export LINK_poppler=${LINK_poppler}"
    append_to_config_file "export LINK_poppler_cpp=${LINK_poppler_cpp}"
    append_to_config_file "export LINK_poppler_qt6=${LINK_poppler_qt6}"
}
