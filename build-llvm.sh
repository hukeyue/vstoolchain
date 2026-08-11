#!/bin/bash
set -x
set -e

WITH_CPU=${WITH_CPU:-x86_64}

case "$WITH_CPU" in
  x86|i586|i686)
    WITH_CPU="x86"
    TARGET_TRIPLE="i686-pc-windows-msvc"
    ;;
  x86_64)
    WITH_CPU="x64"
    TARGET_TRIPLE="x86_64-pc-windows-msvc"
    ;;
  arch64|arm64)
    WITH_CPU="arm64"
    TARGET_TRIPLE="aarch64-pc-windows-msvc"
    ;;
esac

BUILD_DIR="$HOME/llvm-msvc-build-$WITH_CPU"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

LLVM_PATH=$HOME/clang+llvm-22.1.8-arm64-apple-darwin20.1.0
cmake -G Ninja \
   -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=on \
   -DLLVM_DEFAULT_TARGET_TRIPLE="$TARGET_TRIPLE" \
   -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
   -DLLVM_BUILD_EXAMPLES=ON \
   -DLLVM_ENABLE_PROJECTS="" \
   -DLLVM_ENABLE_RUNTIMES="" \
   -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDLL \
   -DCMAKE_TOOLCHAIN_FILE=$HOME/vstoolchain/WinMsvc.cmake \
   -DHOST_ARCH=$WITH_CPU \
   -DCMAKE_RC_COMPILER=$HOME/vstoolchain/llvm-rc \
   -DCMAKE_MT=$HOME/vstoolchain/llvm-mt \
   -DCMAKE_NM=$HOME/vstoolchain/llvm-nm \
   "-DLLVM_NATIVE_TOOLCHAIN=$LLVM_PATH" \
   "-DMSVC_BASE=$HOME/vstoolchain/VC/Tools/MSVC/14.50.35717" \
   "-DWINSDK_BASE=$HOME/vstoolchain/Windows Kits/10" \
   -DWINSDK_VER=10.0.26100.0 \
   ~/llvm-project/llvm

#cd winsdk_lib_symlinks
#ln -sf $HOME/vstoolchain/VC/Tools/MSVC/14.29.30133/lib/$WITH_CPU/libcmt.lib LIBCMT.lib
#ln -sf $HOME/vstoolchain/VC/Tools/MSVC/14.29.30133/lib/$WITH_CPU/oldnames.lib OLDNAMES.lib
