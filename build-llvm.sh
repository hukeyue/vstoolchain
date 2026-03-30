#!/bin/bash
set -x
set -e

WITH_CPU=${WITH_CPU:-x86_64}

case "$WITH_CPU" in
  x86|i586|i686)
    WITH_CPU="x86"
    ;;
  x86_64)
    WITH_CPU="x64"
    ;;
  arch64|arm64)
    WITH_CPU="arm64"
    ;;
esac

BUILD_DIR="$HOME/llvm-msvc-build-$WITH_CPU"
#rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

LLVM_PATH=$HOME/clang+llvm-20.1.8-arm64-apple-darwin20.1.0
cmake -G Ninja \
   -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=on \
   -DLLVM_DEFAULT_TARGET_TRIPLE="$WITH_CPU-windows-msvc" \
   -DCMAKE_OSX_DEPLOYMENT_TARGET=11.0 \
   -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
   -DLLVM_ENABLE_PROJECTS="example" \
   -DLLVM_ENABLE_RUNTIMES="" \
   -DMSVC_CRT_LINKAGE=dynamic \
   -DCMAKE_TOOLCHAIN_FILE=$HOME/vstoolchain/WinMsvc.cmake \
   -DHOST_ARCH=$WITH_CPU \
   -DCMAKE_RC_COMPILER=$HOME/vstoolchain/llvm-rc \
   -DCMAKE_MT=$HOME/vstoolchain/llvm-mt \
   "-DLLVM_NATIVE_TOOLCHAIN=$LLVM_PATH" \
   "-DMSVC_BASE=$HOME/vstoolchain/VC/Tools/MSVC/14.50.35717" \
   "-DWINSDK_BASE=$HOME/vstoolchain/Windows Kits/10" \
   -DWINSDK_VER=10.0.26100.0 \
   ~/llvm-project/llvm

#cd winsdk_lib_symlinks
#ln -sf $HOME/vstoolchain/VC/Tools/MSVC/14.29.30133/lib/$WITH_CPU/libcmt.lib LIBCMT.lib
#ln -sf $HOME/vstoolchain/VC/Tools/MSVC/14.29.30133/lib/$WITH_CPU/oldnames.lib OLDNAMES.lib
