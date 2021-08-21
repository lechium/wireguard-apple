#!/bin/sh
# This uses the latest available iOS SDK, which is recommended.
# To select a specific SDK, run 'xcodebuild -showsdks'
# to see the available SDKs and replace iphoneos with one of them.

SDK=appletvos
SDK_PATH=`/usr/bin/xcrun --sdk $SDK --show-sdk-path`
#export IPHONEOS_DEPLOYMENT_TARGET=6.1
# cmd/cgo doesn't support llvm-gcc-4.2, so we have to use clang.
echo $SDK_PATH
CLANG=`/usr/bin/xcrun --sdk $SDK --find clang`
exec $CLANG -arch arm64 -isysroot $SDK_PATH "$@"
