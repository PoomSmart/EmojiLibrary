#import "UIKeyboardEmojiKeyDisplayController.h"

@protocol UIKeyboardEmojiCategoryUpdate <NSObject>
@property (retain, nonatomic) UIKeyboardEmojiKeyDisplayController *emojiKeyManager;
- (void)updateToCategory:(NSInteger)categoryType;
@optional
- (void)updateToCategoryWithOffsetPercentage:(CGFloat)offsetPercentage;
@end
