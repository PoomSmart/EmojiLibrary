PACKAGE_VERSION = 1.5.0

ifeq ($(SIMULATOR),1)
	TARGET = simulator:clang:latest:8.0
	ARCHS = x86_64 i386
else
	TARGET = iphone:clang:14.5:5.0
	ARCHS = armv7 arm64 arm64e
endif

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = libEmojiLibrary
libEmojiLibrary_FILES = PSEmojiUtilities.m PSEmojiUtilities+Emoji.m PSEmojiUtilities+Functions.m
libEmojiLibrary_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/library.mk
# make setup SIMULATOR=1 PL_SIMULATOR_VERSION=<target-iOS-version>
ifeq ($(SIMULATOR),1)
include ../../preferenceloader-sim/locatesim.mk
setup:: clean all
	@sudo rm -f $(PL_SIMULATOR_ROOT)/usr/lib/$(LIBRARY_NAME).dylib
	@sudo cp -v $(THEOS_OBJ_DIR)/$(LIBRARY_NAME).dylib $(PL_SIMULATOR_ROOT)/usr/lib/
endif
