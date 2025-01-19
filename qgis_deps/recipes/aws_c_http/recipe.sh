#!/bin/bash

DESC_aws_c_http="C99 implementation of the HTTP/1.1 and HTTP/2 specifications"

# version of your package
VERSION_aws_c_http=0.9.2
LINK_aws_c_http=libaws-c-http.dylib

# dependencies of this recipe
DEPS_aws_c_http=(
    aws_c_cal
    aws_c_common
    aws_c_compression
    aws_c_io
)

# url of the package
URL_aws_c_http=https://github.com/awslabs/aws-c-http/archive/refs/tags/v${VERSION_aws_c_http}.tar.gz

# md5 of the package
MD5_aws_c_http=5aadae8619a5b09739b99d886075879d

# default build path
BUILD_aws_c_http=$BUILD_PATH/aws_c_http/$(get_directory $URL_aws_c_http)

# default recipe path
RECIPE_aws_c_http=$RECIPES_PATH/aws_c_http

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_aws_c_http() {
    cd $BUILD_aws_c_http

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_aws_c_http() {
    # If lib is newer than the sourcecode skip build
    if [ ${STAGE_PATH}/lib/$LINK_aws_c_http -nt $BUILD_aws_c_http/.patched ]; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_aws_c_http() {
    try mkdir -p $BUILD_PATH/aws_c_http/build-$ARCH
    try cd $BUILD_PATH/aws_c_http/build-$ARCH
    push_env

    try ${CMAKE} \
        -DENABLE_TESTING=OFF \
        -DBUILD_SHARED_LIBS=ON \
        $BUILD_aws_c_http
    check_file_configuration CMakeCache.txt

    try $NINJA
    try $NINJA install

    try install_name_tool -id ${STAGE_PATH}/lib/$LINK_aws_c_http $STAGE_PATH/lib/$LINK_aws_c_http

    pop_env
}

# function called after all the compile have been done
function postbuild_aws_c_http() {
    verify_binary lib/$LINK_aws_c_http
}

# function to append information to config file
function add_config_info_aws_c_http() {
    append_to_config_file "# aws_c_http-${VERSION_aws_c_http}: ${DESC_aws_c_http}"
    append_to_config_file "export VERSION_aws_c_http=${VERSION_aws_c_http}"
    append_to_config_file "export LINK_aws_c_http=${LINK_aws_c_http}"
}
