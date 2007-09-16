#import "FifteenApplication.h"

@interface NumberTile : UITile
{
  int number;
}
@end

@implementation NumberTile

- (id)initWithFrame:(struct CGRect)frame andNumber:(int) theNumber
{
  self = [super initWithFrame:frame];
  number = theNumber;
  return self;
}

- (void)drawRect:(struct CGRect)rect
{
  CGContextRef context = UICurrentContext();
  float r = (float)(rand() % 100) / 100.0;
  float g = (float)(rand() % 100) / 100.0;
  float b = (float)(rand() % 100) / 100.0;
  CGContextSetRGBFillColor(context, r, g, b, 1.0);
  CGContextFillRect(context, rect);
}

@end

@interface SomeTiledView : UITiledView
{
}
@end

@implementation SomeTiledView

- (id)initWithFrame:(struct CGRect)rect
{
  // width and height of each tile
  float w = 30;
  float h = 30; //ceil(rect.size.height / 40);

  self = [super initWithFrame:rect];
  [self setFirstTileSize:CGSizeMake(w, h)];
  [self setOpaque:YES];
  [self setNeedsDisplay];
  [self setNeedsLayout];
// Interesting when not drawing
 // [self setDrawsGrid:YES];
  [self setTileSize:CGSizeMake(w, h)];
  [self setTileDrawingEnabled:YES];
  [self setTilingEnabled:YES];
  return self;
}

- (void)logRect:(struct CGRect)rect;
{
  NSLog(@"(%f,%f) -> (%f,%f)", rect.origin.x, rect.origin.y,
        rect.size.width, rect.size.height);
}

+ (Class)tileClass
{
  return [NumberTile class];
}

@end

@implementation TileView

- (void) applicationDidFinishLaunching: (id) unused
{
  NSLog(@"applicationDidFinishLaunching");

  CGRect rect = [UIHardware fullScreenApplicationContentRect];
  rect.origin.x = rect.origin.y = 0;
  UIWindow *window = [[UIWindow alloc] initWithContentRect:rect];
  [window orderFront: self];
  [window makeKey: self];
  [window _setHidden: NO];

  UIScroller* scroller = [[UIScroller alloc] initWithFrame:rect];

  // Make some scrollz!!!1!!!!!11
  rect.size.height += 200; 

  SomeTiledView* view = [[SomeTiledView alloc] initWithFrame:rect];

  [scroller setContentSize:rect.size];
  [scroller addSubview:view];
  [scroller setAllowsRubberBanding:YES];
  [scroller displayScrollerIndicators];

  [window setContentView:scroller];
  [window setNeedsDisplay];
}

@end
