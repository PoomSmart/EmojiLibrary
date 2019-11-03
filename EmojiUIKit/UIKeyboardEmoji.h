#import <CoreGraphics/CoreGraphics.h>

@interface UIKeyboardEmoji : NSObject {
    NSString *_emojiString;
    BOOL _hasDingbat;
}
@property(retain) NSString *emojiString;
@property(assign) BOOL hasDingbat; // iOS 7-8.2
@property(retain, nonatomic) NSString *name; // iOS 5.0
@property(retain, nonatomic) NSString *imageName; // iOS 5.0
@property(retain, nonatomic) NSString *publicCodePoint; // iOS 5.0
@property(retain, nonatomic) NSString *privateCodePoint; // iOS 5.0
@property(assign) unsigned short unicodeCharacter; // iOS 5.0
@property(retain) NSString *codePoint; // iOS 5.0
@property(assign) CGGlyph glyph; // iOS 6
@property(assign) NSInteger variantMask; // iOS 8.3+
+ (instancetype)emojiWithString:(NSString *)string; // iOS 6
+ (instancetype)emojiWithString:(NSString *)string hasDingbat:(BOOL)dingbat; // iOS 7-8.2
+ (instancetype)emojiWithString:(NSString *)string withVariantMask:(NSInteger)mask; // iOS 8.3+
- (instancetype)initWithString:(NSString *)string; // iOS 6
- (instancetype)initWithString:(NSString *)string hasDingbat:(BOOL)dingbat; // iOS 7-8.2
- (instancetype)initWithString:(NSString *)string withVariantMask:(NSInteger)mask;  // iOS 8.3+
- (instancetype)initWithName:(id)name imageName:(id)imageName codePoint:(unsigned short)codePoint; // iOS 5.0
- (BOOL)isEqual:(UIKeyboardEmoji *)emoji;
- (NSString *)key; // -emojiString
- (id)image; // iOS 5.0
@end
