#import <UIKit/UIKBRenderFactory.h>
#import <UIKit/UIKBRenderTraits.h>
#import <UIKit/UIKBGradient.h>

// iOS 7+
@interface UIKBRenderFactory_Emoji : UIKBRenderFactory
- (UIKBRenderTraits *)_emojiCategoryControlKeyActiveTraits;
- (UIKBRenderTraits *)_emojiCategoryControlKeyTraits; // iOS 7-8.3
- (UIKBGradient *)_emojiSpaceKeyActiveBackgroundColorGradient;
- (UIKBGradient *)_emojiSpaceKeyBackgroundColorGradient;
- (UIKBGradient *)_emojiInputViewKeyBackgroundColorGradient;
- (NSString *)_emojiBorderColor; // iOS 7-8.3
@end
