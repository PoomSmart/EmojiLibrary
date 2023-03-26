# https://github.com/theos/theos/blob/kirb/experimental/uikitformac-support/makefiles/targets/Darwin/uikitformac.mk
# https://github.com/theos/theos/issues/420
# Changed: _THEOS_TARGET_DEFAULT_OS_DEPLOYMENT_VERSION = 14.0
TARGET = uikitformac

# FIXME: This tool doesn't work on Apple Silicon yet
# ARCHS = $(shell uname -m)

include $(THEOS)/makefiles/common.mk

TOOL_NAME = EmojiTester

EmojiTester_FILES = ../NSString+MacExtras.m ../PSEmojiUtilities.m ../PSEmojiUtilities+Emoji.m ../PSEmojiUtilities+Functions.m main.m
EmojiTester_CFLAGS = -DFALLBACK_FLC=1 -Wno-error=incompatible-sysroot

include $(THEOS_MAKE_PATH)/tool.mk

after-all::
	@mkdir -p bin
	@cp -v $(THEOS_OBJ_DIR)/EmojiTester bin/