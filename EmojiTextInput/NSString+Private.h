#import "../Types.h"

@interface NSString (Private)
+ (NSString *)stringWithUnichar:(UChar32)aChar;
+ (NSString *)_stringWithUnichar:(UChar32)aChar;
@end
