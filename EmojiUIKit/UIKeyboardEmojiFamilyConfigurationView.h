#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UIKeyboardEmojiWellView.h"

@interface UIKeyboardEmojiFamilyConfigurationView : UIView // iOS 13.2+
@property (assign, nonatomic) BOOL usesDarkStyle;
@property (retain, nonatomic) NSMutableArray <UIStackView *> *familyMemberStackViews;
@property (retain, nonatomic) NSArray <NSArray <NSString *> *> *skinToneVariantRows;
@property (retain, nonatomic) NSArray <NSArray <NSString *> *> *variantDisplayRows; // iOS 14.5+
@property (retain, nonatomic) UIKeyboardEmojiWellView *neutralWellView;
@property (retain, nonatomic) UIKeyboardEmojiWellView *configuredWellView;
@property (retain, nonatomic) UIStackView *previewWellStackView;
@property (retain, nonatomic) NSString *baseEmojiString;
+ (UIColor *)_selectionAndSeparatorColorForDarkMode:(BOOL)darkMode;
- (NSMutableArray <NSNumber *> *)selectedVariantIndices;
- (NSArray <NSString *> *)_currentlySelectedSkinToneConfiguration;
- (NSUInteger)_silhouetteFromCurrentSelections; // iOS 14.5+
- (void)_updatePreviewWellForCurrentSelection;
- (void)_configureFamilyMemberWellStackViews;
@end