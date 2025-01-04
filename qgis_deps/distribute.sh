#!/usr/bin/env bash

# set -x

function pop_env() {
    info "Leaving build environment"

    export PATH=$OLD_PATH
    export CFLAGS=$OLD_CFLAGS
    export CXXFLAGS=$OLD_CXXFLAGS
    export LDFLAGS=$OLD_LDFLAGS
    export CC=$OLD_CC
    export CXX=$OLD_CXX
    export MAKESMP=$OLD_MAKESMP
    export NINJA=$OLD_NINJA
    export MAKE=$OLD_MAKE
    export LD=$OLD_LD
    export CMAKE=$OLD_CMAKE
    export CONFIGURE=$OLD_CONFIGURE
    export INCLUDE=$OLD_INCLUDE
    export LIB_DIR=$OLD_LIB_DIR
    export LIB=$OLD_LIB
    export SYSROOT=$OLD_SYSROOT
    export PYTHON=$OLD_PYTHON
    export DYLD_LIBRARY_PATH=$OLD_DYLD_LIBRARY_PATH
    export DYLD_FALLBACK_LIBRARY_PATH=OLD_DYLD_FALLBACK_LIBRARY_PATH
    export LD_LIBRARY_PATH=$OLD_LD_LIBRARY_PATH
    export PIP=$OLD_PIP
    export QSPEC=$OLD_QSPEC
    export PKG_CONFIG_PATH=$OLD_PKG_CONFIG_PATH
    unset DYLD_INSERT_LIBRARIES
}

#########################################################################################################
echo "Loading configuration"
#########################################################################################################

XCODE_DEVELOPER="$(xcode-select -print-path)"
CORES=$(sysctl -n hw.ncpu)
export CORES=$CORES
ARCH=arm64
DO_CLEAN_BUILD=0
DO_SET_X=0
DEBUG=0

# Load configuration
if (( $# < 1 )); then
    echo "distribute: $0 <path/to>/config/<my>.conf ...."
    exit 1
fi
CONFIG_FILE=$1
if [ ! -f "$CONFIG_FILE" ]; then
  error "invalid config file (1st argument) $CONFIG_FILE"
fi
shift
source $CONFIG_FILE

# override error function to use pop_env
function error() {
    MSG="$CRED"$@"$CRESET"
    pop_env
    echo -e $MSG;
    exit 1
}

