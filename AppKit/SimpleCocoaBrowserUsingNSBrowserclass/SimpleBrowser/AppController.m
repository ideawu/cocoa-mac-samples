/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Application Controller object, and the NSBrowser delegate. An instance of this object is in the MainMenu.xib.
 */

#import "AppController.h"
#import "FileSystemNode.h"

@interface AppController ()

// please note bug #24527817
// NSBrowser column titles draw sporadic when navigating back with left arrow key (10.11)
//
@property (weak) IBOutlet NSBrowser *browser;
@property (strong) FileSystemNode *rootNode;

@end


#pragma mark -

@implementation AppController

#pragma mark - NSBrowserDelegate

// This method is optional, but makes the code much easier to understand
//
- (id)rootItemForBrowser:(NSBrowser *)browser {

    if (self.rootNode == nil) {
        _rootNode = [[FileSystemNode alloc] initWithURL:[NSURL fileURLWithPath:NSOpenStepRootDirectory()]];
    }
    return self.rootNode;
}

- (NSInteger)browser:(NSBrowser *)browser numberOfChildrenOfItem:(id)item {
    FileSystemNode *node = (FileSystemNode *)item;
    return node.children.count;
}

- (id)browser:(NSBrowser *)browser child:(NSInteger)index ofItem:(id)item {
    FileSystemNode *node = (FileSystemNode *)item;
    return [node.children objectAtIndex:index];
}

- (BOOL)browser:(NSBrowser *)browser isLeafItem:(id)item {
    FileSystemNode *node = (FileSystemNode *)item;
    return !node.isDirectory || node.isPackage; // take into account packaged apps and documents
}

- (id)browser:(NSBrowser *)browser objectValueForItem:(id)item {
    FileSystemNode *node = (FileSystemNode *)item;
    return node.displayName;
}

@end
