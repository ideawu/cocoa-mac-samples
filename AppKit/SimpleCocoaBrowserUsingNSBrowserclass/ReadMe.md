# SimpleCocoaBrowser

## Description

SimpleCocoaBrowser is a very simple example of how to create a basic NSBrowser delegate implementation. See the ComplexBrowser example for a more interesting example, and to see the use of a custom cell.  As a delegate it utilizes NSBrowser’s "item-based" API.

AppController.h/.m

The AppController class lives in the MainMenu.xib. It is set as the delegate for the main NSApplication instance, and the delegate for the NSBrowser. It also has a single outlet set to the browser.

FileSystemNode.h/.m

This class is a simple wrapper around the file system. Its main purpose is to cache the children for a given NSURL. We do this in order to get a consistent children count. 


## Requirements

### Build

Xcode 7.1, OS X 10.10 SDK or later

### Runtime

OS X 10.10 or later

Copyright (C) 2009-2016 Apple Inc. All rights reserved.