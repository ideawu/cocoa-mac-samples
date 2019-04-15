/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The Drag Tracker tracks the changes of the mouse during a primary button drag. Tracking starts when the left mouse button is held down and the movement of the cursor exceeds a threshold value. Tracking ends when the mouse button is released. The owning view must route mouseDown:, mouseDragged: and mouseUp: responder messages to this tracker.
 */

#import "DragTracker.h"


@interface DragTracker()
@property BOOL isTrackingDrag;
@property(readwrite, nonatomic) NSPoint initialPoint;
@property (assign, nonatomic) NSPoint currentPoint;
@property(readwrite, nonatomic) NSUInteger modifiers;
@end


@implementation DragTracker

- (instancetype)init {
    if (self = [super init]) {
        self.threshold = 2.0;
    }
    
    return self;
}


#pragma mark NSResponder

- (void)mouseDown:(NSEvent *)event {
    self.initialPoint = [self.view convertPoint:event.locationInWindow fromView:nil];    // convertPointFromBase:[event locationInWindow]];
    self.currentPoint = self.initialPoint;
}

- (void)mouseDragged:(NSEvent *)event {
    self.modifiers = event.modifierFlags;
    self.currentPoint = [self.view convertPoint:event.locationInWindow fromView:nil]; // [self.view convertPointFromBase:[event locationInWindow]];
    
    if (!self.isEnabled) return;
    
    if (!self.isTrackingDrag) {
        NSPoint delta = self.delta;
        if (fabs(delta.x) > self.threshold || fabs(delta.y) > self.threshold) {
            self.isTrackingDrag = YES;
            if (self.beginTrackingAction) [NSApp sendAction:self.beginTrackingAction to:self.view from:self];
        }
    } else {
        if (self.updateTrackingAction) [NSApp sendAction:self.updateTrackingAction to:self.view from:self];
    }
}

- (void)mouseUp:(NSEvent *)event {
    if (self.isTrackingDrag) {
        self.modifiers = event.modifierFlags;
        if (self.endTrackingAction) [NSApp sendAction:self.endTrackingAction to:self.view from:self];
        self.isTrackingDrag = NO;
    }
}


#pragma mark InputTracker



- (void)cancelTracking {
    if (self.isTrackingDrag) {
        if (self.endTrackingAction) [NSApp sendAction:self.endTrackingAction to:self.view from:self];
        self.isTrackingDrag = NO;
    }
}

#pragma mark API

@synthesize isTrackingDrag = _trackingDrag;
@synthesize initialPoint = _initialPoint;
@synthesize currentPoint = _currentPoint;
@synthesize threshold = _threshold;

@synthesize beginTrackingAction = _beginTrackingAction;
@synthesize updateTrackingAction = _updateTrackingAction;
@synthesize endTrackingAction = _endTrackingAction;

@synthesize modifiers = _modifiers;

@synthesize userInfo = _userInfo;

- (NSPoint)delta;
{
    NSPoint delta;
    delta.x = self.currentPoint.x - self.initialPoint.x;
    delta.y = self.currentPoint.y - self.initialPoint.y;
    return delta;
}

@end

