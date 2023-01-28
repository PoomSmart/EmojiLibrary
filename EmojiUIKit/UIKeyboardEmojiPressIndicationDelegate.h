#import <Foundation/Foundation.h>

@protocol UIKeyboardEmojiPressIndicationDelegate <NSObject>
@optional
- (void)installPressIndicatorAtPoint:(CGPoint)point;
- (void)removePressIndicator;
@end
