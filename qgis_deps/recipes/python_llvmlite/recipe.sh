#!/bin/bash

DESC_python_llvmlite="python llvmlite"

# version of your package
# need to be in sync, see https://llvmlite.readthedocs.io/en/latest/admin-guide/install.html
VERSION_llvm=14.0.6
VERSION_python_llvmlite=0.43.0

# dependencies of this recipe
DEPS_python_llvmlite=(
    python
    python_packages
    python_numpy
    python_pillow
    openblas
)

# url of the package
URL_python_llvmlite=https://github.com/numba/llvmlite/releases/download/v${VERSION_python_llvmlite}/llvmlite-${VERSION_python_llvmlite}.tar.gz

# md5 of the package
MD5_python_llvmlite=4a5e8c916dc6b7d5a295cd2f3863707e

# default build path
BUILD_python_llvmlite=$BUILD_PATH/python_llvmlite/$(get_directory $URL_python_llvmlite)
BUILD_llvm=$BUILD_PATH/python_llvmlite/llvm-$VERSION_llvm.src

# default recipe path
RECIPE_python_llvmlite=$RECIPES_PATH/python_llvmlite

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_llvmlite() {
    cd $BUILD_python_llvmlite

    # check marker
    if [ -f .patched ]; then
        return
    fi

    download_file \
        python_llvmlite \
        https://github.com/llvm/llvm-project/releases/download/llvmorg-${VERSION_llvm}/llvm-${VERSION_llvm}.src.tar.xz \
        80072c6a4be8b9adb60c6aac01f577db

    # thoes patches are not needed to build llvm with lto
    # try cp $BUILD_python_llvmlite/conda-recipes/llvm-lto-static.patch $BUILD_llvm/
    # try cp $BUILD_python_llvmlite/conda-recipes/partial-testing.patch $BUILD_llvm/
    # try cp $BUILD_python_llvmlite/conda-recipes/intel-D47188-svml-VF.patch $BUILD_llvm/
    # try cp $BUILD_python_llvmlite/conda-recipes/0001-Revert-Limit-size-of-non-GlobalValue-name.patch $BUILD_llvm/

    # cd $BUILD_llvm/
    # try patch -p1 -i llvm-lto-static.patch
    # try patch -p1 -i partial-testing.patch
    # try patch -p1 -i intel-D47188-svml-VF.patch
    # try patch -p1 -i 0001-Revert-Limit-size-of-non-GlobalValue-name.patch

    cd $BUILD_python_llvmlite
    touch .patched
}

function shouldbuild_python_llvmlite() {
    # If lib is newer than the sourcecode skip build
    if python_package_installed llvmlite; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_python_llvmlite() {
    # build llvm
    try mkdir -p $BUILD_PATH/python_llvmlite/build-$ARCH-llvm/
    try cd $BUILD_PATH/python_llvmlite/build-$ARCH-llvm/

    push_env
    # chmod +x $BUILD_python_llvmlite/conda-recipes/llvmdev/build.sh
    # try $BUILD_python_llvmlite/conda-recipes/llvmdev/build.sh

    try ${CMAKE} \
        -DLLVM_ENABLE_ASSERTIONS:BOOL=ON \
        -DLINK_POLLY_INTO_TOOLS:BOOL=ON \
        -DLLVM_ENABLE_LIBXML2:BOOL=OFF \
        -DHAVE_TERMINFO_CURSES=OFF \
        -DHAVE_TERMINFO_NCURSES=OFF \
        -DHAVE_TERMINFO_NCURSESW=OFF \
        -DHAVE_TERMINFO_TERMINFO=OFF \
        -DHAVE_TERMINFO_TINFO=OFF \
        -DHAVE_TERMIOS_H=OFF \
        -DCLANG_ENABLE_LIBXML=OFF \
        -DLIBOMP_INSTALL_ALIASES=OFF \
        -DLLVM_ENABLE_RTTI=OFF \
        -DLLVM_TARGETS_TO_BUILD="host;AMDGPU;NVPTX" \
        -DLLVM_INCLUDE_UTILS=ON \
        -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly \
        -DLLVM_INCLUDE_TESTS=OFF \
        -DLLVM_INCLUDE_DOCS=OFF \
        -DLLVM_INCLUDE_EXAMPLES=OFF \
        $BUILD_llvm

    check_file_configuration CMakeCache.txt

    try $NINJA
    try $NINJA install

    pop_env

    # build python
    try rsync -a $BUILD_python_llvmlite/ $BUILD_PATH/python_llvmlite/build-$ARCH/
    try cd $BUILD_PATH/python_llvmlite/build-$ARCH

    push_env

    export LLVM_CONFIG=$STAGE_PATH/bin/llvm-config
    DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install
    unset LLVM_CONFIG

    pop_env
}

# function called after all the compile have been done
function postbuild_python_llvmlite() {
    if ! python_package_installed_verbose llvmlite; then
        error "Missing python package llvmlite"
    fi
}

# function to append information to config file
function add_config_info_python_llvmlite() {
    append_to_config_file "# python_llvmlite-${VERSION_python_llvmlite}: ${DESC_python_llvmlite}"
    append_to_config_file "export VERSION_python_llvmlite=${VERSION_python_llvmlite}"
    append_to_config_file "export VERSION_llvm=${VERSION_llvm}"
}
