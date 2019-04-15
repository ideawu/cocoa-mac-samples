/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
  See LICENSE.txt for this sample’s licensing information
  
  Abstract:
  The LTMaskLayer is a CALayer that is used by  LTView to draw a single slide in the LTView. It acts as the frame and masking layer for its one child layer that is the image for the slide. 
*/

@import Cocoa;
@import QuartzCore;

@interface LTMaskLayer : CALayer

// The source object who's properties we display.
@property(strong, nonatomic) id source;

// The image to draw.
@property(strong, nonatomic) id photo;

// The sublayer the actually contains the image.
@property(strong, nonatomic, readonly) CALayer* photoLayer;

// The frame and position of the photoLayer in the same coordinate space as this layer's frame. These are just convience methods so we only have to do the conversion in one place.
@property (assign, nonatomic) CGRect photoFrame;
@property (assign, nonatomic) CGPoint photoPosition;

@end
