#import <UIKit/UIKBRenderConfig.h>
#import <UIKit/UIKBTree.h>
#import "EmojiUIKit-Structs.h"
#import "UIKeyboardEmojiCategory.h"

@interface UIKeyboardEmojiGraphics : NSObject
+ (instancetype)sharedInstance;
+ (CGFloat)emojiPageControlYOffset:(BOOL)portrait; // iOS 7+
+ (CGSize)emojiSize:(BOOL)portrait;
+ (CGPoint)margin:(BOOL)portrait;
+ (CGPoint)padding:(BOOL)portrait;
+ (NSInteger)rowCount:(BOOL)portrait;
+ (NSInteger)colCount:(BOOL)portrait;
+ (BOOL)isLandscape; // iOS 5-8.2
+ (NSString *)emojiCategoryImagePath:(UIKeyboardEmojiCategory *)category; // iOS 8.3-10.1
+ (NSString *)emojiCategoryImagePath:(UIKeyboardEmojiCategory *)category forRenderConfig:(UIKBRenderConfig *)renderConfig; // iOS 10.2+
+ (UIImage *)imageWithRect:(CGRect)rect name:(NSString *)name pressed:(BOOL)pressed;
- (UIImage *)categoryRecentsGenerator:(id)pressed;
- (UIImage *)categoryPeopleGenerator:(id)pressed;
- (UIImage *)categoryNatureGenerator:(id)pressed;
- (UIImage *)categoryObjectsGenerator:(id)pressed;
- (UIImage *)categoryPlacesGenerator:(id)pressed;
- (UIImage *)categorySymbolsGenerator:(id)pressed;
- (UIImage *)categoryWithSymbol:(NSString *)symbol pressed:(id)pressed;
- (UIKBTree *)protoKeyboard;
- (UIKBTree *)protoKeyWithDisplayString:(NSString *)displayString;
- (UIKBThemeRef)createProtoThemeForKey:(UIKBTree *)key keyboard:(UIKBTree *)keyboard state:(int)state;
@end
