#import <Foundation/Foundation.h>

@interface EMFEmojiPreferences : NSObject
- (void)readEmojiDefaults;
- (void)writeEmojiDefaults;
- (void)resetEmojiDefaults;
@end
