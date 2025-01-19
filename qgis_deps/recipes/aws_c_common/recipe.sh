#!/bin/bash

DESC_aws_c_common="Core c99 package for AWS SDK for C"

# version of your package
VERSION_aws_c_common=0.10.6
LINK_aws_c_common=libaws-c-common.dylib

# dependencies of this recipe
DEPS_aws_c_common=()

# url of the package
URL_aws_c_common=https://github.com/awslabs/aws-c-common/archive/refs/tags/v${VERSION_aws_c_common}.tar.gz

# md5 of the package
MD5_aws_c_common=d2b3eac87133329be81538049b6129e9

# default build path
BUILD_aws_c_common=$BUILD_PATH/aws_c_common/$(get_directory $URL_aws_c_common)

# default recipe path
RECIPE_aws_c_common=$RECIPES_PATH/aws_c_common

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_aws_c_common() {
    cd $BUILD_aws_c_common

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_aws_c_common() {
    # If lib is newer than the sourcecode skip build
    if [ ${STAGE_PATH}/lib/$LINK_aws_c_common -nt $BUILD_aws_c_common/.patched ]; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_aws_c_common() {
    try mkdir -p $BUILD_PATH/aws_c_common/build-$ARCH
    try cd $BUILD_PATH/aws_c_common/build-$ARCH
    push_env

    try ${CMAKE} \
        -DENABLE_TESTING=OFF \
        $BUILD_aws_c_common
    check_file_configuration CMakeCache.txt

    try $NINJA
    try $NINJA install

    # # fixes all libraries install name
    # for i in `ls ${STAGE_PATH}/lib/libaws*.dylib`;
    # do
    #     fix_install_name lib/`basename $i`
    # done

    pop_env
}

# function called after all the compile have been done
function postbuild_aws_c_common() {
    verify_binary lib/$LINK_aws_c_common
}

# function to append information to config file
function add_config_info_aws_c_common() {
    append_to_config_file "# aws_c_common-${VERSION_aws_c_common}: ${DESC_aws_c_common}"
    append_to_config_file "export VERSION_aws_c_common=${VERSION_aws_c_common}"
    append_to_config_file "export LINK_aws_c_common=${LINK_aws_c_common}"
}
