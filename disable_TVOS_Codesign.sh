#!/bin/bash
EQUAL=0
GT=1
LT=2
bold=$(tput bold)
normal=$(tput sgr0)
list=$(brew list)
declare -a array=()
dependencies=(
	"dpkg"
	"go"
)
has_item() {
	#	if [[ ${list[(ie)$1]} -le ${#list} ]]; then    
	if [[ ${list[*]} =~  ${1} ]]; then
		echo "has $1"
	else
		echo "doesnt have $1"
		array+="$1"
	fi 
}

install_dependencies() {
	for value in "${dependencies[@]}"
	do
		has_item $value
	done


	if [[ ${#array} -ge 1 ]]; then
		for val in "${array[@]}" 
		do
			echo brew \"${val}\" >> NewBrewfile
		done
		brew bundle --file=NewBrewfile
	fi
}

brew_install() {
	if ! command -v brew >/dev/null; then
		echo "installing homebrew ..."
		curl -fss \
			'https://raw.githubusercontent.com/homebrew/install/master/install' | ruby
	fi
	brew update --force # https://github.com/Homebrew/brew/issues/1151
	list=$(brew list)

}

brew_install_check() {
	echo -e "${bold} Brew is missing and is needed to install ldid2 and dpkg, would you like to install it? [y/n]: ${normal}\n"
	read -r brewcheck
	if [ "$brewcheck" == 'y' -o "$brewcheck" == 'Y' ]; then
		brew_install
		do_it
	elif [ "$brewcheck" == 'N' -o "$brewcheck" == 'n' ]; then
		echo "you will not be able to sucessfully build and install the tvOS target without dpkg & ldid2!"
		do_it
	fi 
	return 1
}

PLUTIL=$(which plutil)

do_it() {
	install_dependencies
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

if ! command -v brew >/dev/null; then
    brew_install
else
    do_it
fi
