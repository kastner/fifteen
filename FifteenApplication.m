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
  x = (int )point.x;
  y = (int )point.y;
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
  [board[startX][startY] slideTo: [self spotForX: endX y: endY] from: [self spotForX: startX y: startY]];
  // NSLog(@"going to: %i/%i: %.f, %.f from: %i/%i\n\n\n", (int)end.x, (int)end.y, newO.x, newO.y, (int)start.x, (int)start.y);
  
  NumberView *t = board[endX][endY];
  board[endX][endY] = board[startX][startY];
  board[startX][startY] = t;
}

- (void) moveBlockToOpen:(CGPoint) block
{
  [self moveBlockAt: block to: [self openSpot]];
}

- (void) moveRandomBlockToOpen
{
  srand(time(0));
  
  NSMutableArray *canidates = [[NSMutableArray alloc] init];
  CGPoint open = [self openSpot];
  int oX = (int)open.x;
  int oY = (int)open.y;
  
  int x,y;
  for (y=-1; y<=1; y++) {
    for (x=-1; x<=1; x++) {
      int checkX = x + oX;
      int checkY = y + oY;
      if (checkX == (int)lastHole.x && checkY == (int)lastHole.y) { continue; }
      if (checkX < numBlocks && checkY < numBlocks && checkX >= 0 && checkY >= 0 && abs(x) != abs(y)) {
        if ([board[checkX][checkY] number] != -1) {
          [canidates addObject: [[MyPoint alloc] initWithCGPoint: CGPointMake(checkX, checkY)]];
        }        
      }
    }
  }
  
  int count = [canidates count];
  int random = rand() % count;

  lastHole = [self openSpot];
  
  [self moveBlockToOpen: [[canidates objectAtIndex: random]asCGPoint]];
  
  [canidates release];
}

- (CGPoint) spotForX:(int) x y:(int) y
{
  return CGPointMake(x * blockSize, y * blockSize + 50.0f);
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
  
  // int j;
  // for (j = 0; j < numBlocks; j++) { 
  //   board[j] = malloc(numBlocks * sizeof(int *)); 
  // }
  
  int x,y;
  for (y=0; y<numBlocks; y++) {
    for (x=0; x<numBlocks; x++) {
      board[x][y] = nil;
      int theNumber = x + 1 + (y * numBlocks);

      CGPoint origin = [self spotForX:x y:y];

      if (theNumber == numBlocks * numBlocks) { 
        board[x][y] = [[NumberView alloc] initWithFrame: CGRectMake(-100, -100, blockSize, blockSize) andNumber: -1];
        continue;
      }
      NumberView *tv = [[NumberView alloc] initWithFrame: CGRectMake(origin.x, origin.y, blockSize, blockSize) andNumber: theNumber];
      [textView addSubview: tv];
      board[x][y] = tv;
    }
  }

  lastHole = [self openSpot];
  
  int c;
  for (c=0; c<50; c++) {
    [NSTimer scheduledTimerWithTimeInterval:.2 * c target:self selector:@selector(moveRandomBlockToOpen) userInfo:nil repeats:NO];
  }

  [mainView addSubview: textView];
  [window setContentView:mainView];
  [window setNeedsDisplay];  
}

- (CGPoint) openSpot
{
  int x,y;
  for (y=0; y<numBlocks; y++) {
    for (x=0; x<numBlocks; x++) {
      if ([board[x][y] number] == -1) {
        return CGPointMake(x,y);
      }
    }
  }
}
@end
