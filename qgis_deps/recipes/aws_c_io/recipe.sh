#!/bin/bash

DESC_aws_c_io="Event driven framework for implementing application protocols"

# version of your package
VERSION_aws_c_io=0.15.3
LINK_aws_c_io=libaws-c-io.dylib

# dependencies of this recipe
DEPS_aws_c_io=(
    aws_c_cal
    aws_c_common
)

# url of the package
URL_aws_c_io=https://github.com/awslabs/aws-c-io/archive/refs/tags/v${VERSION_aws_c_io}.tar.gz

# md5 of the package
MD5_aws_c_io=b3df9ea54018e71934775931fdf6efe2

# default build path
BUILD_aws_c_io=$BUILD_PATH/aws_c_io/$(get_directory $URL_aws_c_io)

# default recipe path
RECIPE_aws_c_io=$RECIPES_PATH/aws_c_io

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_aws_c_io() {
    cd $BUILD_aws_c_io

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_aws_c_io() {
    # If lib is newer than the sourcecode skip build
    if [ ${STAGE_PATH}/lib/$LINK_aws_c_io -nt $BUILD_aws_c_io/.patched ]; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_aws_c_io() {
    try mkdir -p $BUILD_PATH/aws_c_io/build-$ARCH
    try cd $BUILD_PATH/aws_c_io/build-$ARCH
    push_env

    try ${CMAKE} \
        -DENABLE_TESTING=OFF \
        $BUILD_aws_c_io/aws-c-io
    check_file_configuration CMakeCache.txt

    try $NINJA
    try $NINJA install

    pop_env
}

# function called after all the compile have been done
function postbuild_aws_c_io() {
    verify_binary lib/$LINK_aws_c_io
}

# function to append information to config file
function add_config_info_aws_c_io() {
    append_to_config_file "# aws_c_io-${VERSION_aws_c_io}: ${DESC_aws_c_io}"
    append_to_config_file "export VERSION_aws_c_io=${VERSION_aws_c_io}"
    append_to_config_file "export LINK_aws_c_io=${LINK_aws_c_io}"
}
