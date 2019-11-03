#import "UIKeyboardEmojiKeyView.h"

@interface UIKeyboardEmojiCategoryBar : UIKeyboardEmojiKeyView { // UIKBKeyView for < 10
    NSArray <UIView *> *_dividerViews; // iOS < 8.3
    NSArray <UIView *> *_segmentViews; // iOS < 8.3
    NSInteger _total; // iOS < 8.3
    NSInteger _dividerTotal; // iOS < 8.3
    NSInteger _selected;
}
- (void)releaseImagesAndViews; // iOS < 8.3
- (void)updateSegmentAndDividers:(NSInteger)arg1; // iOS < 8.3
@end
