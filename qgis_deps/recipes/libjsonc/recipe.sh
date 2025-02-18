#!/bin/bash

DESC_libjsonc="JSON parser for C"

# version of your package
VERSION_libjsonc=0.18
VERSION_libjsonc_release=20240915

LINK_libjsonc="libjson-c.5.dylib"

# dependencies of this recipe
DEPS_libjsonc=()

# url of the package
URL_libjsonc=https://github.com/json-c/json-c/archive/refs/tags/json-c-${VERSION_libjsonc}-${VERSION_libjsonc_release}.tar.gz

# md5 of the package
MD5_libjsonc=97f1a79151cae859983afbc46b40b92c

# default build path
BUILD_libjsonc=$BUILD_PATH/libjsonc/$(get_directory $URL_libjsonc)

# default recipe path
RECIPE_libjsonc=$RECIPES_PATH/libjsonc


# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libjsonc() {
    cd $BUILD_libjsonc

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

# function called before build_libjsonc
# set DO_BUILD=0 if you know that it does not require a rebuild
function shouldbuild_libjsonc() {
    # If lib is newer than the sourcecode skip build
    if [ "${STAGE_PATH}/lib/$LINK_libjsonc" -nt $BUILD_libjsonc/.patched ]; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_libjsonc() {
    try mkdir -p $BUILD_PATH/libjsonc/build-$ARCH
    try cd $BUILD_PATH/libjsonc/build-$ARCH

    push_env

    try $CMAKE $BUILD_libjsonc .
    check_file_configuration CMakeCache.txt

    try $NINJA
    try $NINJA install

    try fix_install_name $STAGE_PATH/lib/$LINK_libjsonc

    pop_env
}

# function called after all the compile have been done
function postbuild_libjsonc() {
    verify_binary lib/$LINK_libjsonc
}

# function to append information to config file
function add_config_info_libjsonc() {
    append_to_config_file "# libjsonc-${VERSION_libjsonc}: ${DESC_libjsonc}"
    append_to_config_file "export VERSION_libjsonc=${VERSION_libjsonc}"
}
