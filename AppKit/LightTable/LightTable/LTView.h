/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
  See LICENSE.txt for this sample’s licensing information
  
  Abstract:
  This custom view uses CALayers to arange and draw slides. Drag and Drop images onto this view to add them as slides. Double-click a slide to edit the masking of the image to the slide. This view tracks both mouse and touch events to modify the slide. Using two fingers on the trackpad will adjust the position and size of the slide under the cursor. 
*/

@import Cocoa;

@class LTMaskLayer;

@interface LTView : NSView <CALayerDelegate> {

}

//@property (nonatomic, weak) NSArrayController *theNewObjectCreator;
@property (weak) IBOutlet NSArrayController *theNewObjectCreator;

@property (strong, nonatomic) NSIndexSet *selectionIndexes;
@end

#pragma mark Data Binding Properties
// The following are the properties that bound slide objects must have.

// @"slides" The content for an LTView is an array of slides.
extern NSString *kLTViewSlides;

// @"selectionIndexes" The indexes of th selected slides
extern NSString *kLTViewSelectionIndexes;

// @"frame" The frame (NSRect) of the slide
extern NSString *kLTViewSlidePropertyFrame;

//@"photoFrame" The frame (NSRect) of the image inside the slide.
extern NSString *kLTViewSlidePropertyPhotoFrame;

//@"photo" The slide image data (NSData).
extern NSString *kLTViewSlidePropertyPhoto;

//@"cornerRadius" The radius (float) of the slide corners
extern NSString *kLTViewSlidePropertyCornerRadius;

//@"frameThickness" The width (float) of the frame.
extern NSString *kLTViewSlidePropertyFrameThickness;
