/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
  See LICENSE.txt for this sample’s licensing information
  
  Abstract:
  The Drag Tracker tracks the changes of the mouse during a primary button drag. Tracking starts when the left mouse button is held down and the movement of the cursor exceeds a threshold value. Tracking ends when the mouse button is released. The owning view must route mouseDown:, mouseDragged: and mouseUp: responder messages to this tracker. 
*/

#import "InputTracker.h"

@interface DragTracker : InputTracker {
@private
    BOOL _trackingDrag;
    NSPoint _initialPoint;
    NSPoint _currentPoint;
    
    CGFloat _threshold;
    NSUInteger _modifiers;
    
    SEL _beginTrackingAction;
    SEL _updateTrackingAction;
    SEL _endTrackingAction;
    
    id _userInfo;
}

// The cursor location in the view's coordinate space where the mouse down occured.
@property(readonly, nonatomic) NSPoint initialPoint;

// The difference between the initial cursor location and the current cursor location. This value is in the view's coordinate space.
@property(readonly, nonatomic) NSPoint delta;

// The modifier flags of the last event processed by the tracker. The returned value outside of the begin and end tracking actions are undefined.
@property(readonly, nonatomic) NSUInteger modifiers;

// The number of points the cursor must move (in any direction) before tracking begins.
@property CGFloat threshold;

// The following three properties hold the tracking callbacks on the view. Each method should have one paramenter (DragTracker *) and a void return.
@property SEL beginTrackingAction;
@property SEL updateTrackingAction;
@property SEL endTrackingAction;

// Storage for your custom object to help with tracking. For example, a pointer to the object being modified may be set as the userInfo when the beginTrackingAction method is called. 
@property(strong, nonatomic) id userInfo;
@end
