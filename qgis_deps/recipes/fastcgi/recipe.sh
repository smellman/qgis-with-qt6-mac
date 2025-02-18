#!/bin/bash

DESC_fastcgi="Protocol for interfacing interactive programs with a web server"

# version of your package
VERSION_fastcgi=2.4.4
LINK_fastcgi=libfcgi.0.dylib

# dependencies of this recipe
DEPS_fastcgi=()

# url of the package
URL_fastcgi=https://github.com/FastCGI-Archives/fcgi2/archive/refs/tags/${VERSION_fastcgi}.tar.gz

# md5 of the package
MD5_fastcgi=8a54d4ce6a5b0cb58d9d2458cd316bce

# default build path
BUILD_fastcgi=$BUILD_PATH/fastcgi/$(get_directory $URL_fastcgi)

# default recipe path
RECIPE_fastcgi=$RECIPES_PATH/fastcgi

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_fastcgi() {
    cd $BUILD_fastcgi

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_fastcgi() {
    # If lib is newer than the sourcecode skip build
    if [ ${STAGE_PATH}/lib/$LINK_fastcgi -nt $BUILD_fastcgi/.patched ]; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_fastcgi() {
    try rsync -a $BUILD_fastcgi/ $BUILD_PATH/fastcgi/build-$ARCH/
    try cd $BUILD_PATH/fastcgi/build-$ARCH
    push_env

    try ./autogen.sh
    patch_configure_file configure
    try ${CONFIGURE} --disable-debug --disable-dependency-tracking

    check_file_configuration config.status
    try $MAKESMP
    try $MAKESMP install

    pop_env
}

# function called after all the compile have been done
function postbuild_fastcgi() {
    verify_binary lib/$LINK_fastcgi
}

# function to append information to config file
function add_config_info_fastcgi() {
    append_to_config_file "# fastcgi-${VERSION_fastcgi}: ${DESC_fastcgi}"
    append_to_config_file "export VERSION_fastcgi=${VERSION_fastcgi}"
    append_to_config_file "export LINK_fastcgi=${LINK_fastcgi}"
}
