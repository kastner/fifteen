#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIImage.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UIScroller.h>
#import <CoreGraphics/CoreGraphics.h>
#import "ImageButton.h"

@interface ImageBox : UIScroller {
  NSMutableArray *images;
  float _x;
  float _y;
  float _width;
  float _height;
  
  CGRect _rect;
  // id _delegate;
  // SEL mySelector;
}

- (id) initWithFrame: (CGRect)frame;
- (void) addImage: (UIImage *)image withPath: (NSString *)path;

// - (void)setDelegate:(id)new_delegate;

// - (void) drawRect: (CGRect)rect;

@end