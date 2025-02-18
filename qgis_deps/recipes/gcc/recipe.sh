#!/bin/bash

DESC_gcc="gcc"

# we need this to compile FORTRAN
VERSION_gcc_major=14
VERSION_gcc=${VERSION_gcc_major}.2.0

LINK_libgfortran=libgfortran.5.dylib
LINK_gcc_s=libgcc_s.1.1.dylib
LINK_libquadmath=libquadmath.0.dylib

# dependencies of this recipe
DEPS_gcc=(
    gmp
    isl
    libmpc
    mpfr
    zstd
)

# url of the package
URL_gcc=https://ftp.gnu.org/gnu/gcc/gcc-${VERSION_gcc}/gcc-${VERSION_gcc}.tar.xz

# md5 of the package
MD5_gcc=2268420ba02dc01821960e274711bde0

# default build path
BUILD_gcc=$BUILD_PATH/gcc/$(get_directory $URL_gcc)

# default recipe path
RECIPE_gcc=$RECIPES_PATH/gcc

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_gcc() {
    cd $BUILD_gcc

    # check marker
    if [ -f .patched ]; then
        return
    fi

    # patch_configure_file configure

    touch .patched
}

function shouldbuild_gcc() {
    if [ ${STAGE_PATH}/lib/${LINK_libgfortran} -nt $BUILD_gcc/.patched ]; then
        DO_BUILD=0
    fi
}

function build_gcc() {
    try rsync -a $BUILD_gcc/ $BUILD_PATH/gcc/build-$ARCH/
    try cd $BUILD_PATH/gcc/build-$ARCH
    push_env

    unset LD

    try ${CONFIGURE} \
        --enable-languages=fortran,c,c++,objc,obj-c++ \
        --disable-multilib \
        --disable-nls \
        --with-system-zlib \
        --enable-checking=release \
        --program-suffix=-${VERSION_gcc_major} \
        --with-native-system-header-dir=/usr/include \
        --with-sysroot=`xcrun --show-sdk-path` \
        --with-gmp=$STAGE_PATH \
        --with-mpfr=$STAGE_PATH \
        --with-mpc=$STAGE_PATH \
        --with-isl=$STAGE_PATH \
        --with-zstd=$STAGE_PATH

    check_file_configuration config.status

    try $MAKESMP "BOOT_LDFLAGS=-Wl,-headerpad_max_install_names"
    try $MAKESMP install

    cd $STAGE_PATH/bin
    ln -s gfortran-$VERSION_gcc_major gfortran
    ln -s gcc-$VERSION_gcc_major gcc
    ln -s gcc-ar-$VERSION_gcc_major gcc-ar
    ln -s gcc-nm-$VERSION_gcc_major gcc-nm
    ln -s gcc-ranlib-$VERSION_gcc_major gcc-ranlib

    pop_env
}

# function called after all the compile have been done
function postbuild_gcc() {
    verify_binary lib/$LINK_libgfortran
    verify_binary lib/$LINK_libquadmath
    verify_binary lib/$LINK_gcc_s
}

# function to append information to config file
function add_config_info_gcc() {
    append_to_config_file "# gcc-${VERSION_gcc}: ${DESC_gcc}"
    append_to_config_file "export VERSION_gcc=${VERSION_gcc}"
    append_to_config_file "export VERSION_gcc_major=${VERSION_gcc_major}"
    append_to_config_file "export LINK_libgfortran=$LINK_libgfortran"
    append_to_config_file "export LINK_libquadmath=$LINK_libquadmath"
    append_to_config_file "export LINK_gcc_s=$LINK_gcc_s"
}
