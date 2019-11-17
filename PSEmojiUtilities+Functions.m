#import "PSEmojiUtilities.h"
#import <objc/runtime.h>

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

+ (UChar)firstLongCharacter:(NSString *)string {
#if __LP64__ && !TARGET_OS_OSX
    return [string _firstLongCharacter];
#else
    UChar cbase = 0;
    if (string.length) {
        cbase = [string characterAtIndex:0];
        if ((cbase & 0xFC00) == 0xD800 && string.length >= 2) {
            UChar y = [string characterAtIndex:1];
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
    return containsString(emojiString, @"‍🤝‍");
}

+ (NSArray <NSString *> *)tokenizedMultiPersonFromString:(NSString *)emojiString {
    NSUInteger tokenizer = [emojiString rangeOfString:@"🤝" options:NSLiteralSearch].location;
    if (tokenizer != NSNotFound) {
        NSString *left = [emojiString substringToIndex:tokenizer - 1];
        NSString *right = [emojiString substringFromIndex:tokenizer + 3];
        if (left && right) return @[left, right];
    }
    return @[];
}

+ (NSInteger)multiPersonTypeForString:(NSString *)emojiString {
    NSString *baseFirst = [self emojiBaseFirstCharacterString:emojiString];
    if ([self isCoupleMultiSkinToneEmoji:baseFirst]) {
        if ([baseFirst isEqualToString:@"👫"])
            return 1; // FM
        if ([baseFirst isEqualToString:@"👭"])
            return 2; // FF
        if ([baseFirst isEqualToString:@"👬"])
            return 3; // MM
    }
    if ([self isComposedCoupleMultiSkinToneEmoji:emojiString]) {
        NSArray *tokens = [self tokenizedMultiPersonFromString:emojiString];
        if (tokens.count != 2)
            return 0;
        NSString *baseLeft = [self emojiBaseFirstCharacterString:tokens[0]];
        NSString *baseRight = [self emojiBaseFirstCharacterString:tokens[1]];
        if ([baseLeft isEqualToString:@"👩"]) {
            if ([baseRight isEqualToString:@"👩"])
                return 2;
            if ([baseRight isEqualToString:@"👨"])
                return 1;
        }
        if ([baseLeft isEqualToString:@"👨"] && [baseRight isEqualToString:@"👨"])
            return 3;
        if ([baseLeft isEqualToString:@"🧑"] && [baseRight isEqualToString:@"🧑"])
            return 4;
    }
    return 0;
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
    return [[self CoupleMultiSkinToneEmoji] containsObject:emojiString];
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
    switch (multiPersonType) {
        case 1:
            return @"👫";
        case 2:
            return @"👭";
        case 3:
            return @"👬";
        case 4:
            return @"🧑‍🤝‍🧑";
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

+ (NSMutableArray <NSString *> *)coupleSkinToneVariants:(NSString *)emojiString {
    NSArray *couple = [self CoupleMultiSkinToneEmoji];
    NSUInteger type = [couple indexOfObject:[self emojiBaseString:emojiString]];
    if (type != NSNotFound) {
        NSMutableArray *variants = [NSMutableArray array];
        for (NSString *leftSkin in [PSEmojiUtilities skinModifiers]) {
            for (NSString *rightSkin in [PSEmojiUtilities skinModifiers]) {
                if (type != 3 && [leftSkin isEqualToString:rightSkin])
                    [variants addObject:[NSString stringWithFormat:@"%@%@", couple[type], leftSkin]];
                else {
                    switch (type) {
                        case 0:
                            [variants addObject:[NSString stringWithFormat:@"👩%@‍🤝‍👩%@", leftSkin, rightSkin]];
                            break;
                        case 1:
                            [variants addObject:[NSString stringWithFormat:@"👨%@‍🤝‍👨%@", leftSkin, rightSkin]];
                            break;
                        case 2:
                            [variants addObject:[NSString stringWithFormat:@"👩%@‍🤝‍👨%@", leftSkin, rightSkin]];
                            break;
                        case 3:
                            [variants addObject:[NSString stringWithFormat:@"🧑%@‍🤝‍🧑%@", leftSkin, rightSkin]];
                            break;
                    }
                }
            }
        }
        return variants;
    }
    return nil;
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

+ (NSMutableArray <NSString *> *)skinToneVariants:(NSString *)emojiString isSkin:(BOOL)isSkin withSelf:(BOOL)withSelf {
    NSString *baseFirst = [self emojiBaseFirstCharacterString:emojiString];
    if (isSkin || [self isSkinToneEmoji:baseFirst]) {
        NSString *base = [self emojiBaseString:emojiString];
        if ([self isCoupleMultiSkinToneEmoji:base])
            return [self coupleSkinToneVariants:base];
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
    return section <= PSEmojiCategoryPeople || ((isiOS91Up && (section == PSEmojiCategoryActivity || section == PSEmojiCategoryObjects)) || (!isiOS91Up && (section == IDXPSEmojiCategoryActivity || section == IDXPSEmojiCategoryObjects)));
}

+ (NSString *)overrideKBTreeEmoji:(NSString *)emojiString {
    if (emojiString.length >= 4) {
        NSString *skin = [self getSkin:emojiString];
        if (skin) {
            NSString *emojiWithoutSkin = [self changeEmojiSkin:emojiString toSkin:@""];
            NSString *result = [self skinToneVariant:emojiWithoutSkin skin:skin];
            HBLogDebug(@"Removing %@ from the invalid %@ -> %@ to get %@", skin, emojiString, emojiWithoutSkin, result);
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
        if (isiOS91Up)
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
    else if (glyph == 4) // #
        return  glyph + 72;
    else if (glyph == 44) // *
        return glyph + 33;
    return glyph;
}

#endif

+ (void)resetEmojiPreferences {
    if (isiOS11Up) {
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
