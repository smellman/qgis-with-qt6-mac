#!/bin/bash

# This script builds and installs Qt6 from source on macOS arm64.

QT6_MAJOR_VERSION=6.8
QT6_MINOR_VERSION=1
QT6_VERSION=$QT6_MAJOR_VERSION.$QT6_MINOR_VERSION
QT6_SOURCE=qt-everywhere-src-$QT6_VERSION.tar.xz

# Skip if Qt6 is already installed
if [ -d /opt/Qt/$QT6_VERSION ]; then
    echo "Qt6 $QT6_VERSION is already installed."
    exit 0
fi

# Working directory
mkdir -p $HOME/tmp/src
cd $HOME/tmp/src

# Download Qt6 source code
if [ ! -f $QT6_SOURCE ]; then
    wget https://download.qt.io/official_releases/qt/$QT6_MAJOR_VERSION/$QT6_VERSION/single/$QT6_SOURCE
fi

# Extract Qt6 source code
if [ ! -d qt-everywhere-src-$QT6_VERSION ]; then
    tar -xf $QT6_SOURCE
fi

# Change directory to the Qt6 source code directory
cd qt-everywhere-src-$QT6_VERSION

# Setup python 3.12 vertual environment
python3.12 -m venv venv
source venv/bin/activate
pip install html5lib
pip install webencodings
export PYTHONPATH=venv/lib/python3.12/site-packages/

# Run the configure script
./configure -release -prefix /opt/Qt/$QT6_VERSION -- -DCMAKE_OSX_ARCHITECTURES="arm64"

# Build and install Qt6
cmake --build . --parallel
cmake --install .

# Deactivate the python 3.12 virtual environment
deactivate
