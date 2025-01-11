#!/bin/bash

# Pa
DESC_python_packages="Common packages for python (pre)"

# version of your package (set in config.conf)
VERSION_python_packages=${VERSION_python}

# dependencies of this recipe
DEPS_python_packages=(python python_sip python_pyqt6 little_cms2 libyaml)

# url of the package
URL_python_packages=

# md5 of the package
MD5_python_packages=

# default build path
BUILD_python_packages=$BUILD_PATH/python_packages/v${VERSION_python_packages}

# default recipe path
RECIPE_python_packages=$RECIPES_PATH/python_packages

# requirements
# ORDER matters!
REQUIREMENTS_python_packages=(
    six==1.17.0
    python-dateutil==2.9.0.post0
    cython==3.0.11
    decorator==5.1.1
    coverage==7.6.10
    nose2==0.15.1
    certifi==2024.12.14
    chardet==5.2.0
    cycler==0.12.1
    exifread==3.0.0
    funcsigs==1.0.2
    future==1.0.0
    httplib2==0.22.0
    idna==3.109
    ipython_genutils==0.2.0
    markupsafe==3.0.2
    jinja2==3.1.5
    attrs==24.3.0
    pyrsistent==0.20.0
    jsonschema==4.23.0
    traitlets==5.14.3
    jupyter-core==5.7.2
    kiwisolver==1.4.8
    mock==5.1.0
    nbformat==5.10.4
    networkx==3.4.2
    oauthlib==3.2.2
    pbr==6.1.0
    ply==3.11
    pygments==2.19.1
    pyparsing==3.2.1
    pypubsub==4.0.3
    pytz==2024.2
    pyyaml==6.0.2
    urllib3==2.3.0
    requests==2.32.3
    retrying==1.3.4
    simplejson==3.19.3
    termcolor==2.5.0
    lxml==5.3.0
    tools==0.1.9
    xlrd==2.0.1
    xlwt==1.3.0
    joblib==1.4.2
    threadpoolctl==3.5.0
    cryptography==44.0
    cffi==1.17.1
    pycparser==2.22
    pyopenssl==24.3.0
    giddy==2.3.6
    inequality==1.0.1
    pointpats==2.5.1
    spaghetti==1.7.6
    mgwr==2.2.1
    spglm==1.1.0
    spint==1.0.7
    spvcm==0.3.0
    mapclassify==2.8.1
    iniconfig==2.0.0
    more-itertools==10.5.0
    packaging==24.2
    pluggy==1.5.0
    py==1.11.0
    toml==0.10.2
    pytest==8.3.4
    pytest-cov==6.0.0
    beautifulsoup4==4.12.3
    Sphinx==8.1.3
    quantecon==0.7.2
    tqdm==4.67.1
    seaborn==0.13.2
    click==8.1.8
    click-plugins==1.1.1
    cligj==0.7.2
    munch==4.0.0
    appdirs==1.4.4
    distlib==0.3.9
    filelock==3.16.1
    pipenv==2024.4.0
    virtualenv==20.28.1
    virtualenv-clone==0.5.7
    importlib-metadata==8.5.0
    zipp==3.21.0
    rasterstats==0.20.0
    clipboard==0.0.4
    pyperclip==1.9.0
    pyvenv==0.2.2
    snuggs==1.4.7
    affine==2.4.0
)

# pyodbc build may fail
REQUIREMENTS_python_packages_without_build=(
    pyodbc==5.2.0
    plotly==5.24.1
    access==1.1.9
    esda==2.6.0
    segregation==2.5.1
    spreg==1.8.1
    tobler==0.12.0
    splot==1.1.7
)

IMPORTS_python_packages=(
    six
    requests
    dateutil
    yaml
    affine
)

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_packages() {
    try mkdir -p $BUILD_python_packages
    cd $BUILD_python_packages

    # check marker
    if [ -f .patched ]; then
        return
    fi

    touch .patched
}

function shouldbuild_python_packages() {
    if python_package_installed affine; then
        DO_BUILD=0
    fi
}

# function called to build the source code
function build_python_packages() {
    try mkdir -p $BUILD_PATH/python_packages/build-$ARCH
    try cd $BUILD_PATH/python_packages/build-$ARCH

    push_env

    export LDFLAGS="-L${STAGE_PATH}/unixodbc/lib"
    export CPPFLAGS="-I${STAGE_PATH}/unixodbc/include"
    for i in ${REQUIREMENTS_python_packages_without_build[*]}
    do
        info "Installing python_packages package $i without build"
        DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP install $i
    done
    unset LDFLAGS
    unset CPPFLAGS

    for i in ${REQUIREMENTS_python_packages[*]}
    do
        info "Installing python_packages package $i"
        # build_ext sometimes tries to dlopen the libraries
        # to determine the library version
        # this does not force --no-binary all strictly
        DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP_NO_BINARY install $i
    done

    pop_env
}

# function called after all the compile have been done
function postbuild_python_packages() {
    for i in ${IMPORTS_python_packages[*]}
    do
        if ! python_package_installed_verbose $i ; then
            error "Missing python package $i"
        fi
    done
}

# function to append information to config file
function add_config_info_python_packages() {
    append_to_config_file "# python_packages-${VERSION_python_package}: ${DESC_python_package}"
    for i in ${REQUIREMENTS_python_packages[*]}
    do
        arr=(${i//==/ })
        append_to_config_file "export VERSION_python_packages_${arr[0]//-/_}=${arr[1]}"
    done
}
