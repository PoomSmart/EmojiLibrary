#include <stdio.h>
#include <stdlib.h>
#import "../PSEmojiUtilities.h"

void printArray(NSString *title, NSArray *array) {
	NSLog(@"%@: %@", title, [array componentsJoinedByString:@", "]);
}

NSString *toUTF32(NSString *string) {
	NSMutableString *utf32 = [NSMutableString string];
	for (int i = 0; i < string.length - 1; i += 2) {
		UChar32 cbase = [string characterAtIndex:i];
        if ((cbase & 0xFC00) == 0xD800 && i + 1 < string.length) {
            UChar32 y = [string characterAtIndex:i + 1];
            if ((y & 0xFC00) == 0xDC00)
                cbase = (cbase << 10) + y - 0x35FDC00;
        } else
			--i;
		[utf32 appendFormat:@"%x ", cbase];
	}
	return utf32;
}

void printWithCodepoints(NSString *title, NSString *emoji) {
	NSLog(@"%@: %@ %@", title, emoji, toUTF32(emoji));
}

int main(int argc, char *argv[], char *envp[]) {
	if (argc != 2) {
		printf("Usage: EmojiTester <emoji>\n");
		return EXIT_FAILURE;
	}
	NSString *emoji = [NSString stringWithUTF8String:argv[1]];
	printWithCodepoints(@"Input", emoji);
	printWithCodepoints(@"Base", [PSEmojiUtilities emojiBaseString:emoji]);
	printArray(@"Variants", [PSEmojiUtilities skinToneVariants:emoji]);
	return 0;
}
