#import "UIKeyboardEmoji.h"

// iOS 5
@interface UIKeyboardLayoutEmoji : NSObject
+ (instancetype)emojiLayout;
+ (NSString *)localizedStringForKey:(NSString *)key;
+ (BOOL)isLandscape;
- (NSMutableArray <UIKeyboardEmoji *> *)recents;
- (UIKeyboardEmoji *)emojiWithString:(NSString *)emojiString;
- (void)emojiSelected:(UIKeyboardEmoji *)emoji;
- (void)emojiUsed:(UIKeyboardEmoji *)emoji;
- (CGRect)categoryFrame;
@end
