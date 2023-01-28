#import "UIKeyboardEmoji.h"
#import "UIKeyboardEmojiInput.h"

@interface UIKeyboardEmojiInputController : NSObject
+ (UIKBKeyView <UIKeyboardEmojiInput> *)activeInputView; // iOS < 8.3 (UIKeyboardEmojiScrollView), iOS 8.3+ (UIKeyboardEmojiCollectionInputView)
- (void)emojiUsed:(UIKeyboardEmoji *)emoji;
- (double)scoreForEmoji:(UIKeyboardEmoji *)emoji;
- (NSMutableArray <UIKeyboardEmoji *> *)recents;
- (NSMutableDictionary <NSString *, NSString *> *)skinToneBaseKeyPreferences; // iOS 8.3+
@end
