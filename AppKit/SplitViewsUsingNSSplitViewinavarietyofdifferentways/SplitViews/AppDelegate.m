/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
  See LICENSE.txt for this sample’s licensing information
  
  Abstract:
  The application's delegate for managing its windows. 
 */

#import "AppDelegate.h"
#import "MailWindowController.h"
#import "CollapseWindowController.h"

@interface AppDelegate ()

@property (strong) NSWindowController *horizontalSplitWindController;
@property (strong) NSWindowController *verticalSplitWindController;
@property (strong) CollapseWindowController *collapseWindowController;
@property (strong) NSWindowController *customSplitWindController;
@property (strong) NSWindowController *texturedMiniSplitWindController;
@property (strong) MailWindowController *mailStyleSplitController;

@end


#pragma mark -

@implementation AppDelegate

// -------------------------------------------------------------------------------
//	applicationDidFinishLaunching:notification
// -------------------------------------------------------------------------------
- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [self doHorizontalSplit:self];  // at launch, start off with the horizontal split example
}

// -------------------------------------------------------------------------------
//	doHorizontalSplit:sender
// -------------------------------------------------------------------------------
- (IBAction)doHorizontalSplit:(id)sender
{
    if (self.horizontalSplitWindController == nil)
        _horizontalSplitWindController = [[NSWindowController alloc] initWithWindowNibName:@"HorizontalSplit"];
    [self.horizontalSplitWindController showWindow:self];
}

// -------------------------------------------------------------------------------
//	doVerticalSplit:sender
// -------------------------------------------------------------------------------
- (IBAction)doVerticalSplit:(id)sender
{
    if (self.verticalSplitWindController == nil)
        _verticalSplitWindController = [[NSWindowController alloc] initWithWindowNibName:@"VerticalSplit"];
    [self.verticalSplitWindController showWindow:self];
}

// -------------------------------------------------------------------------------
//	doCollapsibleSplit:sender
// -------------------------------------------------------------------------------
- (IBAction)doCollapseSplit:(id)sender
{
    if (self.collapseWindowController == nil)
        _collapseWindowController = [[CollapseWindowController alloc] initWithWindowNibName:@"CollapseSplit"];
    [self.collapseWindowController showWindow:self];
}

// -------------------------------------------------------------------------------
//	doCustomSplit:sender
// -------------------------------------------------------------------------------
- (IBAction)doCustomSplit:(id)sender
{
	if (self.customSplitWindController == nil)
        _customSplitWindController = [[NSWindowController alloc] initWithWindowNibName:@"CustomSplit"];
    [self.customSplitWindController showWindow:self];
}

// -------------------------------------------------------------------------------
//	doTexturedSplit:sender
// -------------------------------------------------------------------------------
- (IBAction)doTexturedSplit:(id)sender
{
    if (self.texturedMiniSplitWindController == nil)
        _texturedMiniSplitWindController = [[NSWindowController alloc] initWithWindowNibName:@"TexturedSplit"];
    [self.texturedMiniSplitWindController showWindow:self];
}

// -------------------------------------------------------------------------------
//	doMailStyleSplit:sender
// -------------------------------------------------------------------------------
- (IBAction)doMailStyleSplit:(id)sender
{
    if (self.mailStyleSplitController == nil)
        _mailStyleSplitController = [[MailWindowController alloc] initWithWindowNibName:@"MailSplit"];
    [self.mailStyleSplitController showWindow:self];
}

@end
