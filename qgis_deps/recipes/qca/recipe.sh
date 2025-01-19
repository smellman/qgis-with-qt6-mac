#!/bin/bash

DESC_qca="Qt Cryptographic Architecture (QCA)"

# version of your package
VERSION_qca_major=2
VERSION_qca=${VERSION_qca_major}.3.9
LINK_qca=qca-qt6

# dependencies of this recipe
DEPS_qca=(openssl)

# url of the package
URL_qca=https://github.com/KDE/qca/archive/v${VERSION_qca}.tar.gz

# md5 of the package
MD5_qca=10256b5c44e9df3ffcd1f3e8d21c46fc

# default build path
BUILD_qca=$BUILD_PATH/qca/$(get_directory $URL_qca)

# default recipe path
RECIPE_qca=$RECIPES_PATH/qca

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_qca() {
    cd $BUILD_qca

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_qca() {
    # If lib is newer than the sourcecode skip build
    if [ ${STAGE_PATH}/lib/qca-qt6.framework/Versions/${VERSION_qca_major}/$LINK_qca -nt $BUILD_qca/.patched ]; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_qca() {
    try mkdir -p $BUILD_PATH/qca/build-$ARCH
    try cd $BUILD_PATH/qca/build-$ARCH
    push_env

    try ${CMAKE} \
        -DQCA_PLUGINS_INSTALL_DIR=$STAGE_PATH/qt6/plugins \
        -DBUILD_WITH_QT6=ON \
        -DBUILD_TESTS=OFF \
        -DWITH_botan_PLUGIN=NO \
        -DWITH_gcrypt_PLUGIN=NO \
        -DWITH_gnupg_PLUGIN=NO \
        -DWITH_nss_PLUGIN=NO \
        -DWITH_pkcs11_PLUGIN=NO \
        $BUILD_qca

    check_file_configuration CMakeCache.txt

    try $NINJA
    try $NINJA install

    try install_name_tool -id $STAGE_PATH/lib/qca-qt6.framework/Versions/${VERSION_qca_major}/$LINK_qca $STAGE_PATH/lib/qca-qt6.framework/Versions/${VERSION_qca_major}/$LINK_qca
    try install_name_tool -change $BUILD_PATH/qca/build-$ARCH/lib/qca-qt6.framework/Versions/${VERSION_qca_major}/$LINK_qca $STAGE_PATH/lib/qca-qt6.framework/Versions/${VERSION_qca_major}/$LINK_qca $STAGE_PATH/lib/qca-qt6.framework/Versions/${VERSION_qca_major}/$LINK_qca
    try install_name_tool -id $STAGE_PATH/lib/qca-qt6.framework/Versions/${VERSION_qca_major}/$LINK_qca $STAGE_PATH/bin/qcatool-qt6
    try install_name_tool -change $BUILD_PATH/qca/build-$ARCH/lib/qca-qt6.framework/Versions/${VERSION_qca_major}/$LINK_qca $STAGE_PATH/lib/qca-qt6.framework/Versions/${VERSION_qca_major}/$LINK_qca $STAGE_PATH/bin/qcatool-qt6
    try install_name_tool -id $STAGE_PATH/lib/qca-qt6.framework/Versions/${VERSION_qca_major}/$LINK_qca $STAGE_PATH/qt6/plugins/crypto/libqca-cyrus-sasl.dylib
    try install_name_tool -change $BUILD_PATH/qca/build-$ARCH/lib/qca-qt6.framework/Versions/${VERSION_qca_major}/$LINK_qca $STAGE_PATH/lib/qca-qt6.framework/Versions/${VERSION_qca_major}/$LINK_qca $STAGE_PATH/qt6/plugins/crypto/libqca-cyrus-sasl.dylib
    try install_name_tool -id $STAGE_PATH/lib/qca-qt6.framework/Versions/${VERSION_qca_major}/$LINK_qca $STAGE_PATH/qt6/plugins/crypto/libqca-logger.dylib
    try install_name_tool -change $BUILD_PATH/qca/build-$ARCH/lib/qca-qt6.framework/Versions/${VERSION_qca_major}/$LINK_qca $STAGE_PATH/lib/qca-qt6.framework/Versions/${VERSION_qca_major}/$LINK_qca $STAGE_PATH/qt6/plugins/crypto/libqca-logger.dylib
    try install_name_tool -id $STAGE_PATH/lib/qca-qt6.framework/Versions/${VERSION_qca_major}/$LINK_qca $STAGE_PATH/qt6/plugins/crypto/libqca-ossl.dylib
    try install_name_tool -change $BUILD_PATH/qca/build-$ARCH/lib/qca-qt6.framework/Versions/${VERSION_qca_major}/$LINK_qca $STAGE_PATH/lib/qca-qt6.framework/Versions/${VERSION_qca_major}/$LINK_qca $STAGE_PATH/qt6/plugins/crypto/libqca-ossl.dylib
    try install_name_tool -id $STAGE_PATH/lib/qca-qt6.framework/Versions/${VERSION_qca_major}/$LINK_qca $STAGE_PATH/qt6/plugins/crypto/libqca-softstore.dylib
    try install_name_tool -change $BUILD_PATH/qca/build-$ARCH/lib/qca-qt6.framework/Versions/${VERSION_qca_major}/$LINK_qca $STAGE_PATH/lib/qca-qt6.framework/Versions/${VERSION_qca_major}/$LINK_qca $STAGE_PATH/qt6/plugins/crypto/libqca-softstore.dylib
    try install_name_tool -id $STAGE_PATH/lib/qca-qt6.framework/Versions/${VERSION_qca_major}/$LINK_qca $STAGE_PATH/bin/mozcerts-qt6
    try install_name_tool -change $BUILD_PATH/qca/build-$ARCH/lib/qca-qt6.framework/Versions/${VERSION_qca_major}/$LINK_qca $STAGE_PATH/lib/qca-qt6.framework/Versions/${VERSION_qca_major}/$LINK_qca $STAGE_PATH/bin/mozcerts-qt6

    pop_env
}

# function called after all the compile have been done
function postbuild_qca() {
    verify_binary lib/qca-qt6.framework/Versions/${VERSION_qca_major}/$LINK_qca
    verify_binary bin/qcatool-qt6
}

# function to append information to config file
function add_config_info_qca() {
    append_to_config_file "# qca-${VERSION_qca}: ${DESC_qca}"
    append_to_config_file "export VERSION_qca=${VERSION_qca}"
    append_to_config_file "export LINK_qca=${LINK_qca}"
}
