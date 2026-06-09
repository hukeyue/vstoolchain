#!/bin/bash
set -x
set -e

MACHINE=$(uname -m)

WITH_CPU=${WITH_CPU:-${MACHINE}}

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

cd ~/abseil-cpp

BUILD_DIR=build-msvc-$WITH_CPU-dynamic
rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR

LLVM_PATH=$HOME/yass-develop/third_party/llvm-build/Release+Asserts
LLVM_PATH=$HOME/clang+llvm-22.1.7-arm64-apple-darwin20.1.0
cmake -G Ninja \
   -DCMAKE_CXX_STANDARD=20 -DCMAKE_CXX_STANDARD_REQUIRED=on \
   -DABSL_ENABLE_INSTALL=off \
   -DBUILD_SHARED_LIBS=on \
   -DABSL_MSVC_STATIC_RUNTIME=off \
   -DCMAKE_BUILD_TYPE=Release \
   -DCMAKE_TOOLCHAIN_FILE=$HOME/vstoolchain/cmake/platforms/WinMsvc.cmake \
   -DHOST_ARCH=$WITH_CPU \
   -DCMAKE_RC_COMPILER=$HOME/vstoolchain/llvm-rc \
   -DCMAKE_MT=$HOME/vstoolchain/llvm-mt \
   -DCMAKE_NM=$HOME/vstoolchain/llvm-nm \
   -DLLVM_NATIVE_TOOLCHAIN=$LLVM_PATH \
   "-DMSVC_BASE=$HOME/vstoolchain/VC/Tools/MSVC/14.50.35717" \
   "-DWINSDK_BASE=$HOME/vstoolchain/Windows_Kits/10" \
   -DWINSDK_VER=10.0.26100.0 \
   ..

#cd winsdk_lib_symlinks
#ln -sf $HOME/vstoolchain/VC/Tools/MSVC/14.29.30133/lib/$WITH_CPU/libcmt.lib LIBCMT.lib
#ln -sf $HOME/vstoolchain/VC/Tools/MSVC/14.29.30133/lib/$WITH_CPU/oldnames.lib OLDNAMES.lib
