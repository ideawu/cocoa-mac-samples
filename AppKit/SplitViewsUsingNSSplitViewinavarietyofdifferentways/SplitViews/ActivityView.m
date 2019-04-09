/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
  See LICENSE.txt for this sample’s licensing information
  
  Abstract:
  Custom NSView subclass representing the mail activitiy view. 
 */

#import "ActivityView.h"

@implementation ActivityView

// -------------------------------------------------------------------------------
//	drawRect:rect
// -------------------------------------------------------------------------------
- (void)drawRect:(NSRect)rect
{
	[[NSColor gridColor] set];
	NSRectFill(rect);
}

@end
