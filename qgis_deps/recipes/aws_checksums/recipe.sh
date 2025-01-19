#!/bin/bash

DESC_aws_checksums="Cross-Platform HW accelerated CRC32c and CRC32 with fallback"

# version of your package
VERSION_aws_checksums=0.2.2
LINK_aws_checksums=libaws-checksums.dylib

# dependencies of this recipe
DEPS_aws_checksums=(aws_c_common)

# url of the package
URL_aws_checksums=https://github.com/awslabs/aws-checksums/archive/refs/tags/v${VERSION_aws_checksums}.tar.gz

# md5 of the package
MD5_aws_checksums=a1d927274b03a22f783d67cebb05a0f1

# default build path
BUILD_aws_checksums=$BUILD_PATH/aws_checksums/$(get_directory $URL_aws_checksums)

# default recipe path
RECIPE_aws_checksums=$RECIPES_PATH/aws_checksums

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_aws_checksums() {
    cd $BUILD_aws_checksums

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_aws_checksums() {
    # If lib is newer than the sourcecode skip build
    if [ ${STAGE_PATH}/lib/$LINK_aws_checksums -nt $BUILD_aws_checksums/.patched ]; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_aws_checksums() {
    try mkdir -p $BUILD_PATH/aws_checksums/build-$ARCH
    try cd $BUILD_PATH/aws_checksums/build-$ARCH
    push_env

    try ${CMAKE} \
        -DENABLE_TESTING=OFF \
        -DBUILD_SHARED_LIBS=ON \
        $BUILD_aws_checksums
    check_file_configuration CMakeCache.txt

    try $NINJA
    try $NINJA install

    try install_name_tool -id ${STAGE_PATH}/lib/$LINK_aws_checksums $STAGE_PATH/lib/$LINK_aws_checksums

    pop_env
}

# function called after all the compile have been done
function postbuild_aws_checksums() {
    verify_binary lib/$LINK_aws_checksums
}

# function to append information to config file
function add_config_info_aws_checksums() {
    append_to_config_file "# aws_checksums-${VERSION_aws_checksums}: ${DESC_aws_checksums}"
    append_to_config_file "export VERSION_aws_checksums=${VERSION_aws_checksums}"
    append_to_config_file "export LINK_aws_checksums=${LINK_aws_checksums}"
}
