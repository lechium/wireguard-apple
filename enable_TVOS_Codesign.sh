#!/bin/bash

PLUTIL=$(which plutil)

do_it() {
SDK_SETTINGS=$(xcrun --show-sdk-path --sdk appletvos)/SDKSettings.plist
    #echo $SDK_SETTINGS
    if [ -e $SDK_SETTINGS ]; then
	$PLUTIL -replace DefaultProperties.ENTITLEMENTS_REQUIRED -string "YES" $SDK_SETTINGS
	$PLUTIL -replace DefaultProperties.CODE_SIGNING_REQUIRED -string "YES" $SDK_SETTINGS
	open $SDK_SETTINGS
    else
	echo "tvOS SDK Settings not found! exiting"
	exit 1
    fi
}

if [ -e $PLUTIL ]; then
    do_it
else
    echo "plutil is required to run this script, please install using brew!"
    exit 1
fi



