#import <CoreGraphics/CoreGraphics.h>
#import "Header.h"
#import "PSEmojiType.h"

#define ZWJ @"‍"
#define FE0F @"️"
#define FEMALE @"♀"
#define MALE @"♂"
#define ZWJ2640 @"‍♀"
#define ZWJ2642 @"‍♂"
#define ZWJ2640FE0F @"‍♀️"
#define ZWJ2642FE0F @"‍♂️"
#define ZWJ27A1FE0F @"‍➡️"
#define HANDSHAKE @"🤝"
#define HANDSHAKE_JOINER @"‍🤝‍"
#define LEFTHAND @"🫱"
#define RIGHTHAND @"🫲"
#define HEART_JOINER @"‍❤️‍"
#define HEART_KISS_JOINER @"‍❤️‍💋‍"
#define WOMAN @"👩"
#define MAN @"👨"
#define NEUTRAL @"🧑"
#define FM @"👫"
#define FF @"👭"
#define MM @"👬"
#define NN @"🧑‍🤝‍🧑"

#define CATEGORIES_COUNT 9

@interface PSEmojiUtilities : NSObject
@end

@interface PSEmojiUtilities (Emoji)

+ (NSArray <NSString *> *)PeopleEmoji;
+ (NSArray <NSString *> *)NatureEmoji;
+ (NSArray <NSString *> *)FoodAndDrinkEmoji;
+ (NSArray <NSString *> *)CelebrationEmoji;
+ (NSArray <NSString *> *)ActivityEmoji;
+ (NSArray <NSString *> *)TravelAndPlacesEmoji;
+ (NSArray <NSString *> *)ObjectsEmoji;
+ (NSArray <NSString *> *)SymbolsEmoji;
+ (NSArray <NSString *> *)FlagsEmoji;
+ (NSArray <NSString *> *)OtherFlagsEmoji;
+ (NSArray <NSString *> *)DingbatVariantsEmoji;
+ (NSArray <NSString *> *)SkinToneEmoji;
+ (NSArray <NSString *> *)GenderEmoji;
+ (NSArray <NSString *> *)NoneVariantEmoji;
+ (NSArray <NSString *> *)ProfessionEmoji;
+ (NSArray <NSString *> *)PrepolulatedEmoji;
+ (NSArray <NSString *> *)PrepopulatedEmoji;
+ (NSArray <NSString *> *)ProfessionWithoutSkinToneEmoji;
+ (NSArray <NSString *> *)CoupleMultiSkinToneEmoji;
+ (NSArray <NSString *> *)MultiPersonFamilySkinToneEmoji;
+ (NSArray <NSString *> *)ExtendedCoupleMultiSkinToneEmoji;

@end

@interface PSEmojiUtilities (Functions)

+ (NSArray <NSString *> *)skinModifiers;
+ (NSArray <NSString *> *)genderEmojiBaseStringsNeedVariantSelector;
+ (NSArray <NSString *> *)dingbatEmojiBaseStringsNeedVariantSelector;
+ (NSArray <NSArray <NSString *> *> *)coupleSkinToneChooserVariantsForString:(NSString *)emojiString;
+ (NSArray <NSArray <NSString *> *> *)skinToneChooserVariantsForString:(NSString *)emojiString;
+ (NSArray <NSArray <NSString *> *> *)skinToneChooserVariantsForString:(NSString *)emojiString usesSilhouetteSpecifiers:(BOOL)silhouette;
+ (NSArray <NSArray <NSString *> *> *)skinToneChooserVariantsForHandHoldingCoupleType:(PSEmojiMultiSkinType)coupleType;
+ (NSArray <NSArray <NSString *> *> *)skinToneChooserArraysForCoupleType:(PSEmojiMultiSkinType)multiSkinType joiner:(NSString *)joiner;

+ (UChar32)firstLongCharacter:(NSString *)string;

+ (NSString *)getGender:(NSString *)emojiString;
+ (NSString *)getSkin:(NSString *)emojiString;
+ (NSString *)changeEmojiSkin:(NSString *)emojiString toSkin:(NSString *)skin;
+ (NSString *)emojiBaseFirstCharacterString:(NSString *)emojiString;
+ (NSString *)professionSkinToneEmojiBaseKey:(NSString *)emojiString;
+ (NSString *)emojiBaseString:(NSString *)emojiString;
+ (NSString *)skinToneSpecifierTypeFromEmojiFitzpatrickModifier:(int)modifier;
+ (NSString *)multiPersonStringForString:(NSString *)emojiString skinToneVariantSpecifier:(NSArray <NSString *> *)specifier;
+ (NSString *)joiningStringForCoupleString:(NSString *)emojiString;

+ (BOOL)genderEmojiBaseStringNeedVariantSelector:(NSString *)emojiBaseString;
+ (BOOL)emojiString:(NSString *)emojiString inGroup:(NSArray <NSString *> *)group;
+ (BOOL)hasSkinToneVariants:(NSString *)emojiString;
+ (BOOL)hasGender:(NSString *)emojiString;
+ (BOOL)hasSkin:(NSString *)emojiString;
+ (BOOL)hasDingbat:(NSString *)emojiString;
+ (BOOL)isNoneVariantEmoji:(NSString *)emojiString;
+ (BOOL)isSkinToneEmoji:(NSString *)emojiString;
+ (BOOL)isGenderEmoji:(NSString *)emojiString;
+ (BOOL)isProfessionEmoji:(NSString *)emojiString;
+ (BOOL)isFlagEmoji:(NSString *)emojiString;
+ (BOOL)isDingbatVariantsEmoji:(NSString *)emojiString;
+ (BOOL)isCoupleMultiSkinToneEmoji:(NSString *)emojiString;
+ (BOOL)isComposedCoupleMultiSkinToneEmoji:(NSString *)emojiString;
+ (BOOL)isHandholingCoupleEmoji:(NSString *)emojiString;
+ (BOOL)isBaseHandshakeOrHandshakeWithSkintonesEmoji:(NSString *)emojiString;
+ (BOOL)isMultiPersonFamilySkinToneEmoji:(NSString *)emojiString;
+ (BOOL)supportsCoupleSkinToneSelection:(NSString *)emojiString;

+ (PSEmojiMultiSkinType)multiPersonTypeForString:(NSString *)emojiString;
+ (NSUInteger)hasVariantsForEmoji:(NSString *)emojiString;

+ (NSArray <NSString *> *)tokenizedMultiPersonFromString:(NSString *)emojiString;
+ (NSArray <NSString *> *)tokenizedHandshakeFromString:(NSString *)emojiString;
+ (NSArray <NSString *> *)skinToneSpecifiersForString:(NSString *)emojiString;
+ (NSMutableArray <NSString *> *)skinToneVariantsForCouple:(PSEmojiMultiSkinType)multiSkinType joiner:(NSString *)joiner;
+ (NSMutableArray <NSString *> *)skinToneVariantsForString:(NSString *)emojiString;
+ (NSMutableArray <NSString *> *)skinToneVariantsForString:(NSString *)emojiString withSelf:(BOOL)withSelf;

#if TARGET_OS_IOS

#if !__arm64e__

+ (NSString *)overrideKBTreeEmoji:(NSString *)emojiString;

+ (BOOL)sectionHasSkin:(NSInteger)section;

+ (UIKeyboardEmojiCollectionViewCell *)collectionView:(UICollectionView *)collectionView_ cellForItemAtIndexPath:(NSIndexPath *)indexPath inputView:(UIKeyboardEmojiCollectionInputView *)inputView;
+ (UIKeyboardEmojiCategory *)prepopulatedCategory;

+ (UIKeyboardEmoji *)emojiWithString:(NSString *)emojiString;
+ (UIKeyboardEmoji *)emojiWithString:(NSString *)emojiString withVariantMask:(NSInteger)variantMask;
+ (UIKeyboardEmoji *)emojiWithStringUniversal:(NSString *)emojiString;

+ (void)addEmoji:(NSMutableArray <UIKeyboardEmoji *> *)emojiArray emojiString:(NSString *)emojiString withVariantMask:(NSInteger)variantMask;
+ (void)addEmoji:(NSMutableArray <UIKeyboardEmoji *> *)emojiArray emojiString:(NSString *)emojiString;

#endif

+ (void)resetEmojiPreferences;

#if !__LP64__
+ (CGGlyph)emojiGlyphShift:(CGGlyph)glyph;
#endif

#endif

@end

#define SoftPSEmojiUtilities NSClassFromString(@"PSEmojiUtilities")
