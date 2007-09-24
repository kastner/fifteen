#import "NumberView.h"

@implementation NumberView
- (id) initWithFrame:(CGRect) frame andNumber:(int) theNumber {
  [super initWithFrame: frame];
  
  oOrigin = frame.origin;
  
  // NSString *s = [NSString stringWithFormat:@"<div style='background-color:#444; text-align:center; font-size:28pt; padding-top:10px; width: %.fpx; height: %.fpx;'>%i</p>", frame.size.width, frame.size.height, theNumber];
  // [self setEditable:NO];
  // [self setHTML:s];
  
  if (theNumber > 0) {
    NSString *img = [NSString stringWithFormat:@"tile%i.png", theNumber];
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage applicationImageNamed:img]];
    [self addSubview: iv];
    [iv release];
    // [self setImage: [UIImage applicationImageNamed:img]];    
  }
  
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
  [UIView setAnimationDuration:MOVESPEED];
  [self setOrigin:newOrigin];
  [UIView endAnimations];
}
@end

