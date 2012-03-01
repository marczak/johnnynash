//
//  johnnynashView.m
//  johnnynash
//
//  Created by Edward Marczak on 2/9/12.
//  Copyright (c) 2012 Radiotope. All rights reserved.
//

#import "johnnynashView.h"

@implementation johnnynashView

@synthesize runFrequency;

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
    [self setDefaultValues];
    [self loadFromUserDefaults];
    if (debug) {
      NSLog(@"initWithFrame setting runFrquency to %f.", runFrequency);
    }
    [self setAnimationTimeInterval:runFrequency];
    previewShown = NO;
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
  if (debug) {
    NSLog(@"In drawRect");
  }
  int oldLevel;
  CGRect cgrect;

  if ([self isPreview]) {
    // Grab the entire screen if in preview mode
    NSRect myNSScreenSize = [[NSScreen mainScreen] frame];
    NSSize myNSWindowSize = myNSScreenSize.size;
    cgrect.origin.x    = myNSScreenSize.origin.x;
    cgrect.origin.y    = myNSScreenSize.origin.y;
    cgrect.size.width  = myNSWindowSize.width;
    cgrect.size.height = myNSWindowSize.height;
  } else {
    // Grab the rectangle of the screen directly under this window.
    NSSize myNSWindowSize = [[self.window contentView] frame ].size;
    cgrect.origin.x    = [self.window frame].origin.x;
    cgrect.origin.y    = [self.window frame].origin.y;
    cgrect.size.width  = myNSWindowSize.width;
    cgrect.size.height = myNSWindowSize.height;
  }

  if ( ([self isPreview] && !previewShown) || ![self isPreview] ){
    if (![self isPreview]) {
      // save our current level so we can restore it later
      oldLevel = [self.window level];
      [[self window] setLevel:CGWindowLevelForKey(kCGPopUpMenuWindowLevelKey)];
    }

    // Grab a screen shot of the windows below this one
    CGImageRef img = 
    CGWindowListCreateImage (cgrect,
                             kCGWindowListOptionOnScreenBelowWindow,
                             [self.window windowNumber],
                             kCGWindowImageDefault);

    if (![self isPreview]) {
      // put us back above the 'barrier window'.
      [[self window] setLevel:oldLevel];
    }

    // Render the grabbed CGImage into the view.
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];

    CGContextDrawImage(context, rect, img);
    CGImageRelease(img);
    previewShown = YES;
  }
}


- (void)animateOneFrame
{
  if (debug) {
    NSLog(@"In animateOneFrame");
  }
  [self setNeedsDisplay:YES];
  return;
}


#pragma mark - Configuration Methods

- (BOOL)hasConfigureSheet
{
  return YES;
}


- (void)loadConfigurationXib
{
  if (debug) {
    NSLog(@"In loadConfigurationXib");
  }
	[NSBundle loadNibNamed: @"ConfigureSheet" owner: self];
	
	NSString *vers = [[NSBundle bundleForClass: [self class]] objectForInfoDictionaryKey: @"CFBundleVersion"];
	vers = [NSString stringWithFormat: @"version %@", vers];
	[versionText setStringValue: vers];
	
	NSUserDefaults *def = [ScreenSaverDefaults defaultsForModuleWithName:
                         [[NSBundle bundleForClass:[self class]] bundleIdentifier]];
	NSUserDefaultsController *controller = [[NSUserDefaultsController alloc] initWithDefaults:def initialValues:nil];
	[configController setContent: controller];
	[controller release];
}


- (NSWindow*)configureSheet
{
  if(!configureSheet) {
    if (debug) {
      NSLog(@"Loading Xib.");
    }
		[self loadConfigurationXib];
  }
	
	return configureSheet;
  return nil;
}


- (IBAction)configOK:(id)sender
{
  if (debug) {
    NSLog(@"In configOK");
  }
	[(NSUserDefaultsController *)[configController content] save:sender];
	[self loadFromUserDefaults];
	
	[NSApp endSheet:configureSheet];
	
  [self setAnimationTimeInterval:runFrequency];
	[self stopAnimation];
	[self startAnimation];
}


- (void)setDefaultValues
{
	NSUserDefaults *def = [ScreenSaverDefaults defaultsForModuleWithName: [[NSBundle bundleForClass: [self class]] bundleIdentifier]];
	[def registerDefaults:
   [NSDictionary dictionaryWithObjectsAndKeys:
    [NSNumber numberWithInt: 2], @"runFrequency",
    [NSNumber numberWithBool:NO], @"debug",
    nil]];
}


- (void)loadFromUserDefaults
{
	NSUserDefaults *def = [ScreenSaverDefaults defaultsForModuleWithName: [[NSBundle bundleForClass: [self class]] bundleIdentifier]];
	runFrequency = [def floatForKey: @"runFrequency"];
  debug = [def boolForKey: @"debug"];
  
  [self setAnimationTimeInterval:runFrequency];
  if (debug) {
    NSLog(@"Loaded new runFrequency of %f.", runFrequency);
  }
}

@end
