/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
  See LICENSE.txt for this sample’s licensing information
  
  Abstract:
  Input Trackers are a technique to factor the various input tracking needs of a view without using tracking loops or complicated internal variables. A view creates an array of all the trackers it needs and routes all of the appropriate NSResponderMethods to the Input Tracker array. The tracker will then call back the view with the methods set supplied by the view when something interesting happens. For some trackers, this may be as simple as click or double click. For other trackers this may be a set of begin/update/end methods. Typically, in the begin callback implementation, the view will disable all of its trackers except for the one that issued the callback. Then, upon the end callback, the view will enable all of its trackers again. This way, other input will be ignored until this tracker has completed. 
*/

@import Cocoa;


@interface InputTracker : NSResponder {
@private
    NSView *__weak _view;
    BOOL _enabled;
}

// The owning view of the input tracker. This is the object that any callbacks are sent to.
@property(weak) NSView *view;

// Is this tracker currently monitoring the events and sending out callbacks. If a tracker's enabled state changes to NO, it will automatically cancel any tracking that it is currently performing.
@property BOOL isEnabled;

// Stop any tracking the tracker may be performing and reset itself.
- (void)cancelTracking;
@end
