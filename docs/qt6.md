# Build and install Qt6

## Install dependencies

Install Xcode from the App Store.

```bash
brew install cmake ninja python@3.12 wget
```

## Build and install Qt6 from source

```bash
cd qt6
./build_and_install_qt6.sh
```

Qt6 will be installed in `/opt/Qt/$QT_VERSION`.
Also the script will skip the installation of Qt6
if it is already installed.

## Clean up build files

```bash
cd $HOME/tmp/src
rm -fr qt-*
```
