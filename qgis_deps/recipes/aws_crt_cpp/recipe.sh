#!/bin/bash

DESC_aws_crt_cpp="C++ wrapper around the aws-c-* libraries"

# version of your package
VERSION_aws_crt_cpp=0.29.9
LINK_aws_crt_cpp=libaws-crt-cpp.dylib

# dependencies of this recipe
DEPS_aws_crt_cpp=(
    aws_c_auth
    aws_c_cal
    aws_c_common
    aws_c_event_stream
    aws_c_http
    aws_c_io
    aws_c_mqtt
    aws_c_s3
    aws_c_sdkutils
    aws_checksums
)

# url of the package
URL_aws_crt_cpp=https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v${VERSION_aws_crt_cpp}.tar.gz

# md5 of the package
MD5_aws_crt_cpp=e8fb9461a24391e8b6e2e9e7f1f4dd76

# default build path
BUILD_aws_crt_cpp=$BUILD_PATH/aws_crt_cpp/$(get_directory $URL_aws_crt_cpp)

# default recipe path
RECIPE_aws_crt_cpp=$RECIPES_PATH/aws_crt_cpp

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_aws_crt_cpp() {
    cd $BUILD_aws_crt_cpp

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_aws_crt_cpp() {
    # If lib is newer than the sourcecode skip build
    if [ ${STAGE_PATH}/lib/$LINK_aws_crt_cpp -nt $BUILD_aws_crt_cpp/.patched ]; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_aws_crt_cpp() {
    try mkdir -p $BUILD_PATH/aws_crt_cpp/build-$ARCH
    try cd $BUILD_PATH/aws_crt_cpp/build-$ARCH
    push_env

    try ${CMAKE} \
        -DENABLE_TESTING=OFF \
        $BUILD_aws_crt_cpp/aws-crt-cpp
    check_file_configuration CMakeCache.txt

    try $NINJA
    try $NINJA install

    pop_env
}

# function called after all the compile have been done
function postbuild_aws_crt_cpp() {
    verify_binary lib/$LINK_aws_crt_cpp
}

# function to append information to config file
function add_config_info_aws_crt_cpp() {
    append_to_config_file "# aws_crt_cpp-${VERSION_aws_crt_cpp}: ${DESC_aws_crt_cpp}"
    append_to_config_file "export VERSION_aws_crt_cpp=${VERSION_aws_crt_cpp}"
    append_to_config_file "export LINK_aws_crt_cpp=${LINK_aws_crt_cpp}"
}
