#!/bin/bash

DESC_inih="Generic-purpose lossless compression algorithm by Google"

# version of your package
VERSION_inih=58

LINK_libinih=libinih.dylib

# dependencies of this recipe
DEPS_inih=()

# url of the package
URL_inih=https://github.com/benhoyt/inih/archive/refs/tags/r${VERSION_inih}.tar.gz

# md5 of the package
MD5_inih=5c9725320ad2c79e0b1f76568bd0ff24

# default build path
BUILD_inih=$BUILD_PATH/inih/$(get_directory $URL_inih)

# default recipe path
RECIPE_inih=$RECIPES_PATH/inih

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_inih() {
    cd $BUILD_inih

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_inih() {
    if [ ${STAGE_PATH}/lib/${LINK_libinihdec} -nt $BUILD_inih/.patched ]; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_inih() {
    try rsync -a $BUILD_inih/ $BUILD_PATH/inih/build-$ARCH/
    try cd $BUILD_PATH/inih/build-$ARCH

    push_env

    try $MESON -Dcpp_std=c++11

    try meson compile -C build --verbose
    try meson install -C build

    pop_env
}

# function called after all the compile have been done
function postbuild_inih() {
    verify_binary lib/$LINK_libinih
}

# function to append information to config file
function add_config_info_inih() {
    append_to_config_file "# inih-${VERSION_inih}: ${DESC_inih}"
    append_to_config_file "export VERSION_inih=${VERSION_inih}"
    append_to_config_file "export LINK_libinih=${LINK_libinih}"
}
