#import "UIKeyboardEmojiCategoryBar.h"

@interface UIKeyboardEmojiCategoryBar_iPad : UIKeyboardEmojiCategoryBar {
    NSArray <UIImage *> *_unselectedImages; // iOS < 8.3
    NSArray <UIImage *> *_selectedImages; // iOS < 8.3
}
- (void)updateSegmentImages; // iOS < 8.3
@end
