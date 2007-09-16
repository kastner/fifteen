#import "NumberView.h"

@implementation NumberView
- (id) initWithFrame:(CGRect) frame andNumber:(int) theNumber {
  [super initWithFrame: frame];
  
  oOrigin = frame.origin;
  
  NSString *s = [NSString stringWithFormat:@"<div style='background-color:#444; text-align:center; font-size:28pt; padding-top:10px; width: %.fpx; height: %.fpx;'>%i</p>", frame.size.width, frame.size.height, theNumber];
  [self setHTML:s];
  
  number = theNumber;
  NSLog(@"num: %i", theNumber);
  return self;
}

- (int) number 
{
  return number;
}

- (void) slideTo:(CGPoint) newOrigin from:(CGPoint) oldOrigin
{
  [UIView beginAnimations:nil];
  [UIView setAnimationCurve:kUIAnimationCurveEaseInEaseOut];
  [UIView setAnimationDuration:.4];
  [self setOrigin:newOrigin];
  [UIView endAnimations];
}
@end

