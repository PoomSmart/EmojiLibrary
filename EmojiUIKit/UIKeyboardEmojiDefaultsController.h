#import <Foundation/Foundation.h>

// iOS 5-9.2
@interface UIKeyboardEmojiDefaultsController : NSObject
+ (instancetype)sharedController;
@property NSInteger currentSequenceKey;
@property (retain, nonatomic) id recentsKey;
@property (retain, nonatomic) id usageHistoryKey;
- (NSMutableDictionary <NSString *, NSObject *> *)emptyDefaultsDictionary;
- (void)readEmojiDefaults;
- (void)writeEmojiDefaults;
@end
