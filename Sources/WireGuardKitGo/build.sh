#!/bin/bash
# -Wl,-sectcreate,__RESTRICT,__restrict,/dev/null

SDK=appletvos
SDK_PATH=`/usr/bin/xcrun --sdk $SDK --show-sdk-path`

REAL_GOROOT=`go env GOROOT`
DESTDIR=$CONFIGURATION_BUILD_DIR
BUILDDIR=$CONFIGURATION_TEMP_DIR/wireguard-go-bridge
mkdir -p $BUILDDIR
GOROOT=$BUILDDIR/goroot
PREPARED="$GOROOT/.prepared"

clone_goroot() {
    echo "clone_goroot"
    if [ -n "$REAL_GOROOT" ]; then
        mkdir -p "$GOROOT"
        rsync -a --delete --exclude=pkg/obj/go-build "$REAL_GOROOT/" "$GOROOT/"
        cat goruntime-*.diff | patch -p1 -f -N -r- -d "$GOROOT"
        touch "$GOROOT/.prepared"
    fi
}
if [ -e "$PREPARED" ]; then
    echo "go already cloned and patched..continue"
else
    echo "cloning and patching goroot"
    clone_goroot
fi

PWD=$(pwd)

GOOS=darwin GOARCH=arm64 CC=$PWD/clangwrap.sh CXX=$PWD/clangwrap.sh CGO_CFLAGS="-isysroot $SDK_PATH -arch arm64 -I$SDK_PATH/usr/include" CGO_LDFLAGS="-isysroot $SDK_PATH -arch arm64 -L$SDK_PATH/usr/lib/" CGO_ENABLED=1 go build -ldflags=-w -trimpath -pkgdir=$GOPATH/pkg/gomobile/pkg_darwin_arm64 -tags "tag1 ios" -v -o="$DESTDIR/libwg-go.a" -buildmode c-archive
