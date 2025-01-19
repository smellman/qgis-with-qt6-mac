#!/bin/bash

DESC_aws_c_sdkutils="C99 library implementing AWS SDK specific utilities"

# version of your package
VERSION_aws_c_sdkutils=0.2.2
LINK_aws_c_sdkutils=libaws-c-sdkutils.dylib

# dependencies of this recipe
DEPS_aws_c_sdkutils=(aws_c_common)

# url of the package
URL_aws_c_sdkutils=https://github.com/awslabs/aws-c-sdkutils/archive/refs/tags/v${VERSION_aws_c_sdkutils}.tar.gz

# md5 of the package
MD5_aws_c_sdkutils=15aad478ce738a0500c5ab1ce90f455d

# default build path
BUILD_aws_c_sdkutils=$BUILD_PATH/aws_c_sdkutils/$(get_directory $URL_aws_c_sdkutils)

# default recipe path
RECIPE_aws_c_sdkutils=$RECIPES_PATH/aws_c_sdkutils

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_aws_c_sdkutils() {
    cd $BUILD_aws_c_sdkutils

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_aws_c_sdkutils() {
    # If lib is newer than the sourcecode skip build
    if [ ${STAGE_PATH}/lib/$LINK_aws_c_sdkutils -nt $BUILD_aws_c_sdkutils/.patched ]; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_aws_c_sdkutils() {
    try mkdir -p $BUILD_PATH/aws_c_sdkutils/build-$ARCH
    try cd $BUILD_PATH/aws_c_sdkutils/build-$ARCH
    push_env

    try ${CMAKE} \
        -DENABLE_TESTING=OFF \
        $BUILD_aws_c_sdkutils/aws-c-sdkutils
    check_file_configuration CMakeCache.txt

    try $NINJA
    try $NINJA install

    pop_env
}

# function called after all the compile have been done
function postbuild_aws_c_sdkutils() {
    verify_binary lib/$LINK_aws_c_sdkutils
}

# function to append information to config file
function add_config_info_aws_c_sdkutils() {
    append_to_config_file "# aws_c_sdkutils-${VERSION_aws_c_sdkutils}: ${DESC_aws_c_sdkutils}"
    append_to_config_file "export VERSION_aws_c_sdkutils=${VERSION_aws_c_sdkutils}"
    append_to_config_file "export LINK_aws_c_sdkutils=${LINK_aws_c_sdkutils}"
}
