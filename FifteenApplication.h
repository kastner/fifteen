#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIView-Internal.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UITextView.h>
#import <UIKit/UITextLabel.h>
#import <UIKit/UIAlertSheet.h>
#import <UIKit/UINavigationBar.h>
#import <UIKit/UINavigationBarBackground.h>
#import <UIKit/UINavigationItem.h>
#import <UIKit/UISwitchControl.h>

#import <UIKit/UIPreferencesTable.h>
#import <UIKit/UIPreferencesTextTableCell.h>

#include <math.h>
#import "NumberView.h"

#define MIXES 40
#define THRESHOLD 40

@interface FifteenApplication : UIApplication {
  float blockSize;
  int numBlocks;
  NumberView *board[4][4];
  CGPoint lastHole;
  UITextView *textView;
  NSTimer *timer;
  float angle;
  int moves;
  UINavigationBar *navBar;
  UINavigationItem *navBarTitle;
  UIPreferencesTable *_pref;
  UISwitchControl *touchSwitch;
  BOOL isMoving;
  BOOL isMixing;
  BOOL isPlaying;
  time_t startTime;
  
  UITextLabel *status;
}

- (CGPoint) spotForX:(int) x y:(int) y;
- (CGPoint) openSpot;
- (void) moveBlockToOpen:(CGPoint) block;
- (BOOL) checkForWin;
- (void) checkPieces;
- (void) mixTiles;
- (void) showStatus;

@end