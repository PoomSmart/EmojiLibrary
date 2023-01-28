#import <Foundation/Foundation.h>

// iOS 5-8.2
@interface UIKeyboardEmojiPage : UIView {
    NSInteger _numCols;
    NSInteger _numRows;
    NSInteger _numPages;
}
@property (retain, nonatomic) NSDictionary *emojiAttributes;
@property (retain, nonatomic) NSArray *emoji;
- (CGRect)rectForRow:(NSInteger)row Col:(NSInteger)col;
- (id)activeTouch;
- (void)touchCancelled:(id)touch;
@end
