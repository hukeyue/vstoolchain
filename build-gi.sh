#!/bin/bash

set -x
set -e
cd ~/GenshinImpactLoader
rm -rf build-msvc
mkdir -p build-msvc
cd build-msvc
LLVM_PATH=$HOME/clang+llvm-19.1.7-arm64-apple-darwin20.1.0
cmake -G Ninja \
   -DCMAKE_TOOLCHAIN_FILE=$HOME/GenshinImpactLoader/cmake/platforms/WinMsvc.cmake \
   -DCMAKE_BUILD_TYPE=Release \
   -DHOST_ARCH=x86_64 \
   -DCMAKE_RC_COMPILER=$HOME/vstoolchain/llvm-rc \
   -DCMAKE_MT=$HOME/vstoolchain/llvm-mt \
   -DLLVM_NATIVE_TOOLCHAIN=$LLVM_PATH \
   "-DMSVC_BASE=$HOME/vstoolchain/VC/Tools/MSVC/14.29.30133" \
   "-DWINSDK_BASE=$HOME/vstoolchain/Windows Kits/10" \
   -DWINSDK_VER=10.0.20348.0 \
   ..

#cd winsdk_lib_symlinks
#ln -sf $HOME/vstoolchain/VC/Tools/MSVC/14.29.30133/lib/x64/libcmt.lib LIBCMT.lib
#ln -sf $HOME/vstoolchain/VC/Tools/MSVC/14.29.30133/lib/x64/oldnames.lib OLDNAMES.lib
