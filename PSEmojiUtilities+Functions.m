#import <TextInput/NSString+TIExtras.h>
#import <PSHeader/Misc.h>
#import <PSHeader/iOSVersions.h>
#include "Header.h"
#include "PSEmojiType.h"
#import "PSEmojiUtilities.h"
#import "PSEmojiCategory.h"

@implementation PSEmojiUtilities (Functions)

+ (NSArray <NSString *> *)skinModifiers {
    return @[ @"🏻", @"🏼", @"🏽", @"🏾", @"🏿" ];
}

+ (NSArray <NSString *> *)genderEmojiBaseStringsNeedVariantSelector {
    return @[ @"🏋", @"⛹", @"🕵", @"🏌" ];
}

+ (NSArray <NSString *> *)dingbatEmojiBaseStringsNeedVariantSelector {
    return @[ @"☝", @"✊", @"✋", @"✌", @"✍" ];
}

+ (UChar32)firstLongCharacter:(NSString *)string {
#if __LP64__ && TARGET_OS_IOS
    return [string _firstLongCharacter];
#else
    UChar32 cbase = 0;
    if (string.length) {
        cbase = [string characterAtIndex:0];
        if ((cbase & 0xFC00) == 0xD800 && string.length >= 2) {
            UChar32 y = [string characterAtIndex:1];
            if ((y & 0xFC00) == 0xDC00)
                cbase = (cbase << 10) + y - 0x35FDC00;
        }
    }
    return cbase;
#endif
}

+ (BOOL)genderEmojiBaseStringNeedVariantSelector:(NSString *)emojiBaseString {
    return [[self genderEmojiBaseStringsNeedVariantSelector] containsObject:emojiBaseString];
}

+ (BOOL)emojiString:(NSString *)emojiString inGroup:(NSArray <NSString *> *)group {
    return [group containsObject:emojiString];
}

+ (NSString *)emojiBaseFirstCharacterString:(NSString *)emojiString {
    return [NSString stringWithUnichar:[self firstLongCharacter:emojiString]];
}

+ (NSString *)getGender:(NSString *)emojiString {
    if (containsString(emojiString, FEMALE))
        return FEMALE;
    if (containsString(emojiString, MALE))
        return MALE;
    return nil;
}

+ (BOOL)hasGender:(NSString *)emojiString {
    return [self getGender:emojiString] != nil;
}

+ (NSString *)professionSkinToneEmojiBaseKey:(NSString *)emojiString {
    for (NSString *skin in [self skinModifiers]) {
        if (containsString(emojiString, skin))
            return [emojiString stringByReplacingOccurrencesOfString:skin withString:@"" options:NSLiteralSearch range:NSMakeRange(0, emojiString.length)];
    }
    return emojiString;
}

+ (NSString *)emojiStringWithoutVariantSelector:(NSString *)emojiString {
    return [emojiString stringByReplacingOccurrencesOfString:FE0F withString:@"" options:NSLiteralSearch range:NSMakeRange(0, emojiString.length)];
}

+ (NSString *)getSkin:(NSString *)emojiString {
    for (NSString *skin in [self skinModifiers]) {
        if (containsString(emojiString, skin))
            return skin;
    }
    return nil;
}

+ (BOOL)isComposedCoupleMultiSkinToneEmoji:(NSString *)emojiString {
    return containsString(emojiString, HANDSHAKE_JOINER) || containsString(emojiString, HEART_JOINER);
}

+ (BOOL)isHandholingCoupleEmoji:(NSString *)emojiString {
    return [[self CoupleMultiSkinToneEmoji] containsObject:[NSString stringWithUnichar:[self firstLongCharacter:emojiString]]]
        || containsString(emojiString, HANDSHAKE_JOINER);
}

+ (BOOL)isBaseHandshakeOrHandshakeWithSkintonesEmoji:(NSString *)emojiString {
    return containsString(emojiString, HANDSHAKE)
        || (containsString(emojiString, LEFTHAND) && containsString(emojiString, RIGHTHAND));
}

+ (BOOL)supportsCoupleSkinToneSelection:(NSString *)emojiString {
    return [self isHandholingCoupleEmoji:emojiString] || [self isCoupleMultiSkinToneEmoji:emojiString] || containsString(emojiString, @"‍❤️‍");
}

+ (NSArray <NSArray <NSString *> *> *)coupleSkinToneChooserVariantsForString:(NSString *)emojiString {
    PSEmojiMultiSkinType multiSkinType = [self multiPersonTypeForString:emojiString];
    if (multiSkinType) {
        NSString *joiner = [self joiningStringForCoupleString:emojiString] ?: HANDSHAKE_JOINER;
        return [self skinToneChooserArraysForCoupleType:multiSkinType joiner:joiner];
    }
    return nil;
}

+ (NSArray <NSString *> *)tokenizedMultiPersonFromString:(NSString *)emojiString {
    NSRange range = [emojiString rangeOfString:HANDSHAKE_JOINER options:NSLiteralSearch];
    if (range.location != NSNotFound) {
        NSString *left = [emojiString substringToIndex:range.location];
        NSString *right = [emojiString substringFromIndex:range.location + range.length];
        if (left && right) return @[left, right];
    }
    range = [emojiString rangeOfString:HEART_KISS_JOINER options:NSLiteralSearch];
    if (range.location != NSNotFound) {
        NSString *left = [emojiString substringToIndex:range.location];
        NSString *right = [emojiString substringFromIndex:range.location + range.length];
        if (left && right) return @[left, right];
    }
    range = [emojiString rangeOfString:HEART_JOINER options:NSLiteralSearch];
    if (range.location != NSNotFound) {
        NSString *left = [emojiString substringToIndex:range.location];
        NSString *right = [emojiString substringFromIndex:range.location + range.length];
        if (left && right) return @[left, right];
    }
    return @[];
}

+ (NSArray <NSString *> *)tokenizedHandshakeFromString:(NSString *)emojiString {
    static dispatch_once_t onceToken;
    static NSCharacterSet *zwjCharacterSet;
    dispatch_once(&onceToken, ^{
        zwjCharacterSet = [NSMutableCharacterSet characterSetWithCharactersInString:ZWJ].copy;
    });
    return [emojiString componentsSeparatedByCharactersInSet:zwjCharacterSet];
}

+ (PSEmojiMultiSkinType)multiPersonTypeForString:(NSString *)emojiString {
    if ([self isBaseHandshakeOrHandshakeWithSkintonesEmoji:emojiString])
        return PSEmojiMultiSkinTypeHandshake;
    NSString *baseFirst = [self emojiBaseFirstCharacterString:emojiString];
    if ([self isCoupleMultiSkinToneEmoji:baseFirst]) {
        if ([baseFirst isEqualToString:FM])
            return PSEmojiMultiSkinTypeFM;
        if ([baseFirst isEqualToString:FF])
            return PSEmojiMultiSkinTypeFF;
        if ([baseFirst isEqualToString:MM])
            return PSEmojiMultiSkinTypeMM;
        if ([baseFirst isEqualToString:NN] || [baseFirst isEqualToString:@"💑"] || [baseFirst isEqualToString:@"💏"])
            return PSEmojiMultiSkinTypeNN;
    } else if (emojiString && ([self isComposedCoupleMultiSkinToneEmoji:emojiString] || [self supportsCoupleSkinToneSelection:emojiString])) {
        NSArray *tokens = [self tokenizedMultiPersonFromString:emojiString];
        NSString *baseLeft = [self emojiBaseFirstCharacterString:tokens[0]];
        NSString *baseRight = [self emojiBaseFirstCharacterString:tokens[1]];
        if ([baseLeft isEqualToString:WOMAN]) {
            if ([baseRight isEqualToString:WOMAN])
                return PSEmojiMultiSkinTypeFF;
            if ([baseRight isEqualToString:MAN])
                return PSEmojiMultiSkinTypeFM;
        }
        if ([baseLeft isEqualToString:MAN] && [baseRight isEqualToString:MAN])
            return PSEmojiMultiSkinTypeMM;
        if ([baseLeft isEqualToString:NEUTRAL] && [baseRight isEqualToString:NEUTRAL])
            return PSEmojiMultiSkinTypeNN;
    }
    return 0;
}

+ (NSString *)joiningStringForCoupleString:(NSString *)emojiString {
    if (containsString(emojiString, HANDSHAKE_JOINER))
        return HANDSHAKE_JOINER;
    if (containsString(emojiString, HEART_KISS_JOINER) || containsString(emojiString, @"💏"))
        return HEART_KISS_JOINER;
    if (containsString(emojiString, HEART_JOINER) || containsString(emojiString, @"💑"))
        return HEART_JOINER;
    if ([emojiString isEqualToString:HANDSHAKE])
        return ZWJ;
    return nil;
}

+ (NSArray <NSString *> *)skinToneSpecifiersForString:(NSString *)emojiString {
    if ([self isCoupleMultiSkinToneEmoji:emojiString] && ![self isBaseHandshakeOrHandshakeWithSkintonesEmoji:emojiString])
        return @[@"EMFSkinToneSpecifierTypeFitzpatrickNone"];
    NSString *baseFirst = [self emojiBaseFirstCharacterString:emojiString];
    if ([baseFirst isEqualToString:FM] || [baseFirst isEqualToString:FF] || [baseFirst isEqualToString:MM]) {
        int skinTone = [self skinToneForString:emojiString];
        if (!skinTone)
            return @[@"EMFSkinToneSpecifierTypeFitzpatrickNone"];
        NSString *specifier = [self skinToneSpecifierTypeFromEmojiFitzpatrickModifier:skinTone];
        return @[specifier, specifier];
    }
    if ([self isComposedCoupleMultiSkinToneEmoji:emojiString]) {
        NSArray *tokens = [self tokenizedMultiPersonFromString:emojiString];
        NSMutableArray *specifiers = [NSMutableArray arrayWithCapacity:tokens.count];
        for (NSString *token in tokens) {
            int skinTone = [self skinToneForString:token];
            if (skinTone)
                [specifiers addObject:[self skinToneSpecifierTypeFromEmojiFitzpatrickModifier:skinTone]];
        }
        return specifiers;
    }
    if (![self isBaseHandshakeOrHandshakeWithSkintonesEmoji:emojiString])
        return @[[self skinToneSpecifierTypeFromEmojiFitzpatrickModifier:[self skinToneForString:emojiString]]];
    NSArray *tokens = [self tokenizedHandshakeFromString:emojiString];
    NSMutableArray *specifiers = [NSMutableArray arrayWithCapacity:2];
    for (NSString *token in tokens) {
        int skinTone = [self skinToneForString:token];
        if (skinTone)
            [specifiers addObject:[self skinToneSpecifierTypeFromEmojiFitzpatrickModifier:skinTone]];
    }
    return specifiers;
}

+ (int)skinToneForString:(NSString *)emojiString {
    NSDictionary <NSNumber *, NSString *> *map = @{
        @1: @"🏻",
        @3: @"🏼",
        @4: @"🏽",
        @5: @"🏾",
        @6: @"🏿"
    };
    __block int skinTone = 0;
    [map enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSString *obj, BOOL *stop) {
        if (containsString(emojiString, obj)) {
            skinTone = [key intValue];
            *stop = YES;
        }
    }];
    return skinTone;
}

+ (NSString *)skinToneSpecifierTypeFromEmojiFitzpatrickModifier:(int)modifier {
    switch (modifier) {
        case 1:
            return @"EMFSkinToneSpecifierTypeFitzpatrick1_2";
        case 3:
            return @"EMFSkinToneSpecifierTypeFitzpatrick3";
        case 4:
            return @"EMFSkinToneSpecifierTypeFitzpatrick4";
        case 5:
            return @"EMFSkinToneSpecifierTypeFitzpatrick5";
        case 6:
            return @"EMFSkinToneSpecifierTypeFitzpatrick6";
        default:
            return @"EMFSkinToneSpecifierTypeFitzpatrickNone";
    }
}

+ (NSString *)skinToneSuffixFromSpecifierType:(NSString *)specifier {
    NSString *realSpecifier = [specifier stringByReplacingOccurrencesOfString:@"EMFSkinToneSpecifierTypeFitzpatrick" withString:@""];
    if ([realSpecifier isEqualToString:@"1_2"])
        return @"🏻";
    if ([realSpecifier isEqualToString:@"3"])
        return @"🏼";
    if ([realSpecifier isEqualToString:@"4"])
        return @"🏽";
    if ([realSpecifier isEqualToString:@"5"])
        return @"🏾";
    if ([realSpecifier isEqualToString:@"6"])
        return @"🏿";
    return @"";
}

+ (NSString *)multiPersonStringForString:(NSString *)emojiString skinToneVariantSpecifier:(NSArray <NSString *> *)specifier {
    PSEmojiMultiSkinType multiSkinType = [self multiPersonTypeForString:emojiString];
    if (multiSkinType) {
        NSString *joiner = [self joiningStringForCoupleString:emojiString];
        BOOL hasSilhouette = [specifier containsObject:@"EMFSkinToneSpecifierTypeFitzpatrickSilhouette"];
        if (hasSilhouette) {
            NSString *first = [specifier firstObject];
            NSString *last = [specifier lastObject];
            BOOL firstSil = [first isEqualToString:@"EMFSkinToneSpecifierTypeFitzpatrickSilhouette"];
            BOOL lastSil = [last isEqualToString:@"EMFSkinToneSpecifierTypeFitzpatrickSilhouette"];
            if (firstSil) {
                if (lastSil && joiner == nil)
                    specifier = @[@"EMFSkinToneSpecifierTypeFitzpatrick6", @"EMFSkinToneSpecifierTypeFitzpatrick6"];
                else
                    specifier = @[last, last];
            } else
                specifier = @[first, first];
        }
        NSString *solo = nil;
        NSString *firstSuffix = nil;
        NSString *lastSuffix = nil;
        NSString *first = [specifier firstObject];
        firstSuffix = [self skinToneSuffixFromSpecifierType:first];
        if (specifier.count == 2) {
            NSString *last = [specifier lastObject];
            lastSuffix = [self skinToneSuffixFromSpecifierType:last];
        } else
            lastSuffix = firstSuffix;
        if (joiner && ![joiner isEqualToString:HANDSHAKE_JOINER] && multiSkinType != PSEmojiMultiSkinTypeHandshake) {
            if (multiSkinType == PSEmojiMultiSkinTypeNN || firstSuffix.length) {
                NSArray *tokens = [self tokenizedMultiPersonFromString:emojiString];
                if (tokens.count <= 1)
                    tokens = @[NEUTRAL, NEUTRAL];
                NSString *firstToken = [self emojiBaseString:[tokens firstObject]];
                NSString *lastToken = [self emojiBaseString:[tokens lastObject]];
                return [self coupleStringWithLeftPerson:firstToken leftVariant:firstSuffix joiningString:joiner rightPerson:lastToken rightVariant:lastSuffix];
            }
            return [self emojiBaseString:emojiString];
        }
        switch (multiSkinType) {
            case PSEmojiMultiSkinTypeMM: {
                if (firstSuffix == nil || lastSuffix == nil)
                    return MM;
                if ([firstSuffix isEqualToString:lastSuffix] && !hasSilhouette)
                    return [NSString stringWithFormat:@"%@%@", MM, firstSuffix];
                solo = MAN;
                break;
            }
            case PSEmojiMultiSkinTypeFF: {
                if (firstSuffix == nil || lastSuffix == nil)
                    return FF;
                if ([firstSuffix isEqualToString:lastSuffix] && !hasSilhouette)
                    return [NSString stringWithFormat:@"%@%@", FF, firstSuffix];
                solo = WOMAN;
                break;
            }
            case PSEmojiMultiSkinTypeFM: {
                if (firstSuffix == nil || lastSuffix == nil)
                    return FM;
                if (![firstSuffix isEqualToString:lastSuffix] || hasSilhouette)
                    return [NSString stringWithFormat:@"%@%@%@%@%@", WOMAN, firstSuffix, HANDSHAKE_JOINER, MAN, lastSuffix];
                return [NSString stringWithFormat:@"%@%@", FM, firstSuffix];
            }
            case PSEmojiMultiSkinTypeNN:
                break;
            case PSEmojiMultiSkinTypeHandshake: {
                if (firstSuffix == nil || lastSuffix == nil)
                    return HANDSHAKE;
                if (![firstSuffix isEqualToString:lastSuffix] || hasSilhouette)
                    return [NSString stringWithFormat:@"%@%@%@%@%@", LEFTHAND, firstSuffix, ZWJ, RIGHTHAND, lastSuffix];
                return [NSString stringWithFormat:@"%@%@", HANDSHAKE, firstSuffix];
            }
        }
        return [NSString stringWithFormat:@"%@%@%@%@%@", solo, firstSuffix, HANDSHAKE_JOINER, solo, lastSuffix];
    }
    return nil;
}

+ (NSArray <NSArray <NSString *> *> *)skinToneChooserArraysForCoupleType:(PSEmojiMultiSkinType)coupleType joiner:(NSString *)joiner {
    NSMutableArray *first = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *second = [NSMutableArray arrayWithCapacity:5];
    NSString *leftEmoji = nil;
    NSString *rightEmoji = nil;
    NSString *pair;
    switch (coupleType) {
        case PSEmojiMultiSkinTypeFM:
            pair = FM;
            leftEmoji = WOMAN;
            rightEmoji = MAN;
            break;
        case PSEmojiMultiSkinTypeFF:
            pair = FF;
            leftEmoji = rightEmoji = WOMAN;
            break;
        case PSEmojiMultiSkinTypeMM:
            pair = MM;
            leftEmoji = rightEmoji = MAN;
            break;
        case PSEmojiMultiSkinTypeNN:
            pair = nil;
            leftEmoji = rightEmoji = NEUTRAL;
            break;
        case PSEmojiMultiSkinTypeHandshake:
            pair = nil;
            leftEmoji = LEFTHAND;
            rightEmoji = RIGHTHAND;
            break;
    }
    for (NSString *skin in [PSEmojiUtilities skinModifiers]) {
        NSString *emoji;
        if (joiner)
            emoji = [self coupleStringWithLeftPerson:leftEmoji leftVariant:skin joiningString:joiner rightPerson:rightEmoji rightVariant:skin];
        else
            emoji = [NSString stringWithFormat:@"%@%@", pair, skin];
        [first addObject:emoji];
        [second addObject:emoji];
    }
    return @[first, second];
}

+ (NSArray <NSArray <NSString *> *> *)skinToneChooserVariantsForHandHoldingCoupleType:(PSEmojiMultiSkinType)coupleType {
    NSMutableArray *first = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *second = [NSMutableArray arrayWithCapacity:5];
    for (NSString *skin in [PSEmojiUtilities skinModifiers]) {
        switch (coupleType) {
            case PSEmojiMultiSkinTypeFM: {
                [first addObject:[NSString stringWithFormat:@"%@%@%@%@", WOMAN, skin, HANDSHAKE_JOINER, MAN]];
                [second addObject:[NSString stringWithFormat:@"%@%@%@%@", WOMAN, HANDSHAKE_JOINER, MAN, skin]];
                break;
            }
            case PSEmojiMultiSkinTypeFF: {
                [first addObject:[NSString stringWithFormat:@"%@%@%@%@", WOMAN, skin, HANDSHAKE_JOINER, WOMAN]];
                [second addObject:[NSString stringWithFormat:@"%@%@%@%@", WOMAN, HANDSHAKE_JOINER, WOMAN, skin]];
                break;
            }
            case PSEmojiMultiSkinTypeMM: {
                [first addObject:[NSString stringWithFormat:@"%@%@%@%@", MAN, skin, HANDSHAKE_JOINER, MAN]];
                [second addObject:[NSString stringWithFormat:@"%@%@%@%@", MAN, HANDSHAKE_JOINER, MAN, skin]];
                break;
            }
            case PSEmojiMultiSkinTypeNN: {
                [first addObject:[NSString stringWithFormat:@"%@%@%@%@", NEUTRAL, skin, HANDSHAKE_JOINER, NEUTRAL]];
                [second addObject:[NSString stringWithFormat:@"%@%@%@%@", NEUTRAL, HANDSHAKE_JOINER, NEUTRAL, skin]];
                break;
            }
            case PSEmojiMultiSkinTypeHandshake: {
                [first addObject:[NSString stringWithFormat:@"%@%@%@%@%@", LEFTHAND, skin, ZWJ, RIGHTHAND, ZWJ]];
                [second addObject:[NSString stringWithFormat:@"%@%@%@%@%@", LEFTHAND, ZWJ, RIGHTHAND, skin, ZWJ]];
                break;
            }
            default:
                break;
        }
    }
    return @[first, second];
}

+ (NSArray <NSArray <NSString *> *> *)skinToneChooserVariantsForString:(NSString *)emojiString usesSilhouetteSpecifiers:(BOOL)silhouette {
    PSEmojiMultiSkinType multiSkinType = [self multiPersonTypeForString:emojiString];
    if (multiSkinType) {
        if (silhouette)
            return [self skinToneChooserVariantsForHandHoldingCoupleType:multiSkinType];
        NSString *joiner = [self joiningStringForCoupleString:emojiString] ?: HANDSHAKE_JOINER;
        return [self skinToneChooserArraysForCoupleType:multiSkinType joiner:joiner];
    }
    return nil;
}

+ (NSArray <NSArray <NSString *> *> *)skinToneChooserVariantsForString:(NSString *)emojiString {
    PSEmojiMultiSkinType multiSkinType = [self multiPersonTypeForString:emojiString];
    if (multiSkinType)
        return [self skinToneChooserVariantsForString:emojiString usesSilhouetteSpecifiers:YES];
    return nil;
}

+ (BOOL)hasSkin:(NSString *)emojiString {
    return [self getSkin:emojiString] != nil;
}

+ (NSString *)changeEmojiSkin:(NSString *)emojiString toSkin:(NSString *)skin {
    NSString *oldSkin = [self getSkin:emojiString];
    if (oldSkin == nil || [oldSkin isEqualToString:skin])
        return emojiString;
    return [emojiString stringByReplacingOccurrencesOfString:oldSkin withString:skin options:NSLiteralSearch range:NSMakeRange(0, emojiString.length)];
}

+ (BOOL)isNoneVariantEmoji:(NSString *)emojiString {
    return [[self NoneVariantEmoji] containsObject:emojiString];
}

+ (BOOL)isSkinToneEmoji:(NSString *)emojiString {
    return [[self SkinToneEmoji] containsObject:emojiString];
}

+ (BOOL)isGenderEmoji:(NSString *)emojiString {
    return [[self GenderEmoji] containsObject:emojiString];
}

+ (BOOL)isProfessionEmoji:(NSString *)emojiString {
    return [[self ProfessionEmoji] containsObject:emojiString];
}

+ (BOOL)isFlagEmoji:(NSString *)emojiString {
    return [[self FlagsEmoji] containsObject:emojiString];
}

+ (BOOL)isDingbatVariantsEmoji:(NSString *)emojiString {
    return [[self DingbatVariantsEmoji] containsObject:emojiString];
}

+ (BOOL)isCoupleMultiSkinToneEmoji:(NSString *)emojiString {
    return [[self CoupleMultiSkinToneEmoji] containsObject:emojiString] || [[self ExtendedCoupleMultiSkinToneEmoji] containsObject:emojiString] || [self isBaseHandshakeOrHandshakeWithSkintonesEmoji:emojiString];
}

+ (BOOL)isMultiPersonFamilySkinToneEmoji:(NSString *)emojiString {
    return [[self MultiPersonFamilySkinToneEmoji] containsObject:emojiString];
}

+ (NSString *)emojiBaseString:(NSString *)emojiString {
    if ([self isProfessionEmoji:emojiString]
        || [self isFlagEmoji:emojiString]
        || ([self isCoupleMultiSkinToneEmoji:emojiString] && ![self isBaseHandshakeOrHandshakeWithSkintonesEmoji:emojiString])
        || [self isMultiPersonFamilySkinToneEmoji:emojiString])
        return emojiString;
    NSInteger multiSkinType = [self multiPersonTypeForString:emojiString];
    if (multiSkinType) {
        NSString *joiner = [self joiningStringForCoupleString:emojiString];
        if (joiner == nil || [self isHandholingCoupleEmoji:emojiString] || [self isBaseHandshakeOrHandshakeWithSkintonesEmoji:emojiString]) {
            switch (multiSkinType) {
                case PSEmojiMultiSkinTypeFM:
                    return FM;
                case PSEmojiMultiSkinTypeFF:
                    return FF;
                case PSEmojiMultiSkinTypeMM:
                    return MM;
                case PSEmojiMultiSkinTypeNN:
                    return NN;
                case PSEmojiMultiSkinTypeHandshake:
                    return HANDSHAKE;
            }
        } else {
            if (multiSkinType != PSEmojiMultiSkinTypeNN) {
                NSArray <NSString *> *tokens = [self tokenizedMultiPersonFromString:emojiString];
                NSString *leftPerson = [tokens firstObject];
                NSString *rightPerson = [tokens lastObject];
                return [self coupleStringWithLeftPerson:leftPerson leftVariant:nil joiningString:joiner rightPerson:rightPerson rightVariant:nil];
            } else {
                if ([joiner isEqualToString:HEART_JOINER])
                    return @"💑";
                if ([joiner isEqualToString:HEART_KISS_JOINER])
                    return @"💏";
            }
        }
    }
    NSString *baseEmoji = [self professionSkinToneEmojiBaseKey:emojiString];
    if ([self isProfessionEmoji:baseEmoji])
        return baseEmoji;
    // Extra
    baseEmoji = [baseEmoji stringByReplacingOccurrencesOfString:ZWJ27A1FE0F withString:@""];
    if ([self isProfessionEmoji:baseEmoji])
        return [baseEmoji stringByAppendingString:ZWJ27A1FE0F];
    NSString *baseFirst = [self emojiBaseFirstCharacterString:emojiString];
    if ([self hasGender:emojiString]) {
        NSString *variantSelector = [self genderEmojiBaseStringNeedVariantSelector:baseFirst] ? FE0F : @"";
        if (containsString(emojiString, FEMALE))
            return [NSString stringWithFormat:@"%@%@%@", baseFirst, variantSelector, ZWJ2640FE0F];
        if (containsString(emojiString, MALE))
            return [NSString stringWithFormat:@"%@%@%@", baseFirst, variantSelector, ZWJ2642FE0F];
        return nil;
    }
    if ([[self dingbatEmojiBaseStringsNeedVariantSelector] containsObject:baseFirst])
        return [baseFirst stringByAppendingString:FE0F];
    return baseFirst;
}

+ (NSString *)coupleStringWithLeftPerson:(NSString *)leftPerson leftVariant:(NSString *)leftVariant joiningString:(NSString *)joiningString rightPerson:(NSString *)rightPerson rightVariant:(NSString *)rightVariant {
    NSString *finalLeftVariant = nil;
    NSString *finalRightVariant = nil;
    NSString *finalLeftPerson = nil;
    NSString *finalRightPerson = nil;
    if (leftVariant && leftVariant.length) {
        finalLeftPerson = leftPerson;
        finalLeftVariant = leftVariant;
    } else {
        finalLeftPerson = [self emojiBaseString:leftPerson];
        finalLeftVariant = @"";
    }
    if (rightVariant && rightVariant.length) {
        finalRightPerson = rightPerson;
        finalRightVariant = rightVariant;
    } else {
        finalRightPerson = [self emojiBaseString:rightPerson];
        finalRightVariant = @"";
    }
    return [NSString stringWithFormat:@"%@%@%@%@%@", finalLeftPerson, finalLeftVariant, joiningString, finalRightPerson, finalRightVariant];
}

+ (NSMutableArray <NSString *> *)skinToneVariantsForMultiPersonType:(PSEmojiMultiSkinType)multiSkinType {
    NSMutableArray *variants = [NSMutableArray array];
    for (NSString *leftSkin in [PSEmojiUtilities skinModifiers]) {
        for (NSString *rightSkin in [PSEmojiUtilities skinModifiers]) {
            if ([leftSkin isEqualToString:rightSkin]) {
                NSString *emoji = nil;
                switch (multiSkinType) {
                    case PSEmojiMultiSkinTypeFM:
                        emoji = FM;
                        break;
                    case PSEmojiMultiSkinTypeFF:
                        emoji = FF;
                        break;
                    case PSEmojiMultiSkinTypeMM:
                        emoji = MM;
                        break;
                    case PSEmojiMultiSkinTypeNN:
                        emoji = NN;
                        break;
                    case PSEmojiMultiSkinTypeHandshake:
                        emoji = HANDSHAKE;
                        break;
                }
                if (emoji)
                    [variants addObject:[NSString stringWithFormat:@"%@%@", emoji, leftSkin]];
            } else {
                switch (multiSkinType) {
                    case PSEmojiMultiSkinTypeFM:
                        [variants addObject:[NSString stringWithFormat:@"%@%@%@%@%@", WOMAN, leftSkin, HANDSHAKE_JOINER, MAN, rightSkin]];
                        break;
                    case PSEmojiMultiSkinTypeFF:
                        [variants addObject:[NSString stringWithFormat:@"%@%@%@%@%@", WOMAN, leftSkin, HANDSHAKE_JOINER, WOMAN, rightSkin]];
                        break;
                    case PSEmojiMultiSkinTypeMM:
                        [variants addObject:[NSString stringWithFormat:@"%@%@%@%@%@", MAN, leftSkin, HANDSHAKE_JOINER, MAN, rightSkin]];
                        break;
                    case PSEmojiMultiSkinTypeNN:
                        [variants addObjectsFromArray:[self skinToneVariantsForCouple:multiSkinType joiner:HANDSHAKE_JOINER]];
                        break;
                    case PSEmojiMultiSkinTypeHandshake:
                        [variants addObject:[NSString stringWithFormat:@"%@%@%@%@%@", LEFTHAND, leftSkin, ZWJ, RIGHTHAND, rightSkin]];
                        break;
                }
            }
        }
    }
    return variants;
}

+ (NSMutableArray <NSString *> *)skinToneVariantsForCouple:(PSEmojiMultiSkinType)multiSkinType joiner:(NSString *)joiner {
    NSMutableArray *variants = [NSMutableArray array];
    NSString *leftEmoji = nil;
    NSString *rightEmoji = nil;
    switch (multiSkinType) {
        case PSEmojiMultiSkinTypeFM:
            leftEmoji = WOMAN;
            rightEmoji = MAN;
            break;
        case PSEmojiMultiSkinTypeFF:
            leftEmoji = rightEmoji = WOMAN;
            break;
        case PSEmojiMultiSkinTypeMM:
            leftEmoji = rightEmoji = MAN;
            break;
        case PSEmojiMultiSkinTypeNN:
            leftEmoji = rightEmoji = NEUTRAL;
            break;
        default:
            break;
    }
    for (NSString *leftSkin in [PSEmojiUtilities skinModifiers]) {
        for (NSString *rightSkin in [PSEmojiUtilities skinModifiers]) {
            [variants addObject:[self coupleStringWithLeftPerson:leftEmoji leftVariant:leftSkin joiningString:joiner rightPerson:rightEmoji rightVariant:rightSkin]];
        }
    }
    return variants;
}

+ (NSMutableArray <NSString *> *)skinToneVariantsForString:(NSString *)emojiString withSelf:(BOOL)withSelf {
    PSEmojiMultiSkinType multiSkinType = [self multiPersonTypeForString:emojiString];
    if (multiSkinType) {
        if (multiSkinType == PSEmojiMultiSkinTypeHandshake)
            return [self skinToneVariantsForMultiPersonType:PSEmojiMultiSkinTypeHandshake];
        if ([self isHandholingCoupleEmoji:emojiString])
            return [self skinToneVariantsForMultiPersonType:multiSkinType];
        NSString *joiner = [self joiningStringForCoupleString:emojiString] ?: HANDSHAKE_JOINER;
        return [self skinToneVariantsForCouple:multiSkinType joiner:joiner];
    }
    NSString *baseFirst = [self emojiBaseFirstCharacterString:emojiString];
    if (![self isSkinToneEmoji:baseFirst]) return nil;
    NSString *base = [self emojiBaseString:emojiString];
    NSMutableArray <NSString *> *skins = [NSMutableArray array];
    NSArray <NSString *> *skinModifiers = [self skinModifiers];
    int index = -1;
    while (1) {
        NSString *emoji = nil;
        if ([self isGenderEmoji:baseFirst]) {
            NSString *third = @"";
            if (containsString(emojiString, MALE)) third = ZWJ2642FE0F;
            else if (containsString(emojiString, FEMALE)) third = ZWJ2640FE0F;
            NSString *second = [self genderEmojiBaseStringNeedVariantSelector:baseFirst] ? FE0F : @"";
            if (index == -1)
                emoji = [NSString stringWithFormat:@"%@%@%@", baseFirst, second, third];
            else
                emoji = [NSString stringWithFormat:@"%@%@%@", baseFirst, skinModifiers[index], third];
            if ([emojiString hasSuffix:ZWJ27A1FE0F])
                emoji = [emoji stringByAppendingString:ZWJ27A1FE0F];
        } else {
            BOOL isProfessionEmoji = [self isProfessionEmoji:base];
            // Extra
            if (!isProfessionEmoji)
                isProfessionEmoji = [self isProfessionEmoji:[base stringByReplacingOccurrencesOfString:ZWJ27A1FE0F withString:@""]];
            if (isProfessionEmoji) {
                if (index == -1)
                    emoji = base;
                else {
                    NSRange baseFirstRange = [base rangeOfString:baseFirst options:NSLiteralSearch];
                    NSString *out = [NSString stringWithFormat:@"%@%@", baseFirst, skinModifiers[index]];
                    emoji = [base stringByReplacingCharactersInRange:baseFirstRange withString:out];
                }
            } else {
                if (index == -1) {
                    if ([self isDingbatVariantsEmoji:baseFirst])
                        emoji = [NSString stringWithFormat:@"%@%@", baseFirst, FE0F];
                    else
                        emoji = base;
                } else
                    emoji = [NSString stringWithFormat:@"%@%@", baseFirst, skinModifiers[index]];
            }
        }
        if (index != -1 || withSelf)
            [skins addObject:emoji];
        if (++index == 5) break;
    }
    return skins;
}

+ (NSMutableArray <NSString *> *)skinToneVariantsForString:(NSString *)emojiString {
    return [self skinToneVariantsForString:emojiString withSelf:YES];
}

+ (NSUInteger)hasVariantsForEmoji:(NSString *)emojiString {
    NSUInteger variant = PSEmojiTypeRegular;
    if (![self isNoneVariantEmoji:emojiString]) {
        if ([self isDingbatVariantsEmoji:emojiString])
            variant |= PSEmojiTypeDingbat;
        if ([self hasSkinToneVariants:emojiString])
            variant |= PSEmojiTypeSkin;
        if ([self isGenderEmoji:emojiString]) {
            if (containsString(emojiString, ZWJ2640) || containsString(emojiString, ZWJ2642))
                variant |= PSEmojiTypeGender;
        }
        if ([self isProfessionEmoji:emojiString])
            variant |= PSEmojiTypeProfession;
    }
    return variant;
}

+ (BOOL)hasSkinToneVariants:(NSString *)emojiString {
    if ([self isMultiPersonFamilySkinToneEmoji:emojiString])
        return NO;
    NSString *baseFirst = [self emojiBaseFirstCharacterString:emojiString];
    return [self isSkinToneEmoji:baseFirst] || [self isCoupleMultiSkinToneEmoji:baseFirst];
}

+ (BOOL)hasDingbat:(NSString *)emojiString {
    return emojiString.length && [self isDingbatVariantsEmoji:emojiString];
}

#if TARGET_OS_IOS

#if !__arm64e__

+ (BOOL)sectionHasSkin:(NSInteger)section {
    return section <= PSEmojiCategoryPeople || ((IS_IOS_OR_NEWER(iOS_9_1) && (section == PSEmojiCategoryActivity || section == PSEmojiCategoryObjects)) || (!IS_IOS_OR_NEWER(iOS_9_1) && (section == IDXPSEmojiCategoryActivity || section == IDXPSEmojiCategoryObjects)));
}

+ (NSString *)overrideKBTreeEmoji:(NSString *)emojiString {
    if (emojiString.length >= 4) {
        NSString *skin = [self getSkin:emojiString];
        if (skin) {
            NSString *emojiWithoutSkin = [self changeEmojiSkin:emojiString toSkin:@""];
            NSArray <NSString *> *skins = [self skinToneVariantsForString:emojiWithoutSkin];
            NSUInteger skinIndex = [[self skinModifiers] indexOfObject:skin];
            NSString *result = skins[skinIndex];
            return result;
        }
    }
    return emojiString;
}

+ (UIKeyboardEmojiCollectionViewCell *)collectionView:(UICollectionView *)collectionView_ cellForItemAtIndexPath:(NSIndexPath *)indexPath inputView:(UIKeyboardEmojiCollectionInputView *)inputView {
    UIKeyboardEmojiCollectionView *collectionView = (UIKeyboardEmojiCollectionView *)[inputView valueForKey:@"_collectionView"];
    UIKeyboardEmojiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kEmojiCellIdentifier" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        NSArray <UIKeyboardEmoji *> *recents = collectionView.inputController.recents;
        NSArray <UIKeyboardEmoji *> *prepolulatedEmojis = [self prepopulatedCategory].emoji;
        NSUInteger prepolulatedCount = [(UIKeyboardEmojiGraphicsTraits *)[inputView valueForKey:@"_emojiGraphicsTraits"] prepolulatedRecentCount];
        NSRange range = NSMakeRange(0, prepolulatedCount);
        if (recents.count) {
            NSUInteger idx = 0;
            NSMutableArray <UIKeyboardEmoji *> *array = [NSMutableArray arrayWithArray:recents];
            if (array.count < prepolulatedCount) {
                while (idx < prepolulatedEmojis.count && prepolulatedCount != array.count) {
                    UIKeyboardEmoji *emoji = prepolulatedEmojis[idx++];
                    if (![array containsObject:emoji])
                        [array addObject:emoji];
                }
            }
            cell.emoji = [array subarrayWithRange:range][indexPath.item];
        } else
            cell.emoji = [prepolulatedEmojis subarrayWithRange:range][indexPath.item];
    } else {
        NSInteger section = indexPath.section;
        if (IS_IOS_OR_NEWER(iOS_9_1))
            section = [NSClassFromString(@"UIKeyboardEmojiCategory") categoryTypeForCategoryIndex:section];
        UIKeyboardEmojiCategory *category = [NSClassFromString(@"UIKeyboardEmojiCategory") categoryForType:section];
        NSArray <UIKeyboardEmoji *> *emojis = category.emoji;
        cell.emoji = emojis[indexPath.item];
        if ((cell.emoji.variantMask & PSEmojiTypeSkin) && [PSEmojiUtilities sectionHasSkin:section]) {
            NSMutableDictionary <NSString *, NSString *> *skinPrefs = [collectionView.inputController skinToneBaseKeyPreferences];
            if (skinPrefs) {
                NSString *skinned = skinPrefs[[PSEmojiUtilities emojiBaseString:cell.emoji.emojiString]];
                if (skinned) {
                    cell.emoji.emojiString = skinned;
                    cell.emoji = cell.emoji;
                }
            }
        }
    }
    cell.emojiFontSize = [collectionView emojiGraphicsTraits].emojiKeyWidth;
    return cell;
}

+ (UIKeyboardEmoji *)emojiWithString:(NSString *)emojiString {
    UIKeyboardEmoji *emoji = nil;
    Class UIKeyboardEmoji = NSClassFromString(@"UIKeyboardEmoji");
    if ([UIKeyboardEmoji respondsToSelector:@selector(emojiWithString:hasDingbat:)])
        emoji = [UIKeyboardEmoji emojiWithString:emojiString hasDingbat:[self hasDingbat:emojiString]];
    else if ([UIKeyboardEmoji respondsToSelector:@selector(emojiWithString:)])
        emoji = [UIKeyboardEmoji emojiWithString:emojiString];
    else
        emoji = [[UIKeyboardEmoji alloc] initWithString:emojiString];
    if ([emoji respondsToSelector:@selector(setSupportsSkin:)])
        emoji.supportsSkin = [self hasSkinToneVariants:emojiString];
    return emoji;
}

+ (UIKeyboardEmoji *)emojiWithString:(NSString *)emojiString withVariantMask:(NSInteger)variantMask {
    return [NSClassFromString(@"UIKeyboardEmoji") emojiWithString:emojiString withVariantMask:variantMask];
}

+ (UIKeyboardEmoji *)emojiWithStringUniversal:(NSString *)emojiString {
    if ([NSClassFromString(@"UIKeyboardEmoji") respondsToSelector:@selector(emojiWithString:withVariantMask:)])
        return [self emojiWithString:emojiString withVariantMask:[self hasVariantsForEmoji:emojiString]];
    return [self emojiWithString:emojiString];
}

+ (void)addEmoji:(NSMutableArray <UIKeyboardEmoji *> *)emojiArray emojiString:(NSString *)emojiString withVariantMask:(NSInteger)variantMask {
    if (emojiString == nil)
        return;
    UIKeyboardEmoji *emoji = [self emojiWithString:emojiString withVariantMask:variantMask];
    if (emoji)
        [emojiArray addObject:emoji];
}

+ (void)addEmoji:(NSMutableArray <UIKeyboardEmoji *> *)emojiArray emojiString:(NSString *)emojiString {
    if (emojiString == nil)
        return;
    UIKeyboardEmoji *emoji = [self emojiWithString:emojiString];
    if (emoji)
        [emojiArray addObject:emoji];
}

+ (UIKeyboardEmojiCategory *)prepopulatedCategory {
    static UIKeyboardEmojiCategory *category = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        category = [[NSClassFromString(@"UIKeyboardEmojiCategory") alloc] init];
        category.categoryType = PSEmojiCategoryPrepopulated;
        NSArray <NSString *> *prepopulated = [self PrepopulatedEmoji];
        NSMutableArray <UIKeyboardEmoji *> *emojis = [NSMutableArray arrayWithCapacity:prepopulated.count];
        for (NSString *emojiString in prepopulated)
            [self addEmoji:emojis emojiString:emojiString withVariantMask:[self hasVariantsForEmoji:emojiString]];
        category.emoji = emojis;
    });
    return category;
}

#endif

+ (void)resetEmojiPreferences {
    id preferences = nil;
    id innerPreferences = nil;
    if (NSClassFromString(@"UIKeyboardEmojiPreferences")) {
        preferences = innerPreferences = [NSClassFromString(@"UIKeyboardEmojiPreferences") sharedInstance];
        if (IS_IOS_OR_NEWER(iOS_10_2))
            innerPreferences = [preferences valueForKey:@"_preferencesClient"];
    }
    else
        preferences = innerPreferences = [NSClassFromString(@"UIKeyboardEmojiDefaultsController") sharedController];
    if ([innerPreferences respondsToSelector:@selector(emptyDefaultsDictionary)])
        [innerPreferences setValue:[(UIKeyboardEmojiDefaultsController *)preferences emptyDefaultsDictionary] forKey:@"_defaults"];
    else
        [innerPreferences resetEmojiDefaults];
    [innerPreferences setValue:@(YES) forKey:@"_isDefaultDirty"];
    if ([preferences respondsToSelector:@selector(refreshLocalRecents)])
        [(UIKeyboardEmojiPreferences *)preferences refreshLocalRecents];
    [(UIKeyboardEmojiDefaultsController *)preferences writeEmojiDefaults];
}

#if !__LP64__

+ (CGGlyph)emojiGlyphShift:(CGGlyph)glyph {
    if (glyph >= 5 && glyph <= 16) // 0 - 9
        return glyph + 73;
    if (glyph == 4) // #
        return  glyph + 72;
    if (glyph == 44) // *
        return glyph + 33;
    return glyph;
}

#endif

#endif

@end
