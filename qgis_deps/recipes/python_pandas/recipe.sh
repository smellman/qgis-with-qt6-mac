#!/bin/bash

DESC_python_pandas="python pandas"

# version of your package
VERSION_python_pandas=2.2.3

# dependencies of this recipe
DEPS_python_pandas=(python python_packages python_numpy)

# url of the package
URL_python_pandas=https://github.com/pandas-dev/pandas/releases/download/v${VERSION_python_pandas}/pandas-${VERSION_python_pandas}.tar.gz

# md5 of the package
MD5_python_pandas=67cae6d658e0e0716518afd84d7d43ce

# default build path
BUILD_python_pandas=$BUILD_PATH/python_pandas/$(get_directory $URL_python_pandas)

# default recipe path
RECIPE_python_pandas=$RECIPES_PATH/python_pandas

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_pandas() {
    cd $BUILD_python_pandas

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_python_pandas() {
    # If lib is newer than the sourcecode skip build
    if python_package_installed pandas; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_python_pandas() {
    try rsync -a $BUILD_python_pandas/ $BUILD_PATH/python_pandas/build-$ARCH/
    try cd $BUILD_PATH/python_pandas/build-$ARCH
    push_env

    # setup.py depends versioneer
    DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP_NO_BINARY install versioneer==0.29

    DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

    pop_env
}

# function called after all the compile have been done
function postbuild_python_pandas() {
    if ! python_package_installed_verbose pandas; then
        error "Missing python package pandas"
    fi
}

# function to append information to config file
function add_config_info_python_pandas() {
    append_to_config_file "# python_pandas-${VERSION_python_pandas}: ${DESC_python_pandas}"
    append_to_config_file "export VERSION_python_pandas=${VERSION_python_pandas}"
}
