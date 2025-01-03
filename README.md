# [QGIS with Qt6 for macOS Apple Silicon](https://github.com/smellman/qgis-with-qt6-mac)

This repository is a collection of scripts and
instructions to build QGIS with Qt6 on macOS.

## Motivation

I tried to build QGIS with Qt5 on macOS.
I have been using[smellman's QGIS-Mac-Packager dev-deps-0.10.0 branch](https://github.com/smellman/QGIS-Mac-Packager/tree/dev-deps-0.10.0).
However, current Xcode does not support [Qt5 5.15.2](https://download.qgis.org/downloads/macos/deps/).
Also, I tried to build Qt5 from source, but I failed.

So, I try to build QGIS with Qt6 on macOS.

## Targets

- macOS 15.2 (Sequoia) and arm64 (Apple Silicon)
- Xcode 16.2
- Homebrew

## Requirements

- Xcode 16.2
- Python 3.12
- CMake
- Ninja
- wget
