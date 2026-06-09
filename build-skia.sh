#!/bin/bash
set -x
set -e

MACHINE=$(uname -m)

ARGS="skia_use_icu=true is_debug=false is_official_build=false skia_use_system_libjpeg_turbo=false skia_use_system_libpng=false skia_use_system_libwebp=false skia_use_system_expat=false skia_use_system_zlib=false"

ARGS="cc=\"clang\" cxx=\"clang++\" ar=\"llvm-ar\" $ARGS"
ARGS="clang_win=\"$HOME/clang+llvm-22.1.7-arm64-apple-darwin20.1.0\" clang_win_version=\"22\" $ARGS"
ARGS="target_cpu=\"x64\" target_os=\"win\" $ARGS"
ARGS="current_cpu=\"x64\" current_os=\"win\" $ARGS"
ARGS="win_vc=\"$HOME/vstoolchain/VC\" win_toolchain_version=\"14.50.35717\" $ARGS"
ARGS="win_sdk=\"$HOME/vstoolchain/Windows_Kits/10\" win_sdk_version=\"10.0.26100.0\" $ARGS"

cd ~/skia
#rm -rf out/win
gn gen out/win "--args=$ARGS"
