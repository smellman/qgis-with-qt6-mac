#!/bin/bash

DESC_python_psycopg2="Python-PostgreSQL Database Adapter"

# version of your package
VERSION_python_psycopg2=2.9.10

# dependencies of this recipe
DEPS_python_psycopg2=(python postgres python_packages python_scipy)

# url of the package
URL_python_psycopg2=

# md5 of the package
MD5_python_psycopg2=

# default build path
BUILD_python_psycopg2=$BUILD_PATH/python_psycopg2/v${VERSION_python_psycopg2}

# default recipe path
RECIPE_python_psycopg2=$RECIPES_PATH/python_psycopg2

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_psycopg2() {
    try mkdir -p $BUILD_python_psycopg2
    cd $BUILD_python_psycopg2

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_python_psycopg2() {
    # If lib is newer than the sourcecode skip build
    if python_package_installed psycopg2; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_python_psycopg2() {
    try cd $BUILD_python_psycopg2
    push_env

    DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP_NO_BINARY psycopg2==${VERSION_python_psycopg2}

    pop_env
}

# function called after all the compile have been done
function postbuild_python_psycopg2() {
    if ! python_package_installed_verbose psycopg2; then
        error "Missing python package psycopg2"
    fi
}

# function to append information to config file
function add_config_info_python_psycopg2() {
    append_to_config_file "# python_psycopg2-${VERSION_python_psycopg2}: ${DESC_python_psycopg2}"
    append_to_config_file "export VERSION_python_psycopg2=${VERSION_python_psycopg2}"
}
