#import "UIKeyboardEmoji.h"

// iOS 5
@interface UIKeyboardEmojiFactory : NSObject {
    NSMutableDictionary *emojiMap;
}
- (UIKeyboardEmoji *)emojiWithKey:(id)key;
- (UIKeyboardEmoji *)emojiWithPrivateCodePoint:(id)privateCodePoint;
@end
