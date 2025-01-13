#!/bin/bash

DESC_spatialite="SpatiaLite database"

# version of your package
VERSION_spatialite=5.1.0
LINK_spatialite=libspatialite.8.dylib

# dependencies of this recipe
DEPS_spatialite=(proj geos freexl libxml2 rttopo minizip)

# url of the package
URL_spatialite=http://www.gaia-gis.it/gaia-sins/libspatialite-sources/libspatialite-${VERSION_spatialite}.tar.gz

# md5 of the package
MD5_spatialite=2db597114bd6ee20db93de3984fd116c

# default build path
BUILD_spatialite=$BUILD_PATH/spatialite/$(get_directory $URL_spatialite)

# default recipe path
RECIPE_spatialite=$RECIPES_PATH/spatialite

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_spatialite() {
    cd $BUILD_spatialite

    # check marker
    if [ -f .patched ]; then
        return
    fi

    patch_configure_file configure

    touch .patched
}

function shouldbuild_spatialite() {
    # If lib is newer than the sourcecode skip build
    if [ ${STAGE_PATH}/lib/$LINK_spatialite -nt $BUILD_spatialite/.patched ]; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_spatialite() {
    try rsync -a $BUILD_spatialite/ $BUILD_PATH/spatialite/build-$ARCH/
    try cd $BUILD_PATH/spatialite/build-$ARCH
    push_env

    try ${CONFIGURE} \
        --enable-geocallbacks \
        --disable-dependency-tracking

    check_file_configuration config.status
    try $MAKESMP
    try $MAKESMP install

    pop_env
}

# function called after all the compile have been done
function postbuild_spatialite() {
    verify_binary lib/$LINK_spatialite
    verify_binary lib/mod_spatialite.dylib
}

# function to append information to config file
function add_config_info_spatialite() {
    append_to_config_file "# spatialite-${VERSION_spatialite}: ${DESC_spatialite}"
    append_to_config_file "export VERSION_spatialite=${VERSION_spatialite}"
    append_to_config_file "export LINK_spatialite=${LINK_spatialite}"
}
