#!/bin/bash

DESC_boost="Collection of portable C++ source libraries"

# version of your package
# version required by MySQL
VERSION_boost=1.87.0

# dependencies of this recipe
DEPS_boost=(zlib xz python python_numpy libicu)

# url of the package
URL_boost=https://archives.boost.io/release/${VERSION_boost}/source/boost_${VERSION_boost//./_}.tar.bz2

# md5 of the package
MD5_boost=ccdfe37d3bad682d841782f760faf141

# default build path
BUILD_boost=$BUILD_PATH/boost/$(get_directory $URL_boost)

# default recipe path
RECIPE_boost=$RECIPES_PATH/boost

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_boost() {
    cd $BUILD_boost

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_boost() {
    # If lib is newer than the sourcecode skip build
    pyver=${VERSION_major_python//./}
    if [ ${STAGE_PATH}/lib/libboost_python${pyver}.dylib -nt $BUILD_boost/.patched ]; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_boost() {
    try rsync -a $BUILD_boost/ $BUILD_PATH/boost/build-$ARCH/
    try cd $BUILD_PATH/boost/build-$ARCH
    push_env

    try ./bootstrap.sh \
        --prefix="${STAGE_PATH}" \
        --libdir="${STAGE_PATH}/lib" \
        --with-toolset=clang \
        --with-icu="${STAGE_PATH}" \
        --with-python="$PYTHON" \
        --with-python-root="$PYTHON" \
        --with-python-version="$VERSION_major_python"

    try ./b2 headers
  
    # architecture="x86" \
    try ./b2 -q \
        variant=release \
        address-model="64" \
        binary-format="mach-o" \
        debug-symbols=off \
        threading=multi \
        runtime-link=shared \
        link=static,shared \
        toolset=clang \
        include="${STAGE_PATH}/include" \
        python="$VERSION_major_python" \
        linkflags="-L${STAGE_PATH}/lib" \
        --layout=system \
        -j"${CORES}" \
        cxxflags=-std=c++14 \
        cxxflags=-stdlib=libc++ \
        linkflags=-stdlib=libc++ \
        install

    pop_env
}

# function called after all the compile have been done
function postbuild_boost() {
    verify_binary lib/libboost_python${VERSION_major_python//./}.dylib
}

# function to append information to config file
function add_config_info_boost() {
    append_to_config_file "# boost-${VERSION_boost}: ${DESC_boost}"
    append_to_config_file "export VERSION_boost=${VERSION_boost}"
}
