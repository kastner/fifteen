#import "FifteenApplication.h"
#include <time.h>

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
  
  int x,y = 0;
  
  if (toAngle <= (0 + THRESHOLD) && toAngle > (0 - THRESHOLD)) {
    x = 1;
    y = 0;
    // [textView setText:@"0"];
  }
  
  if (toAngle <= (-90 + THRESHOLD) && toAngle > (-90 - THRESHOLD)) {
    x = 0;
    y = -1;
    // [textView setText:@"-90"];
  }
  
  if ((toAngle <= (180 + THRESHOLD) && toAngle > (180 - THRESHOLD)) || (toAngle <= (-180 + THRESHOLD) && toAngle > (-180 - THRESHOLD))) {
    x = -1;
    y = 0;
    // [textView setText:@"180"];
  }
  
  if (toAngle <= (90 + THRESHOLD) && toAngle > (90 - THRESHOLD)) {
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

- (void) doneMoving
{
  NSLog(@"in done moving");
  if (!isMixing) {
    isMoving = NO;
    [self checkPieces];
    // timer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(checkPieces) userInfo:nil repeats:YES];
  }
}

- (void) moveBlockAt:(CGPoint) start to:(CGPoint) end
{
  int startX = (int)start.x;
  int startY = (int)start.y;
  int endX = (int)end.x;
  int endY = (int)end.y;
  
  isMoving = YES;
  // [timer invalidate];
  [NSTimer scheduledTimerWithTimeInterval:MOVESPEED + 0.2 target:self selector:@selector(doneMoving) userInfo:nil repeats:NO];
  
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
  return CGPointMake(x * blockSize + 6.0f, y * blockSize + 25.0f);
}

- (void) applicationDidFinishLaunching: (id) unused
{

  isMoving = NO;
  
  CGRect rect = [UIHardware fullScreenApplicationContentRect];
  rect.origin.x = rect.origin.y = 0;
  NSLog(@"x:%.f y:%.f w:%.f h:%.f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
  UIWindow *window = [[UIWindow alloc] initWithContentRect:rect];
  [window orderFront: self];
  [window makeKey: self];
  [window _setHidden: NO];

  UIView *mainView = [[UIView alloc] initWithFrame: rect];
  
  UIImageView	*background = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, rect.size.width, rect.size.height)];
  
	navBar = [[UINavigationBar alloc] init];
	[navBar setFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 45.0f)];
  [navBar setBarStyle:0];
  [navBar setImage:[UIImage applicationImageNamed:@"bar.png"]];
	
	[navBar setDelegate:self];
	[navBar enableAnimation];
	
	navBarTitle = [[UINavigationItem alloc] init];
	[navBar pushNavigationItem:navBarTitle];
	
  [navBar setDelegate: self];
	
	[mainView addSubview:navBar];
  
  textView = [[UITextView alloc] initWithFrame: CGRectMake(rect.origin.x, 45.0f, rect.size.width, (rect.size.height - 45.0f))];
  [textView setEditable:NO];
  
  // [textView setDelegate: self];
  
  [background setImage:[UIImage applicationImageNamed:@"bg.png"]];	
	[textView addSubview:background];
	[background release];

  // _pref = [[UIPreferencesTable alloc] initWithFrame: CGRectMake(0, 300, rect.size.width, 65)];
  // 
  // [_pref setDataSource: self];
  // [_pref setDelegate: self];
  // // [_pref setBottomBufferHeight: 0];
  // [_pref setCentersContent: YES];
  // 
  // [textView addSubview: _pref];
  //  
  // [_pref reloadData];
	  
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
      // [tv setDelegate: self];
      [textView addSubview: tv];
      board[x][y] = tv;
    }
  }

  lastHole = [self openSpot];
  
  [self mixTiles];
  
  [mainView addSubview: textView];
  [window setContentView:mainView];
  [window setNeedsDisplay];
  
  // status = [[UITextLabel alloc] initWithFrame: CGRectMake(82, 352, 100, 50)];
  // CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  // float backgroundcomponents[4] = {0,0,0,0};  
  // [status setBackgroundColor: CGColorCreate(colorSpace, backgroundcomponents)];
  // 
  // [textView addSubview: status];
  
  // [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(showStatus) userInfo:nil repeats:YES];
}

- (void) showStatus
{
  // NSString *text;
  // if (isMoving) {
  //   text = @"Moving...";
  // }
  // else {
  //   text = @"Not moving";
  // }
  // [status setText:text];
}

- (void) mixTiles
{
  isMixing = YES;
  
  int c;
  for (c=0; c<MIXES; c++) {
    [NSTimer scheduledTimerWithTimeInterval:.2 * c target:self selector:@selector(moveRandomBlockToOpen) userInfo:nil repeats:NO];
  }
  
  [NSTimer scheduledTimerWithTimeInterval:.2 * (MIXES+1) target:self selector:@selector(doneMixing) userInfo:nil repeats:NO];
}

- (int)preferencesTable:(UIPreferencesTable *)aTable numberOfRowsInGroup:(int)group
{
  return 1;
}

- (int)numberOfGroupsInPreferencesTable:(UIPreferencesTable *)aTable {
  NSLog(@"number of groups");
  return 1;
}

- (UIPreferencesTableCell *)preferencesTable:(UIPreferencesTable *)aTable cellForRow:(int)row inGroup:(int)group
{
  UIPreferencesTableCell *cell;
  
  if (row > 0) {
    cell = [[UIPreferencesTextTableCell alloc] init];
    [cell setTitle:@"Gravity"];
  }
  else {
    cell = [[UIPreferencesTableCell alloc] init];
    touchSwitch = [[UISwitchControl alloc] initWithFrame: CGRectMake(100, 355, 120, 40)];
    // [touchSwitch setLeftSwitchTitle:@"Gravity"];
    // [touchSwitch setRightSwitchTitle:@"Touch"];
    [touchSwitch createSliderKnobView];
    [touchSwitch setAlternateColors: YES];
    [cell addSubview: touchSwitch];
  }
  
  return cell;
}

- (float)preferencesTable:(UIPreferencesTable *)aTable heightForRow:(int)row inGroup:(int)group withProposedHeight:(float)proposed 
{
  return 55;
}

- (void) gameWon
{
  isPlaying = NO;
  
  if ([timer isValid]) {
    [timer invalidate];
  }
  // [timer release];
  
  time_t timeNow = time(NULL);
  time_t gameTime = timeNow - startTime;

  NSArray *buttons = [NSArray arrayWithObjects:@"OK", nil];
  UIAlertSheet *alertSheet = [[UIAlertSheet alloc] initWithTitle:@"You Won!" buttons:buttons defaultButtonIndex:1 delegate:self context:self];
  NSString *winString = [NSString stringWithFormat:@"You won in %i seconds\nYou made %i moves", gameTime, moves];
  [alertSheet setBodyText:winString];
  [alertSheet popupAlertAnimated:YES];
  
  [navBar showButtonsWithLeftTitle: nil rightTitle: @"Scramble" leftBack: NO];
}

- (void)navigationBar:(UINavigationBar*)bar buttonClicked:(int)button
{
  [self mixTiles];
  [navBar showButtonsWithLeftTitle: nil rightTitle: nil leftBack: NO];
}

- (void) doneMixing
{
  isPlaying = YES;
  startTime = time(NULL);
  NSLog(@"Game start time %i", startTime);
  isMixing = NO;
  moves = 0;
  // [textView setText: @"Done Mixing... rotate to play"];
  timer = [NSTimer scheduledTimerWithTimeInterval:.4 target:self selector:@selector(checkPieces) userInfo:nil repeats:YES];
}

- (void) checkPieces
{
  if (isPlaying) {
    if (moves < 4) {
      [textView setText: @"Tilt your phone."];
    }
    else {
      [textView setText: @""];
    }

    // NSString *xstring = [NSString stringWithFormat:@"checking... angle:%f", angle];
    // [textView setText:xstring];
    if (!isMoving) {
      [self dropBlockInDirection: angle];
    }

    // check for win condition.
    if ([self checkForWin]) {
      [self gameWon];
    }    
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
