#include <stdio.h>
#include <stdlib.h>
#import "../PSEmojiUtilities.h"

void printArray(NSString *title, NSArray *array) {
	NSLog(@"%@: %@", title, [array componentsJoinedByString:@", "]);
}

NSString *toUTF32(NSString *string) {
	if (string.length == 1)
		return [NSString stringWithFormat:@"%x", [PSEmojiUtilities firstLongCharacter:string]];
	NSMutableArray *utf32 = [NSMutableArray array];
	for (int i = 0; i < string.length - 1; i += 2) {
		UChar32 cbase = [string characterAtIndex:i];
        if ((cbase & 0xFC00) == 0xD800 && i + 1 < string.length) {
            UChar32 y = [string characterAtIndex:i + 1];
            if ((y & 0xFC00) == 0xDC00)
                cbase = (cbase << 10) + y - 0x35FDC00;
        } else
			--i;
		[utf32 addObject:[NSString stringWithFormat:@"%x", cbase]];
	}
	return [utf32 componentsJoinedByString:@" "];
}

void printWithCodepoints(NSString *title, NSString *emoji) {
	NSLog(@"%@: %@ %@", title, emoji, toUTF32(emoji));
}

int main(int argc, char *argv[], char *envp[]) {
	if (argc != 2) {
		printf("Usage: EmojiTester [c|u]\n");
		return EXIT_FAILURE;
	}
	const char *opt = argv[1];
	bool out = strcmp(opt, "u") == 0;
	if (!out && strcmp(opt, "c")) {
		printf("Don't\n");
		return EXIT_FAILURE;
	}
	FILE *fp;
	char buffer[2048];
	if ((fp = fopen("snapshot.txt", out ? "w+" : "r")) == NULL) {
        printf("Unable to open file: snapshot.txt\n");
        return EXIT_FAILURE;
    }
	for (NSString *emoji in [PSEmojiUtilities PeopleEmoji]) {
		NSMutableString *line = [NSMutableString string];
		NSMutableString *skinCodes = [NSMutableString string];
		[line appendString:emoji];
		if ([PSEmojiUtilities hasVariantsForEmoji:emoji] & PSEmojiTypeSkin) {
			BOOL isMultiPerson = [PSEmojiUtilities isCoupleMultiSkinToneEmoji:emoji];
			for (NSString *variant in [PSEmojiUtilities skinToneVariants:emoji]) {
				[line appendFormat:@" %@", variant];
				[skinCodes appendFormat:@" %@ /", toUTF32(variant)];
				if (isMultiPerson) {
					NSString *base = [PSEmojiUtilities emojiBaseString:variant];
					NSCAssert4([base isEqualToString:emoji], @"Original %@ (%@) versus base %@ (%@)", emoji, toUTF32(emoji), base, toUTF32(base));
				}
			}
			if (isMultiPerson) {
				NSArray *chooserVariants = [PSEmojiUtilities skinToneChooserVariantsForString:emoji];
				NSLog(@"Base %@", emoji);
				printArray(@"Chooser First", chooserVariants[0]);
				printArray(@"Chooser Last", chooserVariants[1]);
			}
			[line appendFormat:@" %@ |%@", toUTF32(emoji), skinCodes];
		} else
			[line appendFormat:@" %@", toUTF32(emoji)];
		NSLog(@"%@", line);
		const char *cline = [line UTF8String];
		if (out) {
			fputs(cline, fp);
			fputs("\n", fp);
		} else {
			fgets(buffer, 2048, fp);
			size_t len = strlen(buffer);
			if (buffer[len - 1] == '\n')
				buffer[len - 1] = '\0';
			if (strcmp(cline, buffer)) {
				printf("Snapshot mismatched!\n");
				return EXIT_FAILURE;
			}
		}
	}
	fclose(fp);
	return 0;
}
