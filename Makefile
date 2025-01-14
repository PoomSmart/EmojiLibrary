PACKAGE_VERSION = 1.6.2

ifeq ($(SIMULATOR),1)
    TARGET = simulator:clang:latest:8.0
    ARCHS = arm64 x86_64 i386
else
    ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
        TARGET = iphone:clang:latest:15.0
        ARCHS = arm64 arm64e
    else
		export PREFIX = $(THEOS)/toolchain/Xcode11.xctoolchain/usr/bin/
        TARGET = iphone:clang:14.5:5.0
    endif
endif

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = libEmojiLibrary
$(LIBRARY_NAME)_FILES = PSEmojiUtilities.m PSEmojiUtilities+Emoji.m PSEmojiUtilities+Functions.m
$(LIBRARY_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/library.mk
# make setup SIMULATOR=1 PL_SIMULATOR_VERSION=<target-iOS-version>
ifeq ($(SIMULATOR),1)
include ../../preferenceloader-sim/locatesim.mk
setup:: clean all
    @sudo rm -f $(PL_SIMULATOR_ROOT)/usr/lib/$(LIBRARY_NAME).dylib
    @sudo cp -v $(THEOS_OBJ_DIR)/$(LIBRARY_NAME).dylib $(PL_SIMULATOR_ROOT)/usr/lib/
endif
