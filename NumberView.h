#import <UIKit/UIKit.h>
#import <UIKit/UIView-Geometry.h>
#import <UIKit/UIView-Animation.h>
#import <UIKit/UITextView.h>
#import <UIKit/UIAnimator.h>
#import <UIKit/UITransformAnimation.h>
#import <UIKit/UIAnimation.h>

typedef enum {
  kUIAnimationCurveEaseInEaseOut,
  kUIAnimationCurveEaseIn,
  kUIAnimationCurveEaseOut,
  kUIAnimationCurveLinear
} UIAnimationCurve;

@interface NumberView : UITextView
{
  int number;
  CGPoint oOrigin;
}
- (id) initWithFrame:(CGRect) frame andNumber:(int) theNumber;
- (void) slideTo:(CGPoint) newOrigin from:(CGPoint) oldOrigin;
- (int) number;
@end

