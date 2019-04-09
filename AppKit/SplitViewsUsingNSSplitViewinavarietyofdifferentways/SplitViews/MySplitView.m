/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
  See LICENSE.txt for this sample’s licensing information
  
  Abstract:
  Cust NSSplitView for drawing a custom divider. 
 */

#import "MySplitView.h"

@interface MySplitView ()

@property (strong) NSImage *image;

@end

#pragma mark -

@implementation MySplitView

// -------------------------------------------------------------------------------
//	awakeFromNib
// -------------------------------------------------------------------------------
- (void)awakeFromNib
{
	_image = [NSImage imageNamed:@"HorizDividerHandle"];
}

// -------------------------------------------------------------------------------
//	dividerThickness
// -------------------------------------------------------------------------------
- (CGFloat)dividerThickness
{
	return 30.0;
}

// -------------------------------------------------------------------------------
//	drawDividerInRect:Rect
// -------------------------------------------------------------------------------
- (void)drawDividerInRect:(NSRect)rect
{
	NSRect targetRect = NSMakeRect(0, 0, rect.size.width, rect.size.height);
	targetRect.origin.y -= (rect.size.height - self.image.size.height) / 2;
	targetRect.origin.x -= (rect.size.width - self.image.size.width) / 2;

	[self lockFocus];
	[self.image drawInRect:rect fromRect:targetRect operation:NSCompositeSourceOver fraction:1.0];
	[self unlockFocus];
}

@end