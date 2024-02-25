#include <stdio.h>
#include <stdlib.h>
#import "../PSEmojiUtilities.h"

void prettyPrint(NSArray <NSString *> *array, BOOL wq, int perLine) {
    int x = 1;
    NSMutableString *string = [NSMutableString string];
    NSLog(@"Total: %lu", (unsigned long)array.count);
    for (NSString *substring in array) {
        if (wq)
            [string appendString:@"@\""];
        [string appendString:substring];
        if (wq)
            [string appendString:@"\","];
        else
            [string appendString:@","];
        if (x++ % perLine == 0) {
            NSLog(@"%@", string);
            string.string = @"";
        }
        else
            [string appendString:@" "];
    }
    NSLog(@"%@", string);
}

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

void testMultiPerson(NSString *emoji) {
    static int modifiers[] = { 1, 3, 4, 5, 6, -1, 0 }; // -1 None, 0 silhouette
    NSMutableArray *variants = [NSMutableArray array];
    for (int i = 0; i < 7; ++i) {
        NSString *specifier1 = modifiers[i] == 0 ? @"EMFSkinToneSpecifierTypeFitzpatrickSilhouette" : [PSEmojiUtilities skinToneSpecifierTypeFromEmojiFitzpatrickModifier:modifiers[i]];
        for (int j = 0; j < 7; ++j) {
            NSString *specifier2 = modifiers[j] == 0 ? @"EMFSkinToneSpecifierTypeFitzpatrickSilhouette" : [PSEmojiUtilities skinToneSpecifierTypeFromEmojiFitzpatrickModifier:modifiers[j]];
            NSString *skinned = [PSEmojiUtilities multiPersonStringForString:emoji skinToneVariantSpecifier:@[specifier1, specifier2]];
            [variants addObject:skinned];
        }
    }
    NSLog(@"Base %@", emoji);
    prettyPrint(variants, YES, 7);
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
    char buffer[4096];
    if ((fp = fopen("snapshot.txt", out ? "w+" : "r")) == NULL) {
        printf("Unable to open file: snapshot.txt\n");
        return EXIT_FAILURE;
    }
    for (NSString *emoji in [PSEmojiUtilities PeopleEmoji]) {
        NSMutableString *line = [NSMutableString string];
        NSMutableString *skinCodes = [NSMutableString string];
        [line appendString:emoji];
        if ([PSEmojiUtilities hasSkinToneVariants:emoji]) {
            NSArray <NSString *> *variants = [PSEmojiUtilities skinToneVariantsForString:emoji withSelf:NO];
            for (NSString *variant in variants) {
                [line appendFormat:@" %@", variant];
                [skinCodes appendFormat:@" %@ /", toUTF32(variant)];
            }
            if ([PSEmojiUtilities supportsCoupleSkinToneSelection:emoji])
                testMultiPerson(emoji);
            [line appendFormat:@" %@ |%@", toUTF32(emoji), skinCodes];
        } else
            [line appendFormat:@" %@", toUTF32(emoji)];
        NSLog(@"%@", line);
        const char *cline = [line UTF8String];
        if (out) {
            fputs(cline, fp);
            fputs("\n", fp);
        } else {
            fgets(buffer, 4096, fp);
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
