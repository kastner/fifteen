#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIView-Internal.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UITextView.h>
#include <math.h>
#import "NumberView.h"

@interface FifteenApplication : UIApplication {
  float blockSize;
  int numBlocks;
  NumberView *board[4][4];
  CGPoint lastHole;
}

- (CGPoint) spotForX:(int) x y:(int) y;
- (CGPoint) openSpot;

@end