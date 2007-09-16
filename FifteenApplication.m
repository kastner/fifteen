#import "FifteenApplication.h"

@interface NumberView : UITextView
{
  int number;
}
- initWithFrame:(CGRect) frame andNumber:(int) theNumber;
@end

@implementation NumberView
- initWithFrame:(CGRect) frame andNumber:(int) theNumber {
  [super initWithFrame: frame];
  NSString *s = [NSString stringWithFormat:@"<div style='background-color:#444; text-align:center; font-size:28pt; padding-top:10px; width: %.fpx; height: %.fpx;'>%i</p>", frame.size.width, frame.size.height, theNumber];
  // NSLog(s);
  // [tv setMarginTop: 1];
  [self setHTML:s];
  
  number = theNumber;
  NSLog(@"num: %i", theNumber);
  return self;
}
@end

@implementation FifteenApplication

- (void) applicationDidFinishLaunching: (id) unused
{

  CGRect rect = [UIHardware fullScreenApplicationContentRect];
  rect.origin.x = rect.origin.y = 0;
  NSLog(@"x:%.f y:%.f w:%.f h:%.f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
  UIWindow *window = [[UIWindow alloc] initWithContentRect:rect];
  [window orderFront: self];
  [window makeKey: self];
  [window _setHidden: NO];

  UIView *mainView = [[UIView alloc] initWithFrame: rect];
  UITextView *textView = [[UITextView alloc] initWithFrame: rect];
  
  // 80
  float size = 77.0f;
  int x,y;
  for (y=0; y<4; y++) {
    for (x=0; x<4; x++) {
      int theNumber = x + 1 + (y * 4);
      if (theNumber == 16) { continue; }
      // NSLog(@"theNumber: %i", theNumber);
      NumberView *tv = [[NumberView alloc] initWithFrame: CGRectMake(x * size, y * size + 100.0f, size, size) andNumber: theNumber];
      // [tv setText:[NSString stringWithFormat:@"%i", theNumber]];
      [textView addSubview: tv];
    }
  }
  
  [mainView addSubview: textView];
  [window setContentView:mainView];
  [window setNeedsDisplay];  
}

@end
