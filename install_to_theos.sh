#!/bin/bash

set -e

mkdir -p $THEOS/lib/iphone/rootless

cp libEmojiLibrary.tbd $THEOS/lib/
cp libEmojiLibrary.tbd $THEOS/lib/iphone/rootless/
