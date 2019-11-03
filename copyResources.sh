#!/bin/bash

if [ "$EUID" -ne 0 ];then
    echo "This script must be run as root"
    exit 1
fi

if [[ -z $1 ]];then
	echo "Runtime version required"
	exit 1
fi

FOLDER=Font-13

if [[ -z $2 ]];then
	echo "Font must be specified"
	exit 1
fi

if [[ ! -f "${FOLDER}/${2}" ]];then
	echo "Font not found"
	exit 1
fi

FONT="${2}"
UNDERSCORE=0

EL_RUNTIME_ROOT=/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS\ ${1}.simruntime/Contents/Resources/RuntimeRoot

if (( $(echo "$1 >= 8.2" | bc -l) ));then
	LOCATION="Core"
	if (( $(echo "$1 == 8.2" | bc -l) ));then
		UNDERSCORE=1
	fi
else
	LOCATION="Cache"
fi

TOUCH="${EL_RUNTIME_ROOT}/System/Library/Fonts/${LOCATION}/installed"
TTF_2X="${EL_RUNTIME_ROOT}/System/Library/Fonts/${LOCATION}/AppleColorEmoji@2x.ttf"
TTF_2X_="${EL_RUNTIME_ROOT}/System/Library/Fonts/${LOCATION}/AppleColorEmoji_2x.ttf"
CCF_2X="${EL_RUNTIME_ROOT}/System/Library/Fonts/${LOCATION}/AppleColorEmoji@2x.ccf"
TTC_2X="${EL_RUNTIME_ROOT}/System/Library/Fonts/${LOCATION}/AppleColorEmoji@2x.ttc"
TTF="${EL_RUNTIME_ROOT}/System/Library/Fonts/${LOCATION}/AppleColorEmoji.ttf"
TTF_="${EL_RUNTIME_ROOT}/System/Library/Fonts/${LOCATION}/AppleColorEmoji_1x.ttf"
CCF="${EL_RUNTIME_ROOT}/System/Library/Fonts/${LOCATION}/AppleColorEmoji.ccf"
TTC="${EL_RUNTIME_ROOT}/System/Library/Fonts/${LOCATION}/AppleColorEmoji.ttc"

function install {
	[[ -f "${TTC_2X}" ]] && mv -v "${TTC_2X}" "${TTC_2X/.ttc/.ttc.bak}"
	[[ -f "${TTF_2X}" ]] && mv -v "${TTF_2X}" "${TTF_2X/.ttf/.ttf.bak}"
	[[ -f "${CCF_2X}" ]] && mv -v "${CCF_2X}" "${CCF_2X/.ccf/.ccf.bak}"
	[[ -f "${TTF_2X_}" ]] && mv -v "${TTF_2X_}" "${TTF_2X_/.ttf/.ttf.bak}"
	[[ -f "${TTC}" ]] && mv -v "${TTC}" "${TTC/.ttc/.ttc.bak}"
	[[ -f "${TTF}" ]] && mv -v "${TTF}" "${TTF/.ttf/.ttf.bak}"
	[[ -f "${TTF_}" ]] && mv -v "${TTF_}" "${TTF_/.ttf/.ttf.bak}"
	[[ -f "${CCF}" ]] && mv -v "${CCF}" "${CCF/.ccf/.ccf.bak}"
	if (( $(echo "$UNDERSCORE == 1" | bc -l) ));then
		FONT_="${FONT/@/_}"
		cp -v "${PWD}/${FOLDER}/${FONT}" "${EL_RUNTIME_ROOT}/System/Library/Fonts/${LOCATION}/${FONT_}"
		cp -v "${EL_RUNTIME_ROOT}/System/Library/Fonts/${LOCATION}/${FONT_}" "${EL_RUNTIME_ROOT}/System/Library/Fonts/${LOCATION}/${FONT_/2x/1x}"
	else
		cp -v "${PWD}/${FOLDER}/${FONT}" "${EL_RUNTIME_ROOT}/System/Library/Fonts/${LOCATION}/"
		cp -v "${EL_RUNTIME_ROOT}/System/Library/Fonts/${LOCATION}/${FONT}" "${EL_RUNTIME_ROOT}/System/Library/Fonts/${LOCATION}/${FONT/@2x/}"
	fi
	touch "${TOUCH}"
}

if [[ ! -f "${TOUCH}" ]];then
	install
else
	[[ -f "${TTC_2X/.ttc/.ttc.bak}" ]] && mv -v "${TTC_2X/.ttc/.ttc.bak}" "${TTC_2X}"
	[[ -f "${TTF_2X/.ttf/.ttf.bak}" ]] && mv -v "${TTF_2X/.ttf/.ttf.bak}" "${TTF_2X}"
	[[ -f "${CCF_2X/.ccf/.ccf.bak}" ]] && mv -v "${CCF_2X/.ccf/.ccf.bak}" "${CCF_2X}"
	[[ -f "${TTF_2X_/.ttf/.ttf.bak}" ]] && mv -v "${TTF_2X_/.ttf/.ttf.bak}" "${TTF_2X_}"
	[[ -f "${TTC/.ttc/.ttc.bak}" ]] && mv -v "${TTC/.ttc/.ttc.bak}" "${TTC}"
	[[ -f "${TTF/.ttf/.ttf.bak}" ]] && mv -v "${TTF/.ttf/.ttf.bak}" "${TTF}"
	[[ -f "${TTF_/.ttf/.ttf.bak}" ]] && mv -v "${TTF_/.ttf/.ttf.bak}" "${TTF_}"
	[[ -f "${CCF/.ccf/.ccf.bak}" ]] && mv -v "${CCF/.ccf/.ccf.bak}" "${CCF}"
	rm -f "${TOUCH}"
	install
fi

# sudo ./copyResource.sh <version> AppleColorEmoji@2x.ttf
