#import "../Types.h"

@interface NSString (TIExtras)
- (UChar)_firstLongCharacter;
- (BOOL)_containsEmoji;
@end
