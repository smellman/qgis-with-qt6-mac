#!/bin/bash

DESC_aws_c_mqtt="C99 implementation of the MQTT 3.1.1 specification"

# version of your package
VERSION_aws_c_mqtt=0.11.0
LINK_aws_c_mqtt=libaws-c-mqtt.dylib

# dependencies of this recipe
DEPS_aws_c_mqtt=(
    aws_c_common
    aws_c_http
    aws_c_io
)

# url of the package
URL_aws_c_mqtt=https://github.com/awslabs/aws-c-mqtt/archive/refs/tags/v${VERSION_aws_c_mqtt}.tar.gz

# md5 of the package
MD5_aws_c_mqtt=e8596af1479af43dd2ce2464350d0500

# default build path
BUILD_aws_c_mqtt=$BUILD_PATH/aws_c_mqtt/$(get_directory $URL_aws_c_mqtt)

# default recipe path
RECIPE_aws_c_mqtt=$RECIPES_PATH/aws_c_mqtt

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_aws_c_mqtt() {
    cd $BUILD_aws_c_mqtt

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_aws_c_mqtt() {
    # If lib is newer than the sourcecode skip build
    if [ ${STAGE_PATH}/lib/$LINK_aws_c_mqtt -nt $BUILD_aws_c_mqtt/.patched ]; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_aws_c_mqtt() {
    try mkdir -p $BUILD_PATH/aws_c_mqtt/build-$ARCH
    try cd $BUILD_PATH/aws_c_mqtt/build-$ARCH
    push_env

    try ${CMAKE} \
        -DENABLE_TESTING=OFF \
        $BUILD_aws_c_mqtt/aws-c-mqtt
    check_file_configuration CMakeCache.txt

    try $NINJA
    try $NINJA install

    pop_env
}

# function called after all the compile have been done
function postbuild_aws_c_mqtt() {
    verify_binary lib/$LINK_aws_c_mqtt
}

# function to append information to config file
function add_config_info_aws_c_mqtt() {
    append_to_config_file "# aws_c_mqtt-${VERSION_aws_c_mqtt}: ${DESC_aws_c_mqtt}"
    append_to_config_file "export VERSION_aws_c_mqtt=${VERSION_aws_c_mqtt}"
    append_to_config_file "export LINK_aws_c_mqtt=${LINK_aws_c_mqtt}"
}
