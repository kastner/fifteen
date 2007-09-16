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

- (BOOL)respondsToSelector:(SEL)selector {
  NSLog(@"respondsToSelector: %s", selector);
  return [super respondsToSelector:selector];
}

- (void)acceleratedInX:(float)xx Y:(float)yy Z:(float)zz
{
   angle = atan2(yy, xx);
   angle *= 180.0/3.14159;
}

- (void) dropBlockInDirection:(float) toAngle
{
  // [textView setText:@"dropping"];
  
  int threshold = 9;
  int x,y = 0;
  
  if (toAngle <= (0 + threshold) && toAngle > (0 - threshold)) {
    x = 1;
    y = 0;
    // [textView setText:@"0"];
  }
  
  if (toAngle <= (-90 + threshold) && toAngle > (-90 - threshold)) {
    x = 0;
    y = -1;
    // [textView setText:@"-90"];
  }
  
  if ((toAngle <= (180 + threshold) && toAngle > (180 - threshold)) || (toAngle <= (-180 + threshold) && toAngle > (-180 - threshold))) {
    x = -1;
    y = 0;
    // [textView setText:@"180"];
  }
  
  if (toAngle <= (90 + threshold) && toAngle > (90 - threshold)) {
    x = 0;
    y = 1;
    // [textView setText:@"90"];
  }
  
  CGPoint open = [self openSpot];
  int oX = (int)open.x;
  int oY = (int)open.y;
  
  int checkX = x + oX;
  int checkY = y + oY;
  
  if (checkX < numBlocks && checkY < numBlocks && checkX >= 0 && checkY >= 0) {
    if ([board[checkX][checkY] number] != -1) {
      moves++;
      [self moveBlockToOpen: CGPointMake(checkX, checkY)];
    }
  }
  
}
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
  textView = [[UITextView alloc] initWithFrame: rect];
  [textView setEditable:NO];
  
  [textView setDelegate: self];
  
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
      [tv setDelegate: self];
      [textView addSubview: tv];
      board[x][y] = tv;
    }
  }

  lastHole = [self openSpot];
  
  isMixing = YES;
  [textView setText: @"Mixing..."];
  
  int mixes = 40;
  int c;
  for (c=0; c<mixes; c++) {
    [NSTimer scheduledTimerWithTimeInterval:.2 * c target:self selector:@selector(moveRandomBlockToOpen) userInfo:nil repeats:NO];
  }
  
  [NSTimer scheduledTimerWithTimeInterval:.2 * (mixes+1) target:self selector:@selector(doneMixing) userInfo:nil repeats:NO];

  [mainView addSubview: textView];
  [window setContentView:mainView];
  [window setNeedsDisplay];  
}

- (void) doneMixing
{
  isMixing = NO;
  moves = 0;
  [textView setText: @"Done Mixing... rotate to play"];
  timer = [NSTimer scheduledTimerWithTimeInterval:.8 target:self selector:@selector(checkPieces) userInfo:nil repeats:YES];
}

- (void) checkPieces
{
  [textView setText: @""];
  // NSString *xstring = [NSString stringWithFormat:@"checking... angle:%f", angle];
  // [textView setText:xstring];
  [self dropBlockInDirection: angle];
  
  // check for win condition.
  if ([self checkForWin]) {
    [textView setText: @"YOU WON!!!"];
    [timer invalidate];

    NSArray *buttons = [NSArray arrayWithObjects:@"OK", nil];
    UIAlertSheet *alertSheet = [[UIAlertSheet alloc] initWithTitle:@"You Won!" buttons:buttons defaultButtonIndex:1 delegate:self context:self];
    NSString *winString = [NSString stringWithFormat:@"You have won some amount of time..\nYou made %i moves", moves];
    [alertSheet setBodyText:winString];
    [alertSheet popupAlertAnimated:YES];
  }
}

- (void)alertSheet:(UIAlertSheet *)sheet buttonClicked:(int)button 
{
	[sheet dismiss];
	// should restart here
}

- (BOOL) checkForWin
{
  int last = 0;
  int x,y;
  for (y=0; y<numBlocks; y++) {
    for (x=0; x<numBlocks; x++) {
      NSString *str = [NSString stringWithFormat:@"num: %i, last: %i", [board[x][y] number], last];
      NSLog(str);
      if ([board[x][y] number] != ++last) {
        return NO;
      }
      if (last == 15) { break; }
    }
  }
  
  return YES;
  
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
