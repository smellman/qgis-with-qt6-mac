#!/bin/bash

DESC_gettext="gettext"

# version of your package
VERSION_gettext=0.23
LINK_libintl=libintl.8.dylib

# dependencies of this recipe
DEPS_gettext=(libcurl libxml2 libunistring)

# url of the package
URL_gettext=https://ftp.gnu.org/pub/gnu/gettext/gettext-$VERSION_gettext.tar.gz

# md5 of the package
MD5_gettext=5668c76db1c89bc802698a917229560d

# default build path
BUILD_gettext=$BUILD_PATH/gettext/$(get_directory $URL_gettext)

# default recipe path
RECIPE_gettext=$RECIPES_PATH/gettext

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_gettext() {
    cd $BUILD_gettext

    # check marker
    if [ -f .patched ]; then
        return
    fi

    patch_configure_file configure

    touch .patched
}

function shouldbuild_gettext() {
    # If lib is newer than the sourcecode skip build
    if [ ${STAGE_PATH}/bin/ggettextize -nt $BUILD_gettext/.patched ]; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_gettext() {
    try rsync -a $BUILD_gettext/ $BUILD_PATH/gettext/build-$ARCH/
    try cd $BUILD_PATH/gettext/build-$ARCH
    push_env

    # https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/g/gettext.rb#L29
    export am_cv_func_iconv_works=yes

    try ${CONFIGURE} \
        --disable-debug \
        --program-prefix=g \
        --with-libunistring-prefix=${STAGE_PATH} \
        --disable-silent-rules \
        --with-included-glib \
        --with-included-libcroco \
        --with-emacs \
        --disable-java \
        --disable-csharp \
        --without-git \
        --without-cvs \
        --without-xz \
        --with-included-gettext

    check_file_configuration config.status
    try make
    try make install # Don't use smp here

    pop_env
}

# function called after all the compile have been done
function postbuild_gettext() {
    verify_binary lib/$LINK_libintl
    verify_binary lib/libgettextlib.dylib
}

# function to append information to config file
function add_config_info_gettext() {
    append_to_config_file "# gettext-${VERSION_gettext}: ${DESC_gettext}"
    append_to_config_file "export VERSION_gettext=${VERSION_gettext}"
    append_to_config_file "export LINK_libintl=${LINK_libintl}"
}
