#import "EMFEmojiLocaleData.h"

@interface EMFEmojiToken : NSObject
+ (instancetype)emojiTokenWithString:(NSString *)string localeData:(EMFEmojiLocaleData *)localeData;
- (NSString *)string;
@end
