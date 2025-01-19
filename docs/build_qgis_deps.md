# Build and install QGIS dependencies

## Prerequisites

```bash
brew install wget
brew install ninja
brew install meson
brew install llvm@18
```

## How to build QGIS dependencies

```bash
rm -fr /opt/QGIS/qgis-deps-0.10.0/build
cd qgis_deps
./qgis_deps.bash ../config/dev.conf
```
