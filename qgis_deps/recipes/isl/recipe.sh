#!/bin/bash

DESC_isl="Generic-purpose lossless compression algorithm by Google"

# version of your package
VERSION_isl=0.27

LINK_libisl=libisl.23.dylib

# dependencies of this recipe
DEPS_isl=(gmp python)

# url of the package
URL_isl=https://libisl.sourceforge.io/isl-${VERSION_isl}.tar.xz

# md5 of the package
MD5_isl=11ee9d335b227ea2e8579c4ba6e56138

# default build path
BUILD_isl=$BUILD_PATH/isl/$(get_directory $URL_isl)

# default recipe path
RECIPE_isl=$RECIPES_PATH/isl

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_isl() {
    cd $BUILD_isl

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_isl() {
    if [ ${STAGE_PATH}/lib/${LINK_libisldec} -nt $BUILD_isl/.patched ]; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_isl() {
    try rsync -a $BUILD_isl/ $BUILD_PATH/isl/build-$ARCH/
    try cd $BUILD_PATH/isl/build-$ARCH

    push_env

    try ${CONFIGURE} --disable-dependency-tracking \
        --prefix="${STAGE_PATH}" \
        --libdir="${STAGE_PATH}/lib" \
        --with-gmp-prefix="${STAGE_PATH}" \
        --with-gmp=system \
        --disable-silent-rules

    try $MAKESMP
    try $MAKESMP install

    pop_env
}

# function called after all the compile have been done
function postbuild_isl() {
    verify_binary lib/$LINK_libisl
}

# function to append information to config file
function add_config_info_isl() {
    append_to_config_file "# isl-${VERSION_isl}: ${DESC_isl}"
    append_to_config_file "export VERSION_isl=${VERSION_isl}"
    append_to_config_file "export LINK_libisl=${LINK_libisl}"
}
