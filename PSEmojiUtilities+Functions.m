#import "../PSHeader/Misc.h"
#include "PSEmojiType.h"
#include "Header.h"
#import "PSEmojiUtilities.h"
#import <TextInput/NSString+TIExtras.h>
#import <objc/runtime.h>
#import <version.h>

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
#if __LP64__ && !TARGET_OS_OSX && !FALLBACK_FLC
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
    return containsString(emojiString, HANDSHAKE_JOINER_ZWJ) || containsString(emojiString, HEART_JOINER);
}

+ (BOOL)isHandholingCoupleEmoji:(NSString *)emojiString {
    return [[self CoupleMultiSkinToneEmoji] containsObject:[NSString stringWithUnichar:[self firstLongCharacter:emojiString]]]
        || containsString(emojiString, HANDSHAKE_JOINER_ZWJ);
}

+ (BOOL)supportsCoupleSkinToneSelection:(NSString *)emojiString {
    return [self isHandholingCoupleEmoji:emojiString] || [self isCoupleMultiSkinToneEmoji:emojiString] || containsString(emojiString, @"‍❤️‍");
}

+ (NSArray <NSArray <NSString *> *> *)coupleSkinToneChooserVariantsForString:(NSString *)emojiString {
    PSEmojiMultiPersonType multiPersonType = [self multiPersonTypeForString:emojiString];
    if (multiPersonType) {
        NSString *joiner = [self joiningStringForCoupleString:emojiString] ?: HANDSHAKE_JOINER_ZWJ;
        return [self skinToneChooserArraysForCoupleType:multiPersonType joiner:joiner];
    }
    return nil;
}

+ (NSArray <NSString *> *)tokenizedMultiPersonFromString:(NSString *)emojiString {
    NSRange range = [emojiString rangeOfString:HANDSHAKE_JOINER_ZWJ options:NSLiteralSearch];
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

+ (PSEmojiMultiPersonType)multiPersonTypeForString:(NSString *)emojiString {
    NSString *baseFirst = [self emojiBaseFirstCharacterString:emojiString];
    if ([self isCoupleMultiSkinToneEmoji:baseFirst]) {
        if ([baseFirst isEqualToString:@"👫"])
            return PSEmojiMultiPersonTypeFM;
        if ([baseFirst isEqualToString:@"👭"])
            return PSEmojiMultiPersonTypeFF;
        if ([baseFirst isEqualToString:@"👬"])
            return PSEmojiMultiPersonTypeMM;
        if ([baseFirst isEqualToString:@"🧑‍🤝‍🧑"])
            return PSEmojiMultiPersonTypeNN;
    }
    if (emojiString && ([self isComposedCoupleMultiSkinToneEmoji:emojiString] || [self supportsCoupleSkinToneSelection:emojiString])) {
        NSArray *tokens = [self tokenizedMultiPersonFromString:emojiString];
        if (tokens.count != 2)
            return 0;
        NSString *baseLeft = [self emojiBaseFirstCharacterString:tokens[0]];
        NSString *baseRight = [self emojiBaseFirstCharacterString:tokens[1]];
        if ([baseLeft isEqualToString:WOMAN]) {
            if ([baseRight isEqualToString:WOMAN])
                return PSEmojiMultiPersonTypeFF;
            if ([baseRight isEqualToString:MAN])
                return PSEmojiMultiPersonTypeFM;
        }
        if ([baseLeft isEqualToString:MAN] && [baseRight isEqualToString:MAN])
            return PSEmojiMultiPersonTypeMM;
        if ([baseLeft isEqualToString:NEUTRAL] && [baseRight isEqualToString:NEUTRAL])
            return PSEmojiMultiPersonTypeNN;
    }
    return 0;
}

+ (NSString *)joiningStringForCoupleString:(NSString *)emojiString {
    if (containsString(emojiString, HANDSHAKE_JOINER_ZWJ) || [[self CoupleMultiSkinToneEmoji] containsObject:emojiString])
        return HANDSHAKE_JOINER_ZWJ;
    if (containsString(emojiString, HEART_KISS_JOINER) || containsString(emojiString, @"💏"))
        return HEART_KISS_JOINER;
    if (containsString(emojiString, HEART_JOINER) || containsString(emojiString, @"💑"))
        return HEART_JOINER;
    return nil;
}

+ (NSString *)skinToneSuffixFromSpecifierType:(NSString *)specifier {
    NSString *realSpecifier = [specifier stringByReplacingOccurrencesOfString:@"EMFSkinToneSpecifierTypeFitzpatrick" withString:@""];
    if ([realSpecifier isEqualToString:@"None"])
        return @"";
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
    return nil;
}

+ (NSString *)multiPersonStringForString:(NSString *)emojiString skinToneVariantSpecifier:(NSArray <NSString *> *)specifier {
    PSEmojiMultiPersonType multiPersonType = [self multiPersonTypeForString:emojiString];
    if (multiPersonType) {
        NSString *joiner = [self joiningStringForCoupleString:emojiString];
        BOOL hasSilhouette = [specifier containsObject:@"EMFSkinToneSpecifierTypeFitzpatrickSilhouette"];
        BOOL displayable = !hasSilhouette;
        NSString *solo = nil;
        NSString *firstSuffix = nil;
        NSString *lastSuffix = nil;
        if (hasSilhouette)
            displayable = [[specifier firstObject] isEqualToString:@"EMFSkinToneSpecifierTypeFitzpatrickSilhouette"]
                && [[specifier lastObject] isEqualToString:@"EMFSkinToneSpecifierTypeFitzpatrickSilhouette"];
        if (!displayable)
            specifier = @[@"EMFSkinToneSpecifierTypeFitzpatrick6", @"EMFSkinToneSpecifierTypeFitzpatrick6"];
        if (joiner) {
            NSString *first = [specifier firstObject];
            firstSuffix = [self skinToneSuffixFromSpecifierType:first];
            if (specifier.count == 2) {
                NSString *last = [specifier lastObject];
                lastSuffix = [self skinToneSuffixFromSpecifierType:last];
            } else
                lastSuffix = firstSuffix;
            if (![joiner isEqualToString:HANDSHAKE_JOINER_ZWJ]) {
                if (multiPersonType == PSEmojiMultiPersonTypeNN || firstSuffix.length) {
                    NSArray *tokens = [self tokenizedMultiPersonFromString:emojiString];
                    if (tokens.count <= 1)
                        tokens = @[NEUTRAL, NEUTRAL];
                    NSString *firstToken = [self emojiBaseString:[tokens firstObject]];
                    NSString *lastToken = [self emojiBaseString:[tokens lastObject]];
                    return [self coupleStringWithLeftPerson:firstToken leftVariant:firstSuffix joiningString:joiner rightPerson:lastToken rightVariant:lastSuffix];
                }
                return [self emojiBaseString:emojiString];
            }
            switch (multiPersonType) {
                case PSEmojiMultiPersonTypeMM: {
                    if (firstSuffix == nil || lastSuffix == nil)
                        return @"👬";
                    if ([firstSuffix isEqualToString:lastSuffix] && !hasSilhouette)
                        return [NSString stringWithFormat:@"%@%@", @"👬", firstSuffix];
                    solo = MAN;
                    break;
                }
                case PSEmojiMultiPersonTypeFF: {
                    if (firstSuffix == nil || lastSuffix == nil)
                        return @"👭";
                    if ([firstSuffix isEqualToString:lastSuffix] && !hasSilhouette)
                        return [NSString stringWithFormat:@"%@%@", @"👭", firstSuffix];
                    solo = WOMAN;
                    break;
                }
                case PSEmojiMultiPersonTypeFM: {
                    if (firstSuffix == nil || lastSuffix == nil)
                        return @"👫";
                    if (![firstSuffix isEqualToString:lastSuffix] || hasSilhouette)
                        return [NSString stringWithFormat:@"%@%@%@%@%@", WOMAN, firstSuffix, HANDSHAKE_JOINER_ZWJ, MAN, lastSuffix];
                    return [NSString stringWithFormat:@"%@%@", @"👫", firstSuffix];
                }
                default:
                    break;
            }
        }
        return [NSString stringWithFormat:@"%@%@%@%@%@", solo, firstSuffix, HANDSHAKE_JOINER_ZWJ, solo, lastSuffix];
    }
    return nil;
}

+ (NSArray <NSArray <NSString *> *> *)skinToneChooserArraysForCoupleType:(PSEmojiMultiPersonType)coupleType joiner:(NSString *)joiner {
    NSMutableArray *first = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *second = [NSMutableArray arrayWithCapacity:5];
    NSString *leftPerson = nil;
    NSString *rightPerson = nil;
    NSString *duo = nil;
    switch (coupleType) {
        case PSEmojiMultiPersonTypeFM:
            leftPerson = WOMAN;
            rightPerson = MAN;
            duo = @"👫";
            break;
        case PSEmojiMultiPersonTypeFF:
            leftPerson = rightPerson = WOMAN;
            duo = @"👭";
            break;
        case PSEmojiMultiPersonTypeMM:
            leftPerson = rightPerson = MAN;
            duo = @"👬";
            break;
        case PSEmojiMultiPersonTypeNN:
            leftPerson = rightPerson = NEUTRAL;
            break;
    }
    for (NSString *skin in [PSEmojiUtilities skinModifiers]) {
        [first addObject:[self coupleStringWithLeftPerson:leftPerson leftVariant:skin joiningString:joiner rightPerson:rightPerson rightVariant:nil]];
        [second addObject:[NSString stringWithFormat:@"%@%@", duo, skin]];
    }
    return @[first, second];
}

+ (NSArray <NSArray <NSString *> *> *)skinToneChooserVariantsForHandHoldingCoupleType:(PSEmojiMultiPersonType)coupleType {
    if (coupleType == PSEmojiMultiPersonTypeNN)
        return [self skinToneChooserArraysForCoupleType:coupleType joiner:HANDSHAKE_JOINER_ZWJ];
    NSMutableArray *first = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *second = [NSMutableArray arrayWithCapacity:5];
    switch (coupleType) {
        case PSEmojiMultiPersonTypeFM: {
            for (NSString *skin in [PSEmojiUtilities skinModifiers]) {
                [first addObject:[NSString stringWithFormat:@"%@%@%@%@%@", WOMAN, skin, HANDSHAKE_JOINER_ZWJ, MAN, ZWJ]];
                [second addObject:[NSString stringWithFormat:@"%@%@%@%@%@", WOMAN, ZWJ, HANDSHAKE_JOINER_ZWJ, MAN, skin]];
            }
            break;
        }
        case PSEmojiMultiPersonTypeFF: {
            for (NSString *skin in [PSEmojiUtilities skinModifiers]) {
                [first addObject:[NSString stringWithFormat:@"%@%@%@%@%@", WOMAN, skin, HANDSHAKE_JOINER_ZWJ, WOMAN, ZWJ]];
                [second addObject:[NSString stringWithFormat:@"%@%@%@%@%@", WOMAN, ZWJ, HANDSHAKE_JOINER_ZWJ, WOMAN, skin]];
            }
            break;
        }
        case PSEmojiMultiPersonTypeMM: {
            for (NSString *skin in [PSEmojiUtilities skinModifiers]) {
                [first addObject:[NSString stringWithFormat:@"%@%@%@%@%@", MAN, skin, HANDSHAKE_JOINER_ZWJ, MAN, ZWJ]];
                [second addObject:[NSString stringWithFormat:@"%@%@%@%@%@", MAN, ZWJ, HANDSHAKE_JOINER_ZWJ, MAN, skin]];
            }
            break;
        }
        default:
            return @[];
    }
    return @[first, second];
}

+ (NSArray <NSArray <NSString *> *> *)skinToneChooserVariantsForString:(NSString *)emojiString usesSilhouetteSpecifiers:(BOOL)silhouette {
    PSEmojiMultiPersonType multiPersonType = [self multiPersonTypeForString:emojiString];
    if (multiPersonType) {
        if (silhouette)
            return [self skinToneChooserVariantsForHandHoldingCoupleType:multiPersonType];
        NSString *joiner = [self joiningStringForCoupleString:emojiString] ?: HANDSHAKE_JOINER_ZWJ;
        return [self skinToneChooserArraysForCoupleType:multiPersonType joiner:joiner];
    }
    return nil;
}

+ (NSArray <NSArray <NSString *> *> *)skinToneChooserVariantsForString:(NSString *)emojiString {
    PSEmojiMultiPersonType multiPersonType = [self multiPersonTypeForString:emojiString];
    if (multiPersonType)
        return [self skinToneChooserVariantsForString:emojiString usesSilhouetteSpecifiers:YES];
    return nil;
}

+ (BOOL)hasSkin:(NSString *)emojiString {
    return [self getSkin:emojiString] != nil;
}

+ (NSString *)changeEmojiSkin:(NSString *)emojiString toSkin:(NSString *)skin {
    NSString *oldSkin = [self getSkin:emojiString];
    if (oldSkin == nil || stringEqual(oldSkin, skin))
        return emojiString;
    return [emojiString stringByReplacingOccurrencesOfString:oldSkin withString:skin options:NSLiteralSearch range:NSMakeRange(0, emojiString.length)];
}

+ (NSString *)emojiGenderString:(NSString *)emojiString baseFirst:(NSString *)baseFirst skin:(NSString *)skin {
    NSString *_baseFirst = baseFirst ? baseFirst : [self emojiBaseFirstCharacterString:emojiString];
    BOOL needVariantSelector = [self genderEmojiBaseStringNeedVariantSelector:_baseFirst];
    NSString *_skin = skin ? skin : @"";
    NSString *variantSelector = _skin.length == 0 && needVariantSelector ? FE0F : @"";
    if (containsString(emojiString, FEMALE))
        return [NSString stringWithFormat:@"%@%@%@%@", _baseFirst, variantSelector, _skin, ZWJ2640FE0F];
    else if (containsString(emojiString, MALE))
        return [NSString stringWithFormat:@"%@%@%@%@", _baseFirst, variantSelector, _skin, ZWJ2642FE0F];
    return nil;
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
    return [[self CoupleMultiSkinToneEmoji] containsObject:emojiString] || [[self ExtendedCoupleMultiSkinToneEmoji] containsObject:emojiString];
}

+ (BOOL)isMultiPersonFamilySkinToneEmoji:(NSString *)emojiString {
    return [[self MultiPersonFamilySkinToneEmoji] containsObject:emojiString];
}

+ (NSString *)emojiBaseString:(NSString *)emojiString {
    if ([self isProfessionEmoji:emojiString]
        || [self isFlagEmoji:emojiString]
        || [self isCoupleMultiSkinToneEmoji:emojiString]
        || [self isMultiPersonFamilySkinToneEmoji:emojiString])
        return emojiString;
    NSInteger multiPersonType = [self multiPersonTypeForString:emojiString];
    if (multiPersonType) {
        NSString *joiner = [self joiningStringForCoupleString:emojiString];
        if (joiner == nil || [self isHandholingCoupleEmoji:emojiString]) {
            switch (multiPersonType) {
                case PSEmojiMultiPersonTypeFM:
                    return @"👫";
                case PSEmojiMultiPersonTypeFF:
                    return @"👭";
                case PSEmojiMultiPersonTypeMM:
                    return @"👬";
                case PSEmojiMultiPersonTypeNN:
                    return @"🧑‍🤝‍🧑";
            }
        } else {
            if (multiPersonType != PSEmojiMultiPersonTypeNN) {
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
    NSString *baseFirst = [self emojiBaseFirstCharacterString:emojiString];
    if ([self hasGender:emojiString])
        return [self emojiGenderString:emojiString baseFirst:baseFirst skin:nil];
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

+ (NSString *)skinToneVariant:(NSString *)emojiString baseFirst:(NSString *)baseFirst base:(NSString *)base skin:(NSString *)skin {
    NSString *_baseFirst = baseFirst ? baseFirst : [self emojiBaseFirstCharacterString:emojiString];
    NSString *_base = base ? base : [self emojiBaseString:emojiString];
    if ([self isGenderEmoji:_baseFirst] && [self hasGender:emojiString])
        return [self emojiGenderString:emojiString baseFirst:_baseFirst skin:skin];
    if ([self isProfessionEmoji:_base]) {
        NSRange baseRange = [_base rangeOfString:_baseFirst options:NSLiteralSearch];
        return baseRange.location != NSNotFound ? [_base stringByReplacingCharactersInRange:baseRange withString:[NSString stringWithFormat:@"%@%@", _baseFirst, skin]] : nil;
    }
    if ([self isDingbatVariantsEmoji:baseFirst])
        return [NSString stringWithFormat:@"%@%@%@", baseFirst, skin, FE0F];
    return [NSString stringWithFormat:@"%@%@", _baseFirst, skin];
}

+ (NSString *)skinToneVariant:(NSString *)emojiString skin:(NSString *)skin {
    return [self skinToneVariant:emojiString baseFirst:nil base:nil skin:skin];
}

+ (NSMutableArray <NSString *> *)skinToneVariantsForMultiPersonType:(PSEmojiMultiPersonType)multiPersonType {
    NSMutableArray *variants = [NSMutableArray array];
    for (NSString *leftSkin in [PSEmojiUtilities skinModifiers]) {
        for (NSString *rightSkin in [PSEmojiUtilities skinModifiers]) {
            if ([leftSkin isEqualToString:rightSkin]) {
                NSString *couple = nil;
                switch (multiPersonType) {
                    case PSEmojiMultiPersonTypeFM:
                        couple = @"👫";
                        break;
                    case PSEmojiMultiPersonTypeFF:
                        couple = @"👭";
                        break;
                    case PSEmojiMultiPersonTypeMM:
                        couple = @"👬";
                        break;
                    case PSEmojiMultiPersonTypeNN:
                        couple = @"🧑‍🤝‍🧑";
                        break;
                }
                if (couple)
                    [variants addObject:[NSString stringWithFormat:@"%@%@", couple, leftSkin]];
            } else {
                switch (multiPersonType) {
                    case PSEmojiMultiPersonTypeFM:
                        [variants addObject:[NSString stringWithFormat:@"👩%@‍🤝‍👨%@", leftSkin, rightSkin]];
                        break;
                    case PSEmojiMultiPersonTypeFF:
                        [variants addObject:[NSString stringWithFormat:@"👩%@‍🤝‍👩%@", leftSkin, rightSkin]];
                        break;
                    case PSEmojiMultiPersonTypeMM:
                        [variants addObject:[NSString stringWithFormat:@"👨%@‍🤝‍👨%@", leftSkin, rightSkin]];
                        break;
                    case PSEmojiMultiPersonTypeNN:
                        [variants addObject:[NSString stringWithFormat:@"🧑%@‍🤝‍🧑%@", leftSkin, rightSkin]];
                        break;
                }
            }
        }
    }
    return variants;
}

+ (NSMutableArray <NSString *> *)skinToneVariantsForCouple:(PSEmojiMultiPersonType)multiPersonType joiner:(NSString *)joiner {
    NSMutableArray *variants = [NSMutableArray array];
    NSString *leftPerson = nil;
    NSString *rightPerson = nil;
    switch (multiPersonType) {
        case PSEmojiMultiPersonTypeFM:
            leftPerson = WOMAN;
            rightPerson = MAN;
            break;
        case PSEmojiMultiPersonTypeFF:
            leftPerson = rightPerson = WOMAN;
            break;
        case PSEmojiMultiPersonTypeMM:
            leftPerson = rightPerson = MAN;
            break;
        case PSEmojiMultiPersonTypeNN:
            leftPerson = rightPerson = NEUTRAL;
            break;
    }
    if (leftPerson == nil || rightPerson == nil)
        return [NSMutableArray array];
    for (NSString *leftSkin in [PSEmojiUtilities skinModifiers]) {
        for (NSString *rightSkin in [PSEmojiUtilities skinModifiers]) {
            [variants addObject:[self coupleStringWithLeftPerson:leftPerson leftVariant:leftSkin joiningString:joiner rightPerson:rightPerson rightVariant:rightSkin]];
        }
    }
    return variants;
}

+ (NSMutableArray <NSString *> *)skinToneVariants:(NSString *)emojiString isSkin:(BOOL)isSkin withSelf:(BOOL)withSelf {
    PSEmojiMultiPersonType multiPersonType = [self multiPersonTypeForString:emojiString];
    if (multiPersonType) {
        NSString *joiner = [self joiningStringForCoupleString:emojiString] ?: HANDSHAKE_JOINER_ZWJ;
        if ([self isHandholingCoupleEmoji:emojiString])
            return [self skinToneVariantsForMultiPersonType:multiPersonType];
        return [self skinToneVariantsForCouple:multiPersonType joiner:joiner];
    }
    NSString *baseFirst = [self emojiBaseFirstCharacterString:emojiString];
    if (isSkin || [self isSkinToneEmoji:baseFirst]) {
        NSString *base = [self emojiBaseString:emojiString];
        NSMutableArray <NSString *> *skins = [NSMutableArray array];
        if (withSelf)
            [skins addObject:base];
        for (NSString *skin in [self skinModifiers])
            [skins addObject:[self skinToneVariant:emojiString baseFirst:baseFirst base:base skin:skin]];
        return skins;
    }
    return nil;
}

+ (NSMutableArray <NSString *> *)skinToneVariants:(NSString *)emojiString isSkin:(BOOL)isSkin {
    return [self skinToneVariants:emojiString isSkin:isSkin withSelf:NO];
}

+ (NSMutableArray <NSString *> *)skinToneVariants:(NSString *)emojiString withSelf:(BOOL)withSelf {
    return [self hasSkinToneVariants:emojiString] ? [self skinToneVariants:emojiString isSkin:YES withSelf:withSelf] : nil;
}

+ (NSMutableArray <NSString *> *)skinToneVariants:(NSString *)emojiString {
    return [self skinToneVariants:emojiString withSelf:NO];
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

+ (UIKeyboardEmoji *)emojiWithString:(NSString *)emojiString {
    UIKeyboardEmoji *emoji = nil;
    if ([NSClassFromString(@"UIKeyboardEmoji") respondsToSelector:@selector(emojiWithString:hasDingbat:)])
        emoji = [NSClassFromString(@"UIKeyboardEmoji") emojiWithString:emojiString hasDingbat:[self hasDingbat:emojiString]];
    else if ([NSClassFromString(@"UIKeyboardEmoji") respondsToSelector:@selector(emojiWithString:)])
        emoji = [NSClassFromString(@"UIKeyboardEmoji") emojiWithString:emojiString];
    else
        emoji = [[[NSClassFromString(@"UIKeyboardEmoji") alloc] initWithString:emojiString] autorelease];
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

#if !__arm64e__

+ (BOOL)sectionHasSkin:(NSInteger)section {
    return section <= PSEmojiCategoryPeople || ((IS_IOS_OR_NEWER(iOS_9_1) && (section == PSEmojiCategoryActivity || section == PSEmojiCategoryObjects)) || (!IS_IOS_OR_NEWER(iOS_9_1) && (section == IDXPSEmojiCategoryActivity || section == IDXPSEmojiCategoryObjects)));
}

+ (NSString *)overrideKBTreeEmoji:(NSString *)emojiString {
    if (emojiString.length >= 4) {
        NSString *skin = [self getSkin:emojiString];
        if (skin) {
            NSString *emojiWithoutSkin = [self changeEmojiSkin:emojiString toSkin:@""];
            NSString *result = [self skinToneVariant:emojiWithoutSkin skin:skin];
            return result;
        }
    }
    return emojiString;
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

#if !TARGET_OS_OSX

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

#endif

#endif

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

+ (void)resetEmojiPreferences {
    if (IS_IOS_OR_NEWER(iOS_11_0)) {
        // Better approach: Reset keyboard dictionary
        return;
    }
#if !__arm64e__
    id preferences;
    if (NSClassFromString(@"UIKeyboardEmojiPreferences"))
        preferences = [NSClassFromString(@"UIKeyboardEmojiPreferences") sharedInstance];
    else
        preferences = [NSClassFromString(@"UIKeyboardEmojiDefaultsController") sharedController];
    object_setInstanceVariable(preferences, "_defaults", (void *)[[(UIKeyboardEmojiDefaultsController *)preferences emptyDefaultsDictionary] retain]);
    object_setInstanceVariable(preferences, "_isDefaultDirty", (void *)YES);
    [(UIKeyboardEmojiDefaultsController *)preferences writeEmojiDefaults];
#endif
}

@end
