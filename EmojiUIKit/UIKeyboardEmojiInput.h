#import "UIKeyboardEmojiCategory.h"

@protocol UIKeyboardEmojiInput <NSObject>
- (void)reloadForCategory:(UIKeyboardEmojiCategory *)category;
@end
