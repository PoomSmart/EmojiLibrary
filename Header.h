#import "EmojiFoundation/EmojiFoundation.h"
#if TARGET_OS_IOS
#import "EmojiUIKit/EmojiUIKit.h"
#endif

#define containsString(str, substr) ([str rangeOfString:substr options:NSLiteralSearch].location != NSNotFound)
