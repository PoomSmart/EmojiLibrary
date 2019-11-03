#!/bin/bash

make clean
sudo xcode-select -s /Applications/Xcode-9.4.1.app
make DEBUG=0 ARCHS="armv7 armv7s arm64"
mv .theos/obj/libEmojiLibrary.dylib .theos/obj/libEmojiLibrary_legacy.dylib
sudo xcode-select -s /Applications/Xcode.app
make DEBUG=0 ARCHS=arm64e
lipo -create .theos/obj/libEmojiLibrary_legacy.dylib .theos/obj/libEmojiLibrary.dylib -output .theos/obj/libEmojiLibrary.dylib
make DEBUG=0 package $1 $2