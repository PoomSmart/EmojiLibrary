#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UIKeyboardEmojiWellView.h"

@interface UIKeyboardEmojiFamilyConfigurationView : UIView // iOS 13.2+
- (UIKeyboardEmojiWellView *)configuredWellView;
- (NSMutableArray <NSNumber *> *)selectedVariantIndices;
- (NSArray <NSString *> *)_currentlySelectedSkinToneConfiguration;
- (NSString *)baseEmojiString;
- (NSUInteger)_silhouetteFromCurrentSelections; // iOS 14.5+
@end