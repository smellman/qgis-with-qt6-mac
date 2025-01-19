#!/bin/bash

DESC_aws_sdk_cpp="AWS SDK for C++"

# version of your package
VERSION_aws_sdk_cpp=1.11.483
LINK_aws_sdk_cpp=libaws-cpp-sdk-ec2.dylib

# dependencies of this recipe
DEPS_aws_sdk_cpp=(
    aws_c_auth
    aws_c_common
    aws_c_event_stream
    aws_c_http
    aws_c_io
    aws_c_s3
    aws_crt_cpp
)

# url of the package
URL_aws_sdk_cpp=https://github.com/aws/aws-sdk-cpp/archive/refs/tags/${VERSION_aws_sdk_cpp}.tar.gz

# md5 of the package
MD5_aws_sdk_cpp=627fdc82c48ffc19fc5d024089e6a911

# default build path
BUILD_aws_sdk_cpp=$BUILD_PATH/aws_sdk_cpp/$(get_directory $URL_aws_sdk_cpp)

# default recipe path
RECIPE_aws_sdk_cpp=$RECIPES_PATH/aws_sdk_cpp

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_aws_sdk_cpp() {
    cd $BUILD_aws_sdk_cpp

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_aws_sdk_cpp() {
    # If lib is newer than the sourcecode skip build
    if [ ${STAGE_PATH}/lib/$LINK_aws_sdk_cpp -nt $BUILD_aws_sdk_cpp/.patched ]; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_aws_sdk_cpp() {
    try mkdir -p $BUILD_PATH/aws_sdk_cpp/build-$ARCH
    try cd $BUILD_PATH/aws_sdk_cpp/build-$ARCH
    push_env

    try ${CMAKE} \
        -DENABLE_TESTING=OFF \
        $BUILD_aws_sdk_cpp/aws-sdk-cpp
    check_file_configuration CMakeCache.txt

    try $NINJA
    try $NINJA install

    pop_env
}

# function called after all the compile have been done
function postbuild_aws_sdk_cpp() {
    verify_binary lib/$LINK_aws_sdk_cpp
}

# function to append information to config file
function add_config_info_aws_sdk_cpp() {
    append_to_config_file "# aws_sdk_cpp-${VERSION_aws_sdk_cpp}: ${DESC_aws_sdk_cpp}"
    append_to_config_file "export VERSION_aws_sdk_cpp=${VERSION_aws_sdk_cpp}"
    append_to_config_file "export LINK_aws_sdk_cpp=${LINK_aws_sdk_cpp}"
}
