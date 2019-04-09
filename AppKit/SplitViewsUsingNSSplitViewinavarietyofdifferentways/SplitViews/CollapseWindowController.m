/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
  See LICENSE.txt for this sample’s licensing information
  
  Abstract:
  The NSWindowController subclass managing the collapsible split views. 
 */

#import "CollapseWindowController.h"

#define kMinContrainValue 100.0f


@implementation CollapseWindowController

#pragma mark - NSSplitViewDelegate methods

// -------------------------------------------------------------------------------
//	canCollapseSubview:
//
//	This delegate allows the collapsing of the first and last subview.
// -------------------------------------------------------------------------------
- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview
{
    BOOL canCollapseSubview = NO;
	
    NSArray *splitViewSubviews = splitView.subviews;
    NSUInteger splitViewSubviewCount = splitViewSubviews.count;
    if (subview == splitViewSubviews[0] || subview == splitViewSubviews[(splitViewSubviewCount - 1)])
	{
		canCollapseSubview = YES;
    }
	return canCollapseSubview;
}

// -------------------------------------------------------------------------------
//	shouldCollapseSubview:subView:dividerIndex
//
//	This delegate allows the collapsing of the first and last subview.
// -------------------------------------------------------------------------------
- (BOOL)splitView:(NSSplitView *)splitView shouldCollapseSubview:(NSView *)subview forDoubleClickOnDividerAtIndex:(NSInteger)dividerIndex
{
    // yes, if you can collapse you should collapse it
    return YES;
}

// -------------------------------------------------------------------------------
//	constrainMinCoordinate:proposedCoordinate:index
// -------------------------------------------------------------------------------
- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedCoordinate ofSubviewAt:(NSInteger)index
{
    CGFloat constrainedCoordinate = proposedCoordinate;
    if (index == 0)
    {
		constrainedCoordinate = proposedCoordinate + kMinContrainValue;
    }
    return constrainedCoordinate;
}

// -------------------------------------------------------------------------------
//	constrainMaxCoordinate:proposedCoordinate:proposedCoordinate:index
// -------------------------------------------------------------------------------
- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedCoordinate ofSubviewAt:(NSInteger)index
{
    CGFloat constrainedCoordinate = proposedCoordinate;
    if (index == (splitView.subviews.count - 2))
	{
		constrainedCoordinate = proposedCoordinate - kMinContrainValue;
    }
	
    return constrainedCoordinate;	
}

@end
