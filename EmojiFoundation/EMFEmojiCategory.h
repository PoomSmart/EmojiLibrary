#import <Foundation/Foundation.h>

@interface EMFEmojiCategory : NSObject
+ (id)_emojiSetForIdentifier:(NSString *)identifier setCount:(NSUInteger *)count; // iOS 10-10.1
+ (NSArray <NSString *> *)_emojiSetForIdentifier:(NSString *)identifier; // iOS 10.2+
- (NSString *)identifier;
@end
