#import "FifteenApplication.h"

@interface MyPoint : NSObject
{
  int x,y;
}
- (id)initWithCGPoint:(CGPoint)point;
- (CGPoint)asCGPoint;
@end

@implementation MyPoint
- (id)initWithCGPoint:(CGPoint)point 
{
  [super init];
  x = point.x;
  y = point.y;
  return self;
}

- (CGPoint)asCGPoint
{
  return CGPointMake(x,y);
}
@end

@implementation FifteenApplication

- (void) moveBlockAt:(CGPoint) start to:(CGPoint) end
{
  int startX = (int)start.x;
  int startY = (int)start.y;
  int endX = (int)end.x;
  int endY = (int)end.y;
  
  CGPoint newO = [self spotForX: endX y: endY];
  [board[startX][startY] slideTo: [self spotForX: endY y: endY]];
  NSLog(@"going to: %i/%i: %.f, %.f", (int)end.x, (int)end.y, newO.x, newO.y);
  board[endX][endY] = board[startX][startY];
  board[startX][startY] = nil;
}

- (void) moveBlockToOpen:(CGPoint) block
{
  [self moveBlockAt: block to: [self openSpot]];
}

- (void) moveRandomBlockToOpen
{
  NSLog(@"Random move!");
  NSMutableArray *canidates = [[NSMutableArray alloc] init];
  CGPoint open = [self openSpot];
  int oX = open.x;
  int oY = open.y;
  
  NSLog(@"openX: %.f  openY: %.f", [self openSpot].x, [self openSpot].y);
  
  int x,y;
  for (y=-1; y<=1; y++) {
    for (x=-1; x<=1; x++) {
      // NSLog(@"%@", board[x+oX][y+oY]);
      int checkX = x + oX;
      int checkY = y + oY;
      NSLog(@"checkX: %i checkY: %i", checkX, checkY);
      if (checkX < numBlocks && checkY < numBlocks && checkX >= 0 && checkY >= 0) {
        NSLog(@"   ------MADE IT.");
        if (board[checkX][checkY] != nil) {
          [canidates addObject: [[MyPoint alloc] initWithCGPoint: CGPointMake(x,y)]];
        }        
      }
    }
  }
  
  int count = [canidates count];
  int random = rand() % count;
  [self moveBlockToOpen: [[canidates objectAtIndex: random]asCGPoint]];
}

- (CGPoint) spotForX:(int) x y:(int) y
{
  return CGPointMake(x * blockSize, y * blockSize + 100.0f);
}

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
  
  numBlocks = 4;
  blockSize = 77.0f;
  
  int x,y;
  for (y=0; y<numBlocks; y++) {
    for (x=0; x<numBlocks; x++) {
      board[x][y] = nil;
      int theNumber = x + 1 + (y * numBlocks);

      CGPoint origin = [self spotForX:x y:y];
      NSLog(@"%i/%i = %.f, %.f", x, y, origin.x, origin.y);

      if (theNumber == 16) { continue; }
      // NSLog(@"theNumber: %i", theNumber);
      NumberView *tv = [[NumberView alloc] initWithFrame: CGRectMake(origin.x, origin.y, blockSize, blockSize) andNumber: theNumber];
      // [tv setText:[NSString stringWithFormat:@"%i", theNumber]];
      [textView addSubview: tv];
      board[x][y] = tv;
    }
  }
  // [self moveBlockToOpen:CGPointMake(3,2)];
  // [board[3][2] moveTo: CGPointMake(10.0f, 10.0f)];
  // [self moveBlockAt:CGPointMake(3,2) to:CGPointMake(3,3)];
  // [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(moveBlockToOpen:) userInfo:CGPointMake(2,2) repeats:NO];
  // [self moveBlockAt:CGPointMake(2,2) to:CGPointMake(3,2)];
  // [self moveBlockAt:CGPointMake(1,2) to:CGPointMake(2,2)];
  // [self moveBlockAt:CGPointMake(1,1) to:CGPointMake(1,2)];
  int i;
  for (i=0; i<10; i++) {
    // [NSTimer scheduledTimerWithTimeInterval:i target:self selector:@selector(moveRandomBlockToOpen) userInfo:nil repeats:NO];
  }
  
  CGPoint p = [self openSpot];
  [mainView addSubview: textView];
  [window setContentView:mainView];
  [window setNeedsDisplay];  
}

- (CGPoint) openSpot
{
  int x,y;
  for (y=0; y<numBlocks; y++) {
    for (x=0; x<numBlocks; x++) {
      if (board[x][y] == nil) {
        NSLog(@"**Open spot: %i, %i", x, y);
        return CGPointMake(x,y);
      }
      else {
        NSLog(@"bbb %@: %i, %i", board[x][y], x, y);
      }
    }
  }
}
@end
