#import "UIKeyboardEmoji.h"
#import "UIKeyboardEmojiImageView.h"
#import "UIKeyboardEmojiPressIndicationDelegate.h"
#import <UIKit/UIKBRenderConfig.h>

@interface UIKeyboardEmojiView : UIView
@property (retain) UIKeyboardEmoji *emoji;
@property (nonatomic, retain) UIKBRenderConfig *renderConfig;
@property (retain) UIView <UIKeyboardEmojiPressIndicationDelegate> *delegate;
@property (retain) UIView *popup;
@property (retain) UIKeyboardEmojiImageView *imageView;
+ (instancetype)emojiViewForEmoji:(UIKeyboardEmoji *)emoji withFrame:(CGRect)frame;
+ (void)recycleEmojiView:(UIKeyboardEmojiImageView *)emojiView;
- (void)uninstallPopup;
- (id)createAndInstallKeyPopupView;
- (void)setEmoji:(UIKeyboardEmoji *)emoji withFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame emoji:(UIKeyboardEmoji *)emoji;
@end
