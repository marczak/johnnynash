//
//  johnnynashView.m
//  johnnynash
//
//  Created by Edward Marczak on 2/9/12.
//  Copyright (c) 2012 Radiotope. All rights reserved.
//

#import "johnnynashView.h"

@implementation johnnynashView

#pragma mark - Class Overrides

+ (BOOL)performGammaFade {
  return NO;
}

- (BOOL)isOpaque {
  return YES;
}


#pragma mark - Standard Class Methods

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
  self = [super initWithFrame:frame isPreview:isPreview];
  if (self) {
    [self setAnimationTimeInterval:1.0f];
  }
  return self;
}


- (void)startAnimation
{
  [super startAnimation];
}


- (void)stopAnimation
{
  [super stopAnimation];
}


#pragma mark - Animation Methods
- (void)drawRect:(NSRect)rect
{  
  // Grab the rectangle of the screen directly under this window.
  NSSize myNSWindowSize = [[self.window contentView] frame ].size;
  CGRect cgrect;
  cgrect.origin.x    = [self.window frame].origin.x;
  cgrect.origin.y    = [self.window frame].origin.y;
  cgrect.size.width  = myNSWindowSize.width;
  cgrect.size.height = myNSWindowSize.height;

  // save our current level so we can restore it later
  int oldLevel = [self.window level];
  [[self window] setLevel:CGWindowLevelForKey(kCGPopUpMenuWindowLevelKey)];

  // Grab a screen shot of the windows below this one
  CGImageRef img = 
  CGWindowListCreateImage (cgrect,
                           kCGWindowListOptionOnScreenBelowWindow,
                           [self.window windowNumber],
                           kCGWindowImageDefault);
  
  // put us back above the 'barrier window'.
  [[self window] setLevel:oldLevel];
  
  // Render the grabbed CGImage into the view.
  CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
  
  CGContextDrawImage(context, rect, img);
  CGImageRelease(img);
}


- (void)animateOneFrame
{
  [self setNeedsDisplay:YES];
  return;
}


#pragma mark - Configuration Methods

- (BOOL)hasConfigureSheet
{
  return NO;
}


- (NSWindow*)configureSheet
{
  return nil;
}

@end
