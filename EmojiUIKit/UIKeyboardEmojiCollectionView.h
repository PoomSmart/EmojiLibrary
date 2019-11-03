#import "UIKeyboardEmojiInputController.h"
#import "UIKeyboardEmojiGraphicsTraits.h"
#import "UIKeyboardEmojiCollectionViewCell.h"

// iOS 8.3+
@interface UIKeyboardEmojiCollectionView : UICollectionView
@property(retain, nonatomic) UIKeyboardEmojiInputController *inputController;
- (UIKeyboardEmojiGraphicsTraits *)emojiGraphicsTraits;
- (UIKeyboardEmojiCollectionViewCell *)closestCellForPoint:(CGPoint)point;
@end
