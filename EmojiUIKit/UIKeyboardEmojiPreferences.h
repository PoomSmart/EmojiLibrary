#import "UIKeyboardEmojiCategory.h"

// iOS 9.3+
@interface UIKeyboardEmojiPreferences : NSObject
+ (instancetype)sharedInstance;
- (NSMutableDictionary <NSString *, NSObject *> *)emptyDefaultsDictionary;
- (void)readEmojiDefaults;
- (void)writeEmojiDefaults;
- (NSInteger)selectedCategoryType;
- (NSUInteger)emojiCategoryDefaultsIndex:(UIKeyboardEmojiCategory *)category;
- (void)refreshLocalRecents;
@end
