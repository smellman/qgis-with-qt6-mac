#!/bin/bash

DESC_aws_c_s3="C99 library implementation for communicating with the S3 service"

# version of your package
VERSION_aws_c_s3=0.7.9
LINK_aws_c_s3=libaws-c-s3.dylib

# dependencies of this recipe
DEPS_aws_c_s3=(
    aws_c_auth
    aws_c_cal
    aws_c_common
    aws_c_http
    aws_c_io
    aws_checksums
)

# url of the package
URL_aws_c_s3=https://github.com/awslabs/aws-c-s3/archive/refs/tags/v${VERSION_aws_c_s3}.tar.gz

# md5 of the package
MD5_aws_c_s3=bf71ab3e34f9c7c673842f03903195e2

# default build path
BUILD_aws_c_s3=$BUILD_PATH/aws_c_s3/$(get_directory $URL_aws_c_s3)

# default recipe path
RECIPE_aws_c_s3=$RECIPES_PATH/aws_c_s3

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_aws_c_s3() {
    cd $BUILD_aws_c_s3

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_aws_c_s3() {
    # If lib is newer than the sourcecode skip build
    if [ ${STAGE_PATH}/lib/$LINK_aws_c_s3 -nt $BUILD_aws_c_s3/.patched ]; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_aws_c_s3() {
    try mkdir -p $BUILD_PATH/aws_c_s3/build-$ARCH
    try cd $BUILD_PATH/aws_c_s3/build-$ARCH
    push_env

    try ${CMAKE} \
        -DENABLE_TESTING=OFF \
        -DBUILD_SHARED_LIBS=ON \
        $BUILD_aws_c_s3
    check_file_configuration CMakeCache.txt

    try $NINJA
    try $NINJA install

    try install_name_tool -id ${STAGE_PATH}/lib/$LINK_aws_c_s3 $STAGE_PATH/lib/$LINK_aws_c_s3

    pop_env
}

# function called after all the compile have been done
function postbuild_aws_c_s3() {
    verify_binary lib/$LINK_aws_c_s3
}

# function to append information to config file
function add_config_info_aws_c_s3() {
    append_to_config_file "# aws_c_s3-${VERSION_aws_c_s3}: ${DESC_aws_c_s3}"
    append_to_config_file "export VERSION_aws_c_s3=${VERSION_aws_c_s3}"
    append_to_config_file "export LINK_aws_c_s3=${LINK_aws_c_s3}"
}
