//
//  johnnynashView.h
//  johnnynash
//
//  Created by Edward Marczak on 2/22/12.
//  Copyright (c) 2012 Radiotope. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>

@interface johnnynashView : ScreenSaverView
{
  BOOL previewShown;

  IBOutlet NSWindow *configureSheet;
  IBOutlet NSObjectController *configController;
  IBOutlet NSTextField *versionText;
  IBOutlet NSSlider *runFrequencySlider;
  IBOutlet NSTextField *runFrequncyLabel;
  
  float runFrequency;
  BOOL debug;
}

- (void)loadConfigurationXib;
- (IBAction)configOK: (id)sender;
- (void)loadFromUserDefaults;
- (void)setDefaultValues;

@property (readwrite, assign) float runFrequency;

@end