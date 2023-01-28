TARGET = uikitformac

include $(THEOS)/makefiles/common.mk

TOOL_NAME = EmojiTester

EmojiTester_FILES = ../NSString+MacExtras.m ../PSEmojiUtilities.m ../PSEmojiUtilities+Emoji.m ../PSEmojiUtilities+Functions.m main.m
EmojiTester_CFLAGS = -DFALLBACK_FLC=1

include $(THEOS_MAKE_PATH)/tool.mk

after-all::
	@mkdir -p bin
	@cp -v $(THEOS_OBJ_DIR)/EmojiTester bin/