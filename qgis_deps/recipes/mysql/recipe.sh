#!/bin/bash

DESC_mysql="Open source relational database management system"

# version of your package
VERSION_mysql=9.1.0
LINK_libmysqlclient=libmysqlclient.24.dylib

# dependencies of this recipe
DEPS_mysql=(
    openssl
    protobuf
    zstd
    zlib
)

# url of the package
URL_mysql=https://dev.mysql.com/get/Downloads/MySQL-9.1/mysql-${VERSION_mysql}.tar.gz

# md5 of the package
MD5_mysql=eb2c6bbd20569d2690bc7e34312f5210

# default build path
BUILD_mysql=$BUILD_PATH/mysql/$(get_directory $URL_mysql)

# default recipe path
RECIPE_mysql=$RECIPES_PATH/mysql

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_mysql() {
    cd $BUILD_mysql

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_mysql() {
    # If lib is newer than the sourcecode skip build
    if [ ${STAGE_PATH}/lib/$LINK_libmysqlclient -nt $BUILD_mysql/.patched ]; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_mysql() {
    try mkdir -p $BUILD_PATH/mysql/build-$ARCH
    try cd $BUILD_PATH/mysql/build-$ARCH
    try mkdir -p downloaded_boost
    push_env

    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    # -DDOWNLOAD_BOOST=OFF may be not needed
    BOOST_ROOT=$STAGE_PATH try ${CMAKE}  \
        -DWITHOUT_SERVER=ON \
        -DFORCE_INSOURCE_BUILD=1 \
        -DENABLED_PROFILING=OFF \
        -DCOMPILATION_COMMENT=qgis_deps \
        -DDEFAULT_CHARSET=utf8mb4 \
        -DDEFAULT_COLLATION=utf8mb4_general_ci \
        -DINSTALL_DOCDIR=share/doc/mysql \
        -DINSTALL_INCLUDEDIR=include/mysql \
        -DINSTALL_INFODIR=share/info \
        -DINSTALL_MANDIR=share/man \
        -DINSTALL_MYSQLSHAREDIR=share/mysql \
        -DINSTALL_SUPPORTFILESDIR=mysql/support-files \
        -DINSTALL_PLUGINDIR=lib/plugin \
        -DMYSQL_DATADIR=$STAGE_PATH/share/data \
        -DWITH_AUTHENTICATION_CLIENT_PLUGINS=yes \
        -DWITH_BOOST=boost \
        -DWITH_ZSTD=system \
        -DWITH_SYSTEM_LIBS_DEFAULT=TRUE \
        -DCMAKE_FIND_FRAMEWORK=LAST \
        -DWITH_EDITLINE=system \
        -DWITH_SSL=yes \
        -DWITH_PROTOBUF=system \
        -DWITH_UNIT_TESTS=OFF \
        -DENABLED_LOCAL_INFILE=1 \
        -DWITH_INNODB_MEMCACHED=ON \
        $BUILD_mysql

    check_file_configuration CMakeCache.txt

    try $NINJA
    try $NINJA install

    try fix_install_name lib/$LINK_libmysqlclient
    try install_name_tool -id $STAGE_PATH/lib/libmysqlclient.21.dylib lib/$LINK_libmysqlclient

    try rm -rf $STAGE_PATH/mysql-test
    try rm -f $STAGE_PATH/LICENCE
    try rm -f $STAGE_PATH/README
    pop_env
}

# function called after all the compile have been done
function postbuild_mysql() {
    verify_binary lib/$LINK_libmysqlclient
}

# function to append information to config file
function add_config_info_mysql() {
    append_to_config_file "# mysql-${VERSION_mysql}: ${DESC_mysql}"
    append_to_config_file "export VERSION_mysql=${VERSION_mysql}"
    append_to_config_file "export LINK_libmysqlclient=${LINK_libmysqlclient}"
}
