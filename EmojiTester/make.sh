clang -fno-modules -I.. -I. -I$THEOS/include -framework Foundation -framework CoreGraphics \
main.m ../PSEmojiUtilities.m ../PSEmojiUtilities+Emoji.m ../PSEmojiUtilities+Functions.m ../NSString+MacExtras.m \
-o bin/EmojiTester
