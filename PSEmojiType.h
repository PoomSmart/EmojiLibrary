/* PSEmojiType: Emoji variants
   XXXX: 4 binary digits of (Profession)-(Gender)-(Skin)-(Dingbat)
 */

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PSEmojiType) {
    PSEmojiTypeProfession = 1 << 3, // 10.2+
    PSEmojiTypeGender = 1 << 2,     // 10.0+
    PSEmojiTypeSkin = 1 << 1,
    PSEmojiTypeDingbat = 1,
    PSEmojiTypeRegular = 0
};

typedef NS_ENUM(NSInteger, PSEmojiMultiSkinType) {
    PSEmojiMultiSkinTypeFM = 1,
    PSEmojiMultiSkinTypeFF = 2,
    PSEmojiMultiSkinTypeMM = 3,
    PSEmojiMultiSkinTypeNN = 4,
    PSEmojiMultiSkinTypeHandshake = 5
};
