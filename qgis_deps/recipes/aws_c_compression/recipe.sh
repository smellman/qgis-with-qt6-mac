#!/bin/bash

DESC_aws_c_compression="C99 implementation of huffman encoding/decoding"

# version of your package
VERSION_aws_c_compression=0.3.0
LINK_aws_c_compression=libaws-c-compression.dylib

# dependencies of this recipe
DEPS_aws_c_compression=(aws_c_common)

# url of the package
URL_aws_c_compression=https://github.com/awslabs/aws-c-compression/archive/refs/tags/v${VERSION_aws_c_compression}.tar.gz

# md5 of the package
MD5_aws_c_compression=3ecc38992ec676e7927eafd46ce76917

# default build path
BUILD_aws_c_compression=$BUILD_PATH/aws_c_compression/$(get_directory $URL_aws_c_compression)

# default recipe path
RECIPE_aws_c_compression=$RECIPES_PATH/aws_c_compression

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_aws_c_compression() {
    cd $BUILD_aws_c_compression

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_aws_c_compression() {
    # If lib is newer than the sourcecode skip build
    if [ ${STAGE_PATH}/lib/$LINK_aws_c_compression -nt $BUILD_aws_c_compression/.patched ]; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_aws_c_compression() {
    try mkdir -p $BUILD_PATH/aws_c_compression/build-$ARCH
    try cd $BUILD_PATH/aws_c_compression/build-$ARCH
    push_env

    try ${CMAKE} \
        -DENABLE_TESTING=OFF \
        -DBUILD_SHARED_LIBS=ON \
        $BUILD_aws_c_compression
    check_file_configuration CMakeCache.txt

    try $NINJA
    try $NINJA install

    try install_name_tool -id ${STAGE_PATH}/lib/$LINK_aws_c_compression $STAGE_PATH/lib/$LINK_aws_c_compression

    pop_env
}

# function called after all the compile have been done
function postbuild_aws_c_compression() {
    verify_binary lib/$LINK_aws_c_compression
}

# function to append information to config file
function add_config_info_aws_c_compression() {
    append_to_config_file "# aws_c_compression-${VERSION_aws_c_compression}: ${DESC_aws_c_compression}"
    append_to_config_file "export VERSION_aws_c_compression=${VERSION_aws_c_compression}"
    append_to_config_file "export LINK_aws_c_compression=${LINK_aws_c_compression}"
}
