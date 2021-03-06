# SplitViews

## Description

"SplitViews" is a Cocoa sample application that demonstrates how to use the NSSplitView class.  An NSSplitView object stacks several subviews within one view so that the user can change their relative sizes.

This sample shows how to use the following, (refer to the "Splits" menu for access to all the different kinds of split views) -

1) Horizontal and vertical split views

2) Collapsible split views - users can drag a split view divider in one direction enough to collapse a split view area down to zero size, then able to expand it again.  This is done by using NSSplitViewDelegate:

	- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview;

If a subview is collapsible, the NSSplitView will collapse it when the user has dragged the divider more than halfway between the position that would make the subview its minimum size and the position that would make it zero size. The subview will become uncollapsed if the user drags the divider back past that point.

In this example, it also uses "constrainMinCoordinate" and "constrainMaxCoordinate" delegate methods to constrain the split view sizes to an arbitrary vertical value.

3) Custom dividers - Split views allow for custom dividers allowing you to alter it's size and appearance.  You can do this by subclassing NSSplitView and overriding:

	- (void)drawDividerInRect:(NSRect)rect;

4) Textured-Style split views - After applying "Textured" style to your window, split views can adopt the texture-style appearance along with its window.

5) Real-World Example - In addition this sample shows a real-world example of using split views in a way to easily organize your window's content.  In this case, this sample mimics a mail style organizer window.

All split view sizes in this sample are persistent across application launches.
This is done by entering a string value for each split view from either Interface Builder, or programmatically through:

    - (void)setAutosaveName:(NSString *)autosaveName;


### Creating Split Views in Xcode

For example to add two NSTextViews to your window, with one above the second one:

1) Open a nib file containing the user interface you want to apply that split view.
2) Create and align two NSTextViews, one stacked on top of the other.
3) Select both NSTextViews.
4) Select menu Editor -> Embed In -> Split View
As a result both NSTextViews will be encased inside one NSSplitView.

To undo that action, select menu Editor -> Unembed.


## Build Requirements

OS X 10.11 SDK or later


## Runtime Requirements

OS X 10.7 or later


Copyright (C) 2011-2015 Apple Inc. All rights reserved.