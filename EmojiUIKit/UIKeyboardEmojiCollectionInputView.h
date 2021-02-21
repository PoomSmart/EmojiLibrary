#import <UIKit/UIKBKeyView.h>
#import "UIKeyboardEmojiInput.h"
#import "UIKeyboardEmojiCollectionView.h"

// iOS 8.3+
@interface UIKeyboardEmojiCollectionInputView : UIKBKeyView <UIKeyboardEmojiInput> {
    UIKeyboardEmojiCollectionView *_collectionView;
}
+ (BOOL)shouldHighlightEmoji:(NSString *)emojiString; // iOS 13.2+
- (NSString *)emojiBaseUnicodeString:(NSString *)string; // iOS 8.3-9.3
- (NSString *)emojiBaseString:(NSString *)string; // iOS >= 10
- (NSString *)emojiBaseFirstCharacterString:(NSString *)string; // iOS >= 10
@end
