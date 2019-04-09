# ToolbarSample: Using NSToolbar to construct a window toolbar

## Description

This sample shows how to use the AppKit's NSToolbar and NSToolbarItem classes. These are used to add customizable toolbars to windows.
This sample also includes more advanced use of custom views in NSToolbarItems, where you can put a variety of controls, given a little more coding.

This sample implements the NSTouchBar API to work in conjunction with the toolbar.
As a result, what you see in the window's toolbar is what you see in the NSTouchBar - meaning you can use the touch bar to set the font style and size.

To use the touch bar in the simulator, in Xcode select menu: Window -> Show Touch Bar.

## Requirements

### Build

macOS 13 SDK or later

### Runtime

Mac OS X 10.11 or later

NSTouchBar Support:
MacBook Pro computers with the Touch Bar running 10.12.1 and later will be compatible.
You may use Xcode's Touch Bar simulator, but testing on a MacBook Pro with an actual Touch Bar is highly recommended.

Copyright (C) 2001-2018 Apple Inc. All rights reserved.
