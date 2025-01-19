#!/bin/bash

DESC_libomp="LLVM's OpenMP runtime library"

# version of your package
VERSION_libomp=19.1.6

LINK_libomp=libomp.dylib

# dependencies of this recipe
DEPS_libomp=(python python_packages)

# url of the package
URL_libomp=https://github.com/llvm/llvm-project/releases/download/llvmorg-$VERSION_libomp/openmp-$VERSION_libomp.src.tar.xz

# md5 of the package
MD5_libomp=a75326b11ac57a95ac38be9f7cce812a

# default build path
BUILD_libomp=$BUILD_PATH/libomp/$(get_directory $URL_libomp)

# default recipe path
RECIPE_libomp=$RECIPES_PATH/libomp

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libomp() {
    cd $BUILD_libomp

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_libomp() {
    if [ ${STAGE_PATH}/lib/${LINK_libomp} -nt $BUILD_libomp/.patched ]; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_libomp() {
    try rsync -a $BUILD_libomp/ $BUILD_PATH/libomp/build-$ARCH/
    try cd $BUILD_PATH/libomp/build-$ARCH

    push_env

    try $CMAKE \
        -DLIBOMP_INSTALL_ALIASES=OFF \
        -B build/shared
    # check_file_configuration CMakeCache.txt

    try cmake --build build/shared
    try cmake --install build/shared

    # try install_name_tool -id ${STAGE_PATH}/lib/${LINK_libomp} ${STAGE_PATH}/lib/${LINK_libomp}

    pop_env
}

# function called after all the compile have been done
function postbuild_libomp() {
    verify_binary lib/$LINK_libomp
}

# function to append information to config file
function add_config_info_libomp() {
    append_to_config_file "# libomp-${VERSION_libomp}: ${DESC_libomp}"
    append_to_config_file "export VERSION_libomp=${VERSION_libomp}"
    append_to_config_file "export LINK_libomp=${LINK_libomp}"
}
