#import "EmojiFoundation/EmojiFoundation.h"
#import "EmojiUIKit/EmojiUIKit.h"

// TODO: Move to theos/headers
@interface UIKBShape (Additions)
- (instancetype)initWithGeometry:(UIKBGeometry *)geometry frame:(CGRect)frame paddedFrame:(CGRect)paddedFrame;
@end

#define containsString(str, substr) ([str rangeOfString:substr options:NSLiteralSearch].location != NSNotFound)
