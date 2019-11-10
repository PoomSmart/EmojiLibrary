#import "Types.h"

@implementation NSString (MacExtras)

+ (NSString *)stringWithUnichar:(UChar32)value {
    unichar buffer[2];
    NSUInteger length = 0;
    if (value - 0x10000 >= 0x100000) {
        buffer[0] = value;
        length = 1;
    } else {
        buffer[0] = (value >> 10) - 0x2840;
        buffer[1] = (value & 0x3FF) | 0xDC00;
        length = 2;
    }
    return [NSString stringWithCharacters:buffer length:length];
}

@end