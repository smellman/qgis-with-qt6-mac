#!/bin/bash

DESC_qtkeychain="Platform-independent Qt API for storing passwords securely"

# version of your package
VERSION_qtkeychain=0.14.3

LINK_qtkeychain=libqt6keychain.1.dylib

# dependencies of this recipe
DEPS_qtkeychain=()

# url of the package
URL_qtkeychain=https://github.com/frankosterfeld/qtkeychain/archive/refs/tags/${VERSION_qtkeychain}.tar.gz

# md5 of the package
MD5_qtkeychain=269fe04b6d9d3a22841695a25f1d70e6

# default build path
BUILD_qtkeychain=$BUILD_PATH/qtkeychain/$(get_directory $URL_qtkeychain)

# default recipe path
RECIPE_qtkeychain=$RECIPES_PATH/qtkeychain

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_qtkeychain() {
    cd $BUILD_qtkeychain

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_qtkeychain() {
    # If lib is newer than the sourcecode skip build
    if [ ${STAGE_PATH}/lib/$LINK_qtkeychain -nt $BUILD_qtkeychain/.patched ]; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_qtkeychain() {
    try mkdir -p $BUILD_PATH/qtkeychain/build-$ARCH
    try cd $BUILD_PATH/qtkeychain/build-$ARCH
    push_env

    try ${CMAKE} \
        -DQTKEYCHAIN_STATIC=OFF \
        -DBUILD_WITH_QT6=ON \
        -DBUILD_WITH_QT5=OFF \
        -DBUILD_TEST_APPLICATION=ON \
        -DBUILD_TRANSLATIONS=OFF \
        $BUILD_qtkeychain

    check_file_configuration CMakeCache.txt

    try $NINJA
    try $NINJA install

    try install_name_tool -id $STAGE_PATH/lib/$LINK_qtkeychain $STAGE_PATH/lib/$LINK_qtkeychain
    try install_name_tool -change $BUILD_PATH/qtkeychain/build-$ARCH/$LINK_qtkeychain $STAGE_PATH/lib/$LINK_qtkeychain $STAGE_PATH/lib/$LINK_qtkeychain

    pop_env
}

# function called after all the compile have been done
function postbuild_qtkeychain() {
    verify_binary lib/$LINK_qtkeychain
}

# function to append information to config file
function add_config_info_qtkeychain() {
    append_to_config_file "# qtkeychain-${VERSION_qtkeychain}: ${DESC_qtkeychain}"
    append_to_config_file "export VERSION_qtkeychain=${VERSION_qtkeychain}"
    append_to_config_file "export LINK_qtkeychain=${LINK_qtkeychain}"
}
