/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The Click Tracker informs the view of single and double clicks. A single click is defined as a mouse down with a clickCount less than or equal to 1. A double click is a mouse up with a clickCount equal to 2. Tip: A view can easily change its behavior in response to a click by changing the action property. The owning view must route mouseDown: and mouseUp: responder messages to this tracker.
 */

#import "ClickTracker.h"


@implementation ClickTracker
@synthesize action = _action;
@synthesize doubleAction = _doubleAction;
@synthesize location = _location;
@synthesize modifiers = _modifiers;

- (void)mouseDown:(NSEvent *)event {
    self.location = event.locationInWindow; // [self.view convertPoint:event.locationInWindow fromView:nil]; // [self.view convertPointFromBase:[event locationInWindow]];
    if (event.clickCount <= 1) {
        self.modifiers = event.modifierFlags;
        if (self.isEnabled && self.action) {
            [NSApp sendAction:self.action to:self.view from:self];
        }
    }
}

- (void)mouseUp:(NSEvent *)event {
    if (event.clickCount == 2) {
        self.modifiers = event.modifierFlags;
        if(self.isEnabled && self.doubleAction) {
            [NSApp sendAction:self.doubleAction to:self.view from:self];
        }
    }
}
@end
