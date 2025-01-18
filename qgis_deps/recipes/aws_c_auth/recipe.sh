#!/bin/bash

DESC_aws_c_auth="C99 library implementation of AWS client-side authentication"

# version of your package
VERSION_aws_c_auth=0.8.0
LINK_aws_c_auth=libaws-c-auth.dylib

# dependencies of this recipe
DEPS_aws_c_auth=(
    aws_c_common
    aws_c_cal
    aws_c_http
    aws_c_io
    aws_c_sdkutils
)

# url of the package
URL_aws_c_auth=https://github.com/awslabs/aws-c-auth/archive/refs/tags/v${VERSION_aws_c_auth}.tar.gz

# md5 of the package
MD5_aws_c_auth=ca5d0c262b0a4c23e64b0c7e468370ed

# default build path
BUILD_aws_c_auth=$BUILD_PATH/aws_c_auth/$(get_directory $URL_aws_c_auth)

# default recipe path
RECIPE_aws_c_auth=$RECIPES_PATH/aws_c_auth

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_aws_c_auth() {
    cd $BUILD_aws_c_auth

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_aws_c_auth() {
    # If lib is newer than the sourcecode skip build
    if [ ${STAGE_PATH}/lib/$LINK_aws_c_auth -nt $BUILD_aws_c_auth/.patched ]; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_aws_c_auth() {
    try mkdir -p $BUILD_PATH/aws_c_auth/build-$ARCH
    try cd $BUILD_PATH/aws_c_auth/build-$ARCH
    push_env

    try ${CMAKE} \
        -DENABLE_TESTING=OFF \
        $BUILD_aws_c_auth/aws-c-auth
    check_file_configuration CMakeCache.txt

    try $NINJA
    try $NINJA install

    # # fixes all libraries install name
    # for i in `ls ${STAGE_PATH}/lib/libaws*.dylib`;
    # do
    #     install_name_tool -id $i $i
    # done
}

# function called after all the compile have been done
function postbuild_aws_c_auth() {
    verify_binary lib/$LINK_aws_c_auth
}

# function to append information to config file
function postinfo_aws_c_auth() {
    echo "AWS_C_AUTH_VERSION=${VERSION_aws_c_auth}" >> $INFO_PATH/version.sh
    echo "export AWS_C_AUTH_VERSION" >> $INFO_PATH/version.sh
}
