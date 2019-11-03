#import "UIKeyboardEmojiCategory.h"

// iOS 5
@interface UIKeyboardEmojiCategoryController : NSObject
- (UIKeyboardEmojiCategory *)categoryForKey:(NSString *)categoryKey;
- (void)updateRecents;
@end
