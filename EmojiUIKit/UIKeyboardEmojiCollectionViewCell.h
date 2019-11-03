#import "UIKeyboardEmoji.h"

// iOS 8.3+
@interface UIKeyboardEmojiCollectionViewCell : UICollectionViewCell
@property NSInteger emojiFontSize;
@property(retain, nonatomic) UIKeyboardEmoji *emoji;
@end
