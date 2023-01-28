#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIKeyboardEmojiWellView : UIView // iOS 13.2+
@property (retain, nonatomic) UIView *wellContentView;
@property (retain, nonatomic) UIFont *labelFont;
@property (retain, nonatomic) NSString *stringRepresentation;
@property (retain, nonatomic) UIColor *selectionBackgroundColor;
@property (retain, nonatomic) NSIndexPath *associatedIndexPath;
- (UIFont *)fontUsingSilhouette:(NSUInteger)silhouette size:(CGFloat)size; // iOS 14.5+
- (void)setStringRepresentation:(NSString *)representation silhouette:(NSUInteger)silhouette; // iOS 14.5+
@end