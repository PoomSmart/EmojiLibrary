#!/bin/bash

set -e

make clean
make DEBUG=0
cp .theos/obj/libEmojiLibrary.dylib libEmojiLibrary_arm.dylib
make clean
make DEBUG=0 SIMULATOR=1
cp .theos/obj/iphone_simulator/libEmojiLibrary.dylib libEmojiLibrary_pc.dylib
lipo -create libEmojiLibrary_arm.dylib libEmojiLibrary_pc.dylib -output libEmojiLibrary.dylib
mv libEmojiLibrary.dylib ${THEOS}/lib/
rm -f libEmojiLibrary_arm.dylib libEmojiLibrary_pc.dylib
