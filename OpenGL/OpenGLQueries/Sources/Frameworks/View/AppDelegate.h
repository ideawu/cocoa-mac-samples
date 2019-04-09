/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 OpenGL Query View application delegate.
 */

#import <Cocoa/Cocoa.h>

#import "OutlineViewController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic,assign) id<NSOutlineViewDelegate>    delegate;
@property (nonatomic,assign) id<NSOutlineViewDataSource>  dataSource;

- (IBAction) print:(id)sender;

@end
