#!/bin/bash

DESC_python_qscintilla="QScintilla package for python"

# version of your package
# keep in SYNC with qscintilla receipt
VERSION_python_qscintilla=2.14.1

# dependencies of this recipe
# depends on PyQt5
DEPS_python_qscintilla=(
    python
    qscintilla
    python_sip
    python_pyqt6
    python_packages
)

# url of the package
URL_python_qscintilla=https://www.riverbankcomputing.com/static/Downloads/QScintilla/${VERSION_python_qscintilla}/QScintilla_src-${VERSION_python_qscintilla}.tar.gz

# md5 of the package
MD5_python_qscintilla=9c9e3803e4371ebbb218682e8596af5d

# default build path
BUILD_python_qscintilla=$BUILD_PATH/python_qscintilla/$(get_directory $URL_python_qscintilla)

# default recipe path
RECIPE_python_qscintilla=$RECIPES_PATH/python_qscintilla

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_qscintilla() {
    cd $BUILD_python_qscintilla

    # check marker
    if [ -f .patched ]; then
        return
    fi

    # without QtWidgets it cannot compile with
    # fatal error: 'QAbstractScrollArea' file not found
    # try ${SED} "s;# Work around QTBUG-39300.;pro.write('QT += widgets printsupport\\\n');g" Python/configure.py

    touch .patched
}

function shouldbuild_python_qscintilla() {
    # If lib is newer than the sourcecode skip build
    if python_package_installed PyQt5.Qsci; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_python_qscintilla() {
    try rsync -a $BUILD_python_qscintilla/ $BUILD_PATH/python_qscintilla/build-$ARCH/
    try cd $BUILD_PATH/python_qscintilla/build-$ARCH
    push_env

    # build python
    cd Python
    mkdir -p ${STAGE_PATH}/share/sip/PyQt6/Qsci

    try $STAGE_PATH/bin/sip-install \
        --target-dir ${STAGE_PATH}/lib/python${VERSION_major_python}/site-packages \
        --api-dir ${STAGE_PATH}/qsci \
        --qsci-features-dir $STAGE_PATH/data/mkspecs/features/ \
        --qsci-include-dir ${STAGE_PATH}/include \
        --qsci-library-dir ${STAGE_PATH}/lib \
        --qmake-setting "QMAKE_RPATHDIR += ${STAGE_PATH}/lib" \
        --spec ${QSPEC} \
        --verbose

    try install_name_tool -add_rpath "${STAGE_PATH}/lib" $QGIS_SITE_PACKAGES_PATH/PyQt6/Qsci.so

    pop_env
}

# function called after all the compile have been done
function postbuild_python_qscintilla() {
    if ! python_package_installed_verbose PyQt6.Qsci; then
        error "Missing python package qsci"
    fi
}

# function to append information to config file
function add_config_info_python_qscintilla() {
    append_to_config_file "# python_qscintilla-${VERSION_python_qscintilla}: ${DESC_python_qscintilla}"
    append_to_config_file "export VERSION_python_qscintilla=${VERSION_python_qscintilla}"
}
