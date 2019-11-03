#import <unicode/utf16.h>

@interface NSString (TIExtras)
- (UChar32)_firstLongCharacter;
- (BOOL)_containsEmoji;
@end
