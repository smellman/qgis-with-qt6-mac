#!/bin/bash

DESC_aws_c_cal="AWS Crypto Abstraction Layer"

# version of your package
VERSION_aws_c_cal=0.8.1
LINK_aws_c_cal=libaws-c-cal.dylib

# dependencies of this recipe
DEPS_aws_c_cal=(
    aws_c_common
)

# url of the package
URL_aws_c_cal=https://github.com/awslabs/aws-c-cal/archive/refs/tags/v${VERSION_aws_c_cal}.tar.gz

# md5 of the package
MD5_aws_c_cal=ed8340d00a6b0e660e3fb244b0b0e3c4

# default build path
BUILD_aws_c_cal=$BUILD_PATH/aws_c_cal/$(get_directory $URL_aws_c_cal)

# default recipe path
RECIPE_aws_c_cal=$RECIPES_PATH/aws_c_cal

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_aws_c_cal() {
    cd $BUILD_aws_c_cal

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_aws_c_cal() {
    # If lib is newer than the sourcecode skip build
    if [ ${STAGE_PATH}/lib/$LINK_aws_c_cal -nt $BUILD_aws_c_cal/.patched ]; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_aws_c_cal() {
    try mkdir -p $BUILD_PATH/aws_c_cal/build-$ARCH
    try cd $BUILD_PATH/aws_c_cal/build-$ARCH
    push_env

    try ${CMAKE} \
        -DENABLE_TESTING=OFF \
        $BUILD_aws_c_cal/aws-c-cal
    check_file_configuration CMakeCache.txt

    try $NINJA
    try $NINJA install
}

# function called after all the compile have been done
function postbuild_aws_c_cal() {
    verify_binary lib/$LINK_aws_c_cal
}

# function to append information to config file
function add_config_info_aws_c_cal() {
    append_to_config_file "# aws_c_cal-${VERSION_aws_c_cal}: ${DESC_aws_c_cal}"
    append_to_config_file "export VERSION_aws_c_cal=${VERSION_aws_c_cal}"
    append_to_config_file "export LINK_aws_c_cal=${LINK_aws_c_cal}"
}
