#import "ImageBox.h"

@implementation ImageBox

- (BOOL)respondsToSelector:(SEL)selector {
  NSLog(@"respondsToSelector: %s", selector);
  return [super respondsToSelector:selector];
}

- (id) initWithFrame: (struct CGRect)frame 
{
  if ((self == [super initWithFrame: frame]) != nil) {
    
  }
  
  images = [[NSMutableArray alloc] init];
  
  _x = _y = 4.0f;
  _width = _height = 75.0f;
  
  _rect = frame;
  
  return self;
}

- (void) addImage: (UIImage *)image withPath: (NSString *)path
{
  [images addObject: image];
  
  ImageButton *btn = [[ImageButton alloc] initWithFrame: CGRectMake(_x, _y, _width, _height) image: image path: path];
  
  if([[self delegate] respondsToSelector:@selector(buttonUp:)]) {
    [btn addTarget:[self delegate] action:@selector(buttonUp:) forEvents:1];
  }
    
  [self addSubview: btn];
  [btn release];

  _x = _x + 79.0f;
  if (_x >= _rect.size.width) {
    _x = 4.0f;
    _y += 79.0f;
  }
  
  if (_y > _rect.size.height) {
    // Resize the view if we need to
    [self setContentSize: CGSizeMake(_rect.size.width, _y)];
  }
  
}

// - (void) setDelegate: (id)new_delegate
// {
//   _delegate = new_delegate;
// }

- (void)dealloc 
{
  [images release];
  [super dealloc];
}
@end