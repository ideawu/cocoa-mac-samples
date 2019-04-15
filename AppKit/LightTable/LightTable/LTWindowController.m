/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 This is the window controller for our document window. It enables the menu item to toggle the tools view.
 */

#import "LTWindowController.h"
#import "LTViewController.h"

@implementation LTWindowController

#pragma mark Window cascading
- (void)windowDidLoad {
    [super windowDidLoad];
    self.shouldCascadeWindows = YES;
}

#pragma mark NSMenuValidation
- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    
    LTViewController *ltViewController = (LTViewController *)self.contentViewController;
    
    if (menuItem.action == @selector(toggleToolsViewShown:)) {
        if (ltViewController.isToolsViewShowing) {
            menuItem.state = NSOnState;
        } else {
            menuItem.state = NSOffState;
        }
    }
    
    return YES;
}


#pragma mark API

// Tell the view controller to toggle the tools view.
- (IBAction)toggleToolsViewShown:(id)sender {
    LTViewController *ltViewController = (LTViewController *)self.contentViewController;
    [ltViewController toggleToolsView];
}


@end
