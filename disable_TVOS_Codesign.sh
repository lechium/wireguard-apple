#!/bin/bash
EQUAL=0
GT=1
LT=2
bold=$(tput bold)
normal=$(tput sgr0)

BREW=$(which brew)

brew_install_check() {
	echo -e "${bold} Brew is missing and is needed to install ldid2 and dpkg, would you like to install it? [y/n]: ${normal}\n"
	read -r brewcheck
	if [ "$brewcheck" == 'y' -o "$brewcheck" == 'Y' ]; then
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
		continue_checks
	elif [ "$brewcheck" == 'N' -o "$brewcheck" == 'n' ]; then
		echo "you will not be able to sucessfully build and install the tvOS target without dpkg & ldid2!"
		do_it
	fi 
	return 1
}

PLUTIL=$(which plutil)

do_it() {
    SDK_SETTINGS=$(xcrun --show-sdk-path --sdk appletvos)/SDKSettings.plist
    #echo $SDK_SETTINGS
    if [ -e $SDK_SETTINGS ]; then
	$PLUTIL -replace DefaultProperties.ENTITLEMENTS_REQUIRED -string "NO" $SDK_SETTINGS
	$PLUTIL -replace DefaultProperties.CODE_SIGNING_REQUIRED -string "NO" $SDK_SETTINGS
#	open $SDK_SETTINGS
    else
	echo "tvOS SDK Settings not found! exiting"
	exit 1
    fi
}

finish_task() {
    do_it
}

finish_checks() {
    DPKG=$(which dpkg)
    if [ -z $DPKG ]; then
	echo "dpkg is missing, installing with brew"
	brew install dpkg
	finish_task
    else
	finish_task
    fi
}

continue_checks() {
    LDID=$(which ldid2)
    if [ -z $LDID ]; then
	echo "ldid2 is missing, installing with brew"
	brew install ldid2
	finish_checks
    else
	finish_checks
    fi
}

check_depends() {
    # see if brew exists
    if [ -z $BREW ]; then
	brew_install_check
    else
	continue_checks
    fi
}

check_depends


