#!/bin/bash

DESC_aws_c_event_stream="C99 implementation of the vnd.amazon.eventstream content-type"

# version of your package
VERSION_aws_c_event_stream=0.15.3
LINK_aws_c_event_stream=libaws-c-io.dylib

# dependencies of this recipe
DEPS_aws_c_event_stream=(
    aws_c_common
    aws_c_io
    aws_checksums
)

# url of the package
URL_aws_c_event_stream=https://github.com/awslabs/aws-c-event-stream/archive/refs/tags/v${VERSION_aws_c_event_stream}.tar.gz

# md5 of the package
MD5_aws_c_event_stream=07c3eb652f93486281d4e3e8404647ef

# default build path
BUILD_aws_c_event_stream=$BUILD_PATH/aws_c_event_stream/$(get_directory $URL_aws_c_event_stream)

# default recipe path
RECIPE_aws_c_event_stream=$RECIPES_PATH/aws_c_event_stream

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_aws_c_event_stream() {
    cd $BUILD_aws_c_event_stream

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_aws_c_event_stream() {
    # If lib is newer than the sourcecode skip build
    if [ ${STAGE_PATH}/lib/$LINK_aws_c_event_stream -nt $BUILD_aws_c_event_stream/.patched ]; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_aws_c_event_stream() {
    try mkdir -p $BUILD_PATH/aws_c_event_stream/build-$ARCH
    try cd $BUILD_PATH/aws_c_event_stream/build-$ARCH
    push_env

    try ${CMAKE} \
        -DENABLE_TESTING=OFF \
        $BUILD_aws_c_event_stream/aws-c-event-stream
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
function postbuild_aws_c_event_stream() {
    verify_binary lib/$LINK_aws_c_event_stream
}

# function to append information to config file
function add_config_info_aws_c_event_stream() {
    append_to_config_file "# aws_c_event_stream-${VERSION_aws_c_event_stream}: ${DESC_aws_c_event_stream}"
    append_to_config_file "export VERSION_aws_c_event_stream=${VERSION_aws_c_event_stream}"
    append_to_config_file "export LINK_aws_c_event_stream=${LINK_aws_c_event_stream}"
}
