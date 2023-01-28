#import <UIKit/UIKBRenderConfig.h>
#import <UIKit/UIKBKeyView.h>
#import "UIKeyboardEmojiCategory.h"
#import "UIKeyboardEmojiInput.h"
#import "UIKeyboardEmojiPressIndicationDelegate.h"

@interface UIKeyboardEmojiScrollView : UIKBKeyView <UIScrollViewDelegate, UIKeyboardEmojiInput, UIKeyboardEmojiPressIndicationDelegate>
@property (retain, nonatomic) UIKBRenderConfig *renderConfig;
- (NSInteger)currentPage;
- (void)doLayout;
- (void)forceLayout;
- (void)layoutPages;
- (void)layoutRecents;
- (void)setCategory:(UIKeyboardEmojiCategory *)category; // iOS 5
@end
