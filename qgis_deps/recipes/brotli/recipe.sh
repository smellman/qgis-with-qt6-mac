#!/bin/bash

DESC_brotli="Generic-purpose lossless compression algorithm by Google"

# version of your package
VERSION_brotli_major=1
VERSION_brotli=${VERSION_brotli_major}.1.0

LINK_libbrotlicommon=libbrotlicommon.${VERSION_brotli_major}.dylib
LINK_libbrotlidec=libbrotlidec.${VERSION_brotli_major}.dylib
LINK_libbrotlienc=libbrotlienc.${VERSION_brotli_major}.dylib

# dependencies of this recipe
DEPS_brotli=()

# url of the package
URL_brotli=https://github.com/google/brotli/archive/refs/tags/v${VERSION_brotli}.tar.gz

# md5 of the package
MD5_brotli=3a6a3dba82a3604792d3cb0bd41bca60

# default build path
BUILD_brotli=$BUILD_PATH/brotli/$(get_directory $URL_brotli)

# default recipe path
RECIPE_brotli=$RECIPES_PATH/brotli

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_brotli() {
    cd $BUILD_brotli

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_brotli() {
    if [ ${STAGE_PATH}/lib/${LINK_libbrotlidec} -nt $BUILD_brotli/.patched ]; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_brotli() {
    try mkdir -p $BUILD_PATH/brotli/build-$ARCH
    try cd $BUILD_PATH/brotli/build-$ARCH

    push_env

    try $CMAKE \
        $BUILD_brotli

    check_file_configuration CMakeCache.txt

    try $NINJA
    try $NINJA install

    try install_name_tool -id $STAGE_PATH/lib/$LINK_libbrotlicommon $STAGE_PATH/lib/$LINK_libbrotlicommon
    try install_name_tool -change $BUILD_PATH/brotli/build-$ARCH/$LINK_libbrotlidec $STAGE_PATH/lib/$LINK_libbrotlidec $STAGE_PATH/lib/$LINK_libbrotlicommon
    try install_name_tool -change $BUILD_PATH/brotli/build-$ARCH/$LINK_libbrotlicommon $STAGE_PATH/lib/$LINK_libbrotlicommon $STAGE_PATH/lib/$LINK_libbrotlicommon

    try install_name_tool -id $STAGE_PATH/lib/$LINK_libbrotlidec $STAGE_PATH/lib/$LINK_libbrotlidec
    try install_name_tool -change $BUILD_PATH/brotli/build-$ARCH/$LINK_libbrotlidec $STAGE_PATH/lib/$LINK_libbrotlidec $STAGE_PATH/lib/$LINK_libbrotlidec
    try install_name_tool -change $BUILD_PATH/brotli/build-$ARCH/$LINK_libbrotlicommon $STAGE_PATH/lib/$LINK_libbrotlicommon $STAGE_PATH/lib/$LINK_libbrotlidec
    try fix_install_name lib/$LINK_libbrotlienc

    pop_env
}

# function called after all the compile have been done
function postbuild_brotli() {
    verify_binary lib/$LINK_libbrotlicommon
    verify_binary lib/$LINK_libbrotlidec
    verify_binary lib/$LINK_libbrotlienc
}

# function to append information to config file
function add_config_info_brotli() {
    append_to_config_file "# brotli-${VERSION_brotli}: ${DESC_brotli}"
    append_to_config_file "export VERSION_brotli=${VERSION_brotli}"
    append_to_config_file "export LINK_libbrotlicommon=${LINK_libbrotlicommon}"
    append_to_config_file "export LINK_libbrotlidec=${LINK_libbrotlidec}"
}
