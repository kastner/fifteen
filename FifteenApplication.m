#import "BefuddlerApplication.h"

@implementation FifteenApplication

- (void) loadImageBox
{
  ib = [[ImageBox alloc] initWithFrame: CGRectMake(0.0f, 43.0f, _rect.size.width, 480.0f)];
  [ib setDelegate: self];
  
  // [ib addImage: [[UIImage alloc] initWithContentsOfFile:filePath] withPath: fullFilePath];
}

- (void) applicationDidFinishLaunching: (id) unused
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  
  window = [[UIWindow alloc] initWithContentRect: [UIHardware fullScreenApplicationContentRect]];
  
  _rect = [UIHardware fullScreenApplicationContentRect];
  _rect.origin.x = _rect.origin.y = 0.0f;
  
  mainView = [[UIView alloc] initWithFrame: _rect];  

  // window options
  [window setContentView: bigTransView];
  [window orderFront: self];
  [window makeKey: self];
  [window _setHidden: NO];

  [pool release];
}

- (void) dealloc
{
  [ib release];
  
  [mainView release];
  [window release];
  [super dealloc];
}

@end