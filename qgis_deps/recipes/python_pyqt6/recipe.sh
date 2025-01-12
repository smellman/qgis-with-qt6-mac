#!/bin/bash

DESC_python_pyqt6="PyQt6 package for python"

# version of your package
VERSION_python_pyqt6=6.8.0

# dependencies of this recipe
DEPS_python_pyqt6=(python python_sip qscintilla python_pyqt_builder)

# url of the package
URL_python_pyqt6=https://files.pythonhosted.org/packages/e9/0a/accbebed526158ab2aedd5c84d238159754bd99f481082b3fe7f374c6a3b/PyQt6-${VERSION_python_pyqt6}.tar.gz

# md5 of the package
MD5_python_pyqt6=cd113aee9158c2dda675ac30f7822e28

# default build path
BUILD_python_pyqt6=$BUILD_PATH/python_pyqt6/$(get_directory $URL_python_pyqt6)

# default recipe path
RECIPE_python_pyqt6=$RECIPES_PATH/python_pyqt6

# function fix_python_pyqt6_paths() {
#     # these are sh scripts that calls plain python{VERSION_major_python}
#     # so when on path there is homebrew python or other
#     # it fails
#     # targets=(
#     #     bin/pylupdate6
#     #     bin/pyrcc6
#     #     bin/pyuic6
#     # )

#     # for i in ${targets[*]}
#     # do
#     #     try ${SED} "s;exec ./python${VERSION_major_python}.${VERSION_minor_python};exec $STAGE_PATH/bin/python${VERSION_major_python}.${VERSION_minor_python};g" $STAGE_PATH/$i
#     #     try ${SED} "s;exec python${VERSION_major_python}.${VERSION_minor_python};exec $STAGE_PATH/bin/python${VERSION_major_python}.${VERSION_minor_python};g" $STAGE_PATH/$i

#     #     try ${SED} "s;exec ./python${VERSION_major_python};exec $STAGE_PATH/bin/python${VERSION_major_python};g" $STAGE_PATH/$i
#     #     try ${SED} "s;exec python${VERSION_major_python};exec $STAGE_PATH/bin/python${VERSION_major_python};g" $STAGE_PATH/$i
#     #     rm -f $STAGE_PATH/$i.orig
#     # done

#     echo ${REPL}
# }

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_pyqt6() {
    try mkdir -p $BUILD_python_pyqt6
    cd $BUILD_python_pyqt6

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_python_pyqt6() {
    if python_package_installed PyQt6.QtCore; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_python_pyqt6() {
    try rsync -a $BUILD_python_pyqt6/ $BUILD_PATH/python_pyqt6/build-$ARCH/
    try cd $BUILD_PATH/python_pyqt6/build-$ARCH

    push_env

    # --qmake-setting 'QT.webkit.VERSION = 5.212.0' \
    # --qmake-setting 'QT.webkit.MAJOR_VERSION = 5' \
    # --qmake-setting 'QT.webkit.MINOR_VERSION = 212' \
    # --qmake-setting 'QT.webkit.PATCH_VERSION = 0' \
    # --qmake-setting 'QT.webkit.name = QtWebKit' \
    # --qmake-setting 'QT.webkit.module = QtWebKit' \
    # --qmake-setting 'QT.webkit.DEFINES = QT_WEBKIT_LIB' \
    # --qmake-setting "QT.webkit.includes = \"${STAGE_PATH}/lib/QtWebKit.framework/Headers\" \"${STAGE_PATH}/\"" \
    # --qmake-setting 'QT.webkit.private_includes =' \
    # --qmake-setting "QT.webkit.libs = \"${STAGE_PATH}/lib\"" \
    # --qmake-setting "QT.webkit.rpath = \"${STAGE_PATH}/lib\"" \
    # --qmake-setting 'QT.webkit.depends = core gui network' \
    # --qmake-setting 'QT.webkit.run_depends = multimedia sensors positioning qml quick core_private gui_private' \
    # --qmake-setting "QT.webkit.bins = ${STAGE_PATH}/bin" \
    # --qmake-setting 'QT.webkit.libexec =' \
    # --qmake-setting 'QT.webkit.plugins =' \
    # --qmake-setting 'QT.webkit.imports =' \
    # --qmake-setting 'QT.webkit.qml =' \
    # --qmake-setting "QT.webkit.frameworks = ${STAGE_PATH}/lib" \
    # --qmake-setting 'QT.webkit.module_config = v2 lib_bundle' \
    # --qmake-setting 'QT_MODULES += webkit' \
    # --qmake-setting 'QMAKE_LIBS_PRIVATE += ' \
    # --qmake-setting "QMAKE_RPATHDIR += ${STAGE_PATH}/lib" \
    # --qmake-setting 'QT.webkitwidgets.VERSION = 5.212.0' \
    # --qmake-setting 'QT.webkitwidgets.MAJOR_VERSION = 5' \
    # --qmake-setting 'QT.webkitwidgets.MINOR_VERSION = 212' \
    # --qmake-setting 'QT.webkitwidgets.PATCH_VERSION = 0' \
    # --qmake-setting 'QT.webkitwidgets.name = QtWebKitWidgets' \
    # --qmake-setting 'QT.webkitwidgets.module = QtWebKitWidgets' \
    # --qmake-setting 'QT.webkitwidgets.DEFINES = QT_WEBKITWIDGETS_LIB' \
    # --qmake-setting "QT.webkitwidgets.includes = \"${STAGE_PATH}/lib/QtWebKitWidgets.framework/Headers\" \"${STAGE_PATH}/\"" \
    # --qmake-setting 'QT.webkitwidgets.private_includes =' \
    # --qmake-setting "QT.webkitwidgets.libs = \"${STAGE_PATH}/lib\"" \
    # --qmake-setting "QT.webkitwidgets.rpath = \"${STAGE_PATH}/lib\"" \
    # --qmake-setting 'QT.webkitwidgets.depends = core gui network widgets webkit' \
    # --qmake-setting 'QT.webkitwidgets.run_depends = multimedia sensors positioning qml quick core_private gui_private widgets_private opengl printsupport multimediawidgets' \
    # --qmake-setting "QT.webkitwidgets.bins = ${STAGE_PATH}/bin" \
    # --qmake-setting 'QT.webkitwidgets.libexec =' \
    # --qmake-setting 'QT.webkitwidgets.plugins =' \
    # --qmake-setting 'QT.webkitwidgets.imports =' \
    # --qmake-setting 'QT.webkitwidgets.qml =' \
    # --qmake-setting "QT.webkitwidgets.frameworks = ${STAGE_PATH}/lib" \
    # --qmake-setting 'QT.webkitwidgets.module_config = v2 lib_bundle' \
    # --qmake-setting 'QT_MODULES += webkitwidgets' \

    try $STAGE_PATH/bin/sip-install \
        --confirm-license \
        --target-dir ${STAGE_PATH}/lib/python${VERSION_major_python}/site-packages \
        --scripts-dir ${STAGE_PATH}/bin \
        --disable QAxContainer \
        --disable QtX11Extras \
        --disable QtWinExtras \
        --disable Enginio \
        --jobs $CORES \
        --verbose \
        --qmake-setting 'QMAKE_LIBS_PRIVATE += ' \
        --qmake-setting "QMAKE_RPATHDIR += ${STAGE_PATH}/lib"

    # added depencencies
    # ref: https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/p/pyqt.rb
    try curl -o pyqt6_sip-13.9.1.tar.gz https://files.pythonhosted.org/packages/2a/e4/f39ca1fd6de7d4823d964a3ec33e85b6f51a9c2a7a1e95956b7a92c8acc9/pyqt6_sip-13.9.1.tar.gz
    try tar zxf pyqt6_sip-13.9.1.tar.gz
    try cd pyqt6_sip-13.9.1
    try $PYTHON setup.py install
    try cd ..
  
    try curl -o PyQt6_3D-${VERSION_python_pyqt6}.tar.gz https://files.pythonhosted.org/packages/13/15/4eef4a5087e4af01638baee8fd1c22e97fce2eb593e73c7f1cf9f59dffa9/PyQt6_3D-${VERSION_python_pyqt6}.tar.gz
    try tar zxf PyQt6_3D-${VERSION_python_pyqt6}.tar.gz
    try cd PyQt6_3D-${VERSION_python_pyqt6}
    try sed -i '' -e "s|\[tool.sip.project\]|\[tool.sip.project\]\nsip-include-dirs = \[\"${STAGE_PATH}/lib/python${VERSION_major_python}/site-packages/PyQt6/bindings\"\]|g" pyproject.toml
    try $STAGE_PATH/bin/sip-install \
      --target-dir ${STAGE_PATH}/lib/python${VERSION_major_python}/site-packages \
      --verbose
    try cd ..

    try curl -o PyQt6_Charts-${VERSION_python_pyqt6}.tar.gz https://files.pythonhosted.org/packages/94/51/d37e1527dcf0e2bf5bfdba4200c2297a4224e299d79c4d4cfbe1a363e01b/PyQt6_Charts-${VERSION_python_pyqt6}.tar.gz
    try tar zxf PyQt6_Charts-${VERSION_python_pyqt6}.tar.gz
    try cd PyQt6_Charts-${VERSION_python_pyqt6}
    try sed -i '' -e "s|\[tool.sip.project\]|\[tool.sip.project\]\nsip-include-dirs = \[\"${STAGE_PATH}/lib/python${VERSION_major_python}/site-packages/PyQt6/bindings\"\]|g" pyproject.toml
    try $STAGE_PATH/bin/sip-install \
        --target-dir ${STAGE_PATH}/lib/python${VERSION_major_python}/site-packages \
        --verbose
    try cd ..

    try curl -o PyQt6_DataVisualization-${VERSION_python_pyqt6}.tar.gz https://files.pythonhosted.org/packages/3c/26/9006f1ff80fe800df3ea1b6f26bf61323e19acede5a3e55a115908638689/PyQt6_DataVisualization-${VERSION_python_pyqt6}.tar.gz
    try tar zxf PyQt6_DataVisualization-${VERSION_python_pyqt6}.tar.gz
    try cd PyQt6_DataVisualization-${VERSION_python_pyqt6}
    try sed -i '' -e "s|\[tool.sip.project\]|\[tool.sip.project\]\nsip-include-dirs = \[\"${STAGE_PATH}/lib/python${VERSION_major_python}/site-packages/PyQt6/bindings\"\]|g" pyproject.toml
    try $STAGE_PATH/bin/sip-install \
        --target-dir ${STAGE_PATH}/lib/python${VERSION_major_python}/site-packages \
        --verbose
    try cd ..

    try curl -o PyQt6_NetworkAuth-${VERSION_python_pyqt6}.tar.gz https://files.pythonhosted.org/packages/ee/79/3d67110608e7e6b55c501359699826dd861c21c668ccc9a8fbc99bfc528b/PyQt6_NetworkAuth-${VERSION_python_pyqt6}.tar.gz
    try tar zxf PyQt6_NetworkAuth-${VERSION_python_pyqt6}.tar.gz
    try cd PyQt6_NetworkAuth-${VERSION_python_pyqt6}
    try sed -i '' -e "s|\[tool.sip.project\]|\[tool.sip.project\]\nsip-include-dirs = \[\"${STAGE_PATH}/lib/python${VERSION_major_python}/site-packages/PyQt6/bindings\"\]|g" pyproject.toml
    try $STAGE_PATH/bin/sip-install \
        --target-dir ${STAGE_PATH}/lib/python${VERSION_major_python}/site-packages \
        --verbose
    try cd ..

    try curl -o PyQt6_WebEngine-${VERSION_python_pyqt6}.tar.gz https://files.pythonhosted.org/packages/cd/c8/cadaa950eaf97f29e48c435e274ea5a81c051e745a3e2f5d9d994b7a6cda/PyQt6_WebEngine-${VERSION_python_pyqt6}.tar.gz
    try tar zxf PyQt6_WebEngine-${VERSION_python_pyqt6}.tar.gz
    try cd PyQt6_WebEngine-${VERSION_python_pyqt6}
    try sed -i '' -e "s|\[tool.sip.project\]|\[tool.sip.project\]\nsip-include-dirs = \[\"${STAGE_PATH}/lib/python${VERSION_major_python}/site-packages/PyQt6/bindings\"\]|g" pyproject.toml
    try $STAGE_PATH/bin/sip-install \
        --target-dir ${STAGE_PATH}/lib/python${VERSION_major_python}/site-packages \
        --verbose
    try cd ..

    # fix_python_pyqt6_paths
    pop_env
}

function postbuild_python_pyqt6() {
    if ! python_package_installed_verbose PyQt6.QtCore; then
        error "Missing python package PyQt6.QtCore"
    fi

    if ! python_package_installed_verbose PyQt6.QtWebEngineCore; then
        error "Missing python package PyQt6.QtWebEngineCore"
    fi
}

# function to append information to config file
function add_config_info_python_pyqt6() {
  append_to_config_file "# python_pyqt6-${VERSION_python_pyqt6}: ${DESC_python_pyqt6}"
  append_to_config_file "export VERSION_python_pyqt6=${VERSION_python_pyqt6}"
}
