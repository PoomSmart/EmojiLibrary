#import <Foundation/Foundation.h>

@implementation NSString (MacExtras)

+ (NSString *)stringWithUnichar:(unsigned int)value {
    unsigned short buffer[2];
    NSUInteger length = 0;
    if (value - 0x10000 > 0xFFFFF) {
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