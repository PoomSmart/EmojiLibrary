#import "UIKeyboardEmoji.h"
#import "../PSEmojiCategory.h"

@interface UIKeyboardEmojiCategory : NSObject
@property (assign) PSEmojiCategory categoryType; // iOS 6+
@property (assign) NSInteger lastViewedPage;
@property (readonly) NSString *displaySymbol; // iOS 6+
@property (readonly) NSString *displayName; // iOS 7
@property (retain) NSMutableArray <UIKeyboardEmoji *> *emoji;
@property (assign) NSUInteger lastVisibleFirstEmojiIndex;
@property (readonly) NSString *name;
@property (readonly) NSString *recentDescription; // iOS 7+
+ (instancetype)categoryForType:(PSEmojiCategory)categoryType; // iOS 6+
+ (NSMutableArray <UIKeyboardEmojiCategory *> *)categories;
+ (NSMutableArray <UIKeyboardEmoji *> *)emojiRecentsFromPreferences;
+ (NSArray <NSNumber *> *)enabledCategoryIndexes; // iOS 9.1+
+ (NSUInteger)hasVariantsForEmoji:(NSString *)emoji; // iOS 7+
+ (NSUInteger)categoryIndexForCategoryType:(PSEmojiCategory)categoryType; // iOS 9.1+
+ (PSEmojiCategory)categoryTypeForCategoryIndex:(NSUInteger)index; // iOS 9.1+
+ (NSInteger)numberOfCategories; // iOS 6+
+ (NSString *)localizedStringForKey:(NSString *)key; // iOS 6+
+ (NSString *)displayName:(NSInteger)categoryType; // iOS 8.3+
+ (BOOL)emojiString:(NSString *)string inGroup:(UTF32Char *)group withGroupCount:(NSUInteger)count; // iOS 6-9
+ (BOOL)emojiString:(NSString *)string inGroup:(NSArray <NSString *> *)group; // iOS 10+
- (void)releaseCategories;

// iOS < 10.2
+ (NSArray <NSString *> *)PeopleEmoji;
+ (NSArray <NSString *> *)NatureEmoji;
+ (NSArray <NSString *> *)FoodAndDrinkEmoji;
+ (NSArray <NSString *> *)CelebrationEmoji;
+ (NSArray <NSString *> *)ActivityEmoji;
+ (NSArray <NSString *> *)TravelAndPlacesEmoji;
+ (NSArray <NSString *> *)ObjectsAndSymbolsEmoji;
+ (NSArray <NSString *> *)ObjectsEmoji;
+ (NSArray <NSString *> *)SymbolsEmoji;
+ (NSArray <NSString *> *)flagEmojiCountryCodesCommon;
+ (NSArray <NSString *> *)flagEmojiCountryCodesReadyToUse; // blacklist check
+ (NSArray <NSString *> *)computeEmojiFlagsSortedByLanguage; // call -flagEmojiCountryCodesReadyToUse

+ (NSArray <NSString *> *)DingbatVariantsEmoji;
+ (NSArray <NSString *> *)SkinToneEmoji;
+ (NSArray <NSString *> *)GenderEmoji;
+ (NSArray <NSString *> *)NoneVariantEmoji;
+ (NSArray <NSString *> *)PrepopulatedEmoji;

+ (NSArray <NSString *> *)loadPrecomputedEmojiFlagCategory; // empty on iOS 10.2+

// iOS 10.2+
+ (NSArray <NSString *> *)ProfessionEmoji;
+ (NSString *)professionSkinToneEmojiBaseKey:(NSString *)emoji;
@end
