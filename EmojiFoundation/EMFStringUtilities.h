#import "../Types.h"

@interface EMFStringUtilities : NSObject
+ (NSString *)_stringWithUnichar:(UChar)unichar;
+ (NSString *)_baseFirstCharacterString:(NSString *)string;
+ (NSString *)_baseStringForEmojiString:(NSString *)emojiString;
+ (NSString *)professionSkinToneEmojiBaseKey:(NSString *)emojiString;
+ (NSMutableArray <NSString *> *)_skinToneVariantsForString:(NSString *)emojiString;
+ (UChar)_firstLongCharacterOfString:(NSString *)string;
+ (int)_skinToneForString:(NSString *)emojiString;
+ (BOOL)_emojiString:(NSString *)emojiString containsSubstring:(NSString *)substring;
+ (BOOL)_genderEmojiBaseStringNeedVariantSelector:(NSString *)emojiBaseString;
+ (BOOL)_hasSkinToneVariantsForString:(NSString *)emojiString;
@end