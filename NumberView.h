#import <UIKit/UIKit.h>
#import <UIKit/UIView-Geometry.h>
#import <UIKit/UIView-Animation.h>
// #import <UIKit/UITextView.h>
#import <UIKit/UIAnimator.h>
#import <UIKit/UITransformAnimation.h>
#import <UIKit/UIAnimation.h>

// constants
#define MOVESPEED 0.5

typedef enum {
  kUIAnimationCurveEaseInEaseOut,
  kUIAnimationCurveEaseIn,
  kUIAnimationCurveEaseOut,
  kUIAnimationCurveLinear
} UIAnimationCurve;

@interface NumberView : UIControl
{
  int number;
  CGPoint oOrigin;
}
- (id) initWithFrame:(CGRect) frame andNumber:(int) theNumber;
- (void) slideTo:(CGPoint) newOrigin from:(CGPoint) oldOrigin;
- (int) number;
@end

