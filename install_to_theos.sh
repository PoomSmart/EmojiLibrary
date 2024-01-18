#!/bin/bash

set -e

mkdir -p $THEOS/lib/iphone/rootless

cp libEmojiLibrary.tbd $THEOS/lib/
cp libEmojiLibrary.tbd $THEOS/lib/iphone/rootless/

mkdir -p $THEOS/include/EmojiLibrary

cp *.h $THEOS/include/EmojiLibrary/
cp -r EmojiFoundation $THEOS/include/EmojiLibrary/
cp -r EmojiUIKit $THEOS/include/EmojiLibrary/
