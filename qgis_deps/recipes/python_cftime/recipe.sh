#!/bin/bash

DESC_python_cftime="Time-handling functionality from netcdf4-python"

# version of your package
# need to keep in sync with compatible version of netcdf lib
VERSION_python_cftime=1.6.4.post1

# dependencies of this recipe
DEPS_python_cftime=(
    python
    python_packages
    netcdf
    hdf5
    python_numpy
    libcurl
)

# url of the package
URL_python_cftime=https://files.pythonhosted.org/packages/ab/c8/1155d1d58003105307c7e5985f422ae5bcb2ca0cbc553cc828f3c5a934a7/cftime-${VERSION_python_cftime}.tar.gz

# md5 of the package
MD5_python_cftime=9006ff140791be6e6ca20ed87dfb4a25

# default build path
BUILD_python_cftime=$BUILD_PATH/python_cftime/$(get_directory $URL_python_cftime)

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_cftime() {
    mkdir -p $BUILD_python_cftime
    cd $BUILD_python_cftime

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_python_cftime() {
    # If lib is newer than the sourcecode skip build
    if python_package_installed cftime; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_python_cftime() {
    try rsync -a $BUILD_python_cftime/ $BUILD_PATH/python_cftime/build-$ARCH/
    try cd $BUILD_PATH/python_cftime/build-$ARCH

    push_env

    export HDF5_DIR=$STAGE_PATH
    export NETCDF4_DIR=$STAGE_PATH
    export CURL_DIR=$STAGE_PATH

    DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

    unset HDF5_DIR
    unset NETCDF4_DIR
    unset CURL_DIR

    pop_env
}

# function called after all the compile have been done
function postbuild_python_cftime() {
    if ! python_package_installed_verbose cftime; then
        error "Missing python package cftime"
    fi
}

# function to append information to config file
function add_config_info_python_cftime() {
    append_to_config_file "# python_cftime-${VERSION_python_cftime}: ${DESC_python_cftime}"
    append_to_config_file "export VERSION_python_cftime=${VERSION_python_cftime}"
}
