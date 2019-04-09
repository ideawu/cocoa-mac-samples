/*
 Copyright (C) 2018 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The primary window controller for this sample.
 */

import Cocoa

@available(OSX 10.12.2, *)
fileprivate extension NSTouchBar.CustomizationIdentifier {
    static let touchBar = NSTouchBar.CustomizationIdentifier("com.ToolbarSample.touchBar")
}

@available(OSX 10.12.2, *)
fileprivate extension NSTouchBarItem.Identifier {
    static let popover = NSTouchBarItem.Identifier("com.ToolbarSample.TouchBarItem.popover")
    static let fontStyle = NSTouchBarItem.Identifier("com.ToolbarSample.TouchBarItem.fontStyle")
    static let popoverSlider = NSTouchBarItem.Identifier("com.ToolbarSample.popoverBar.slider")
}

class WindowController: NSWindowController, NSToolbarDelegate {
    let fontSizeToolbarItemID = "FontSize"
    let fontStyleToolbarItemID = "FontStyle"
    let defaultFontSize = 18
    
    @IBOutlet weak var toolbar: NSToolbar!
    
    // Font style toolbar item.
    @IBOutlet var styleSegmentView: NSView!  // The font style changing view (ends up in an NSToolbarItem).

    // Font size toolbar item.
    @IBOutlet var fontSizeView: NSView!    // The font size changing view (ends up in an NSToolbarItem).
    @IBOutlet var fontSizeStepper: NSStepper!
    @IBOutlet var fontSizeField: NSTextField!
    
    @objc var currentFontSize: Int = 0
    
    // MARK: - Window Controller Life Cycle
    
    override func windowDidLoad() {
        super.windowDidLoad()

        currentFontSize = defaultFontSize
        
        // Configure our toolbar (note: this can also be done in Interface Builder).
        
        /*  If you pass NO here, you turn off the customization palette. The palette is normally handled
            automatically for you by NSWindow's -runToolbarCustomizationPalette: function; you'll notice
            that the "Customize Toolbar" menu item is hooked up to that method in Interface Builder.
		*/
        toolbar.allowsUserCustomization = true
        
        /*  Tell the toolbar that it should save any configuration changes to user defaults, i.e. mode
            changes, or reordering will persist. Specifically they will be written in the app domain using
            the toolbar identifier as the key.
        */
        toolbar.autosavesConfiguration = true
        
        // Tell the toolbar to show icons only by default.
        toolbar.displayMode = .iconOnly
        
        // Initialize our font size control here to 18-point font, and set our view controller's NSTextView to that size.
        fontSizeStepper.integerValue = Int(defaultFontSize)
        fontSizeField.stringValue = String(defaultFontSize)
        let font = NSFont(name: "Helvetica", size: CGFloat(defaultFontSize))
        contentTextView().font = font
        
        if #available(OSX 10.12.2, *) {
			if let fontSizeTouchBarItem = touchBar!.item(forIdentifier: .popover) as? NSPopoverTouchBarItem {
				let sliderTouchBar = fontSizeTouchBarItem.popoverTouchBar
				if let sliderTouchBarItem = sliderTouchBar.item(forIdentifier: .popoverSlider) as? NSSliderTouchBarItem {
					let slider = sliderTouchBarItem.slider
					
					// Make the font size slider a bit narrowed, about 250 pixels.
					let views = ["slider": slider]
					let theConstraints =
						NSLayoutConstraint.constraints(withVisualFormat: "H:[slider(250)]",
													   options: NSLayoutConstraint.FormatOptions(),
													   metrics: nil,
													   views:views)
					NSLayoutConstraint.activate(theConstraints)
					
					// Set the font size for the slider item to the same value as the stepper.
					slider.integerValue = defaultFontSize
				}
			}
        }
    }
    
    // Convenience accessor to our NSTextView found in our content view controller.
    func contentTextView() -> NSTextView {
		let viewController = self.contentViewController as? ViewController
		return viewController!.textView
    }
    
    // MARK: - Font and Size setters
    
    func setTextViewFontSize(fontSize: Float) {
        fontSizeField.floatValue = round(fontSize)

        let attrs = contentTextView().typingAttributes
		if let font = attrs[NSAttributedStringKey.font] as? NSFont {
			let newerFont = NSFontManager.shared.convert(font, toSize: CGFloat(fontSize))

			if contentTextView().selectedRange().length > 0 {
				// We have a selection, change the selected text.
				contentTextView().setFont(newerFont, range: contentTextView().selectedRange())
			} else {
				// No selection, so just change the font size at insertion.
				let attributesDict = [NSAttributedStringKey.font: newerFont]
				contentTextView().typingAttributes = attributesDict
			}
		}
    }
    
    /**
     This action is called to change the font style.
     It is called through its popup toolbar item and segmented control item.
     */
    func setTextViewFont(index: Int) {
        let attrs = contentTextView().typingAttributes
		if let font = attrs[NSAttributedStringKey.font] as? NSFont {
			// Set the font properties depending upon what was selected.
			var finalFont = font
			switch index {
			case 0: // plain
				finalFont = NSFontManager.shared.convert(finalFont, toNotHaveTrait:.italicFontMask)
				finalFont = NSFontManager.shared.convert(finalFont, toNotHaveTrait:.boldFontMask)
				finalFont = NSFontManager.shared.convert(finalFont, toNotHaveTrait:.boldFontMask)
				
				// No underline attribute.
				let selectedRange = contentTextView().selectedRange()
				let textStorage = contentTextView().textStorage
				textStorage?.removeAttribute(NSAttributedStringKey.foregroundColor,
											 range: selectedRange)
				textStorage?.addAttribute(NSAttributedStringKey.underlineStyle,
										  value: NSNumber(value: 0),
										  range: selectedRange)
			case 1: // bold
				finalFont = NSFontManager.shared.convert(finalFont, toNotHaveTrait:.italicFontMask)
				finalFont = NSFontManager.shared.convert(finalFont, toHaveTrait:.boldFontMask)
			case 2: // italic
				finalFont = NSFontManager.shared.convert(finalFont, toNotHaveTrait:.boldFontMask)
				finalFont = NSFontManager.shared.convert(finalFont, toHaveTrait:.italicFontMask)
			default:
				print("invalid selection")
			}
			
			if contentTextView().selectedRange().length > 0 {
				// We have a selection, change the selected text
				contentTextView().setFont(finalFont, range: contentTextView().selectedRange())
			} else {
				// No selection, so just change the font style at insertion.
				let attributesDict = [NSAttributedStringKey.font: finalFont]
				contentTextView().typingAttributes = attributesDict
			}
		}
    }
    
    // MARK: - Action Functions
    
    /**
     This action is called to change the font size.
     It is called by the NSStepper in the toolbar item's custom view and the slider item.
     */
    @IBAction func changeFontSize(_ sender: NSStepper) {
        setTextViewFontSize(fontSize: sender.floatValue)
    }
    
    /// This action is called to change the font size from the slider item found in the NSTouchBar instance.
    @IBAction func changeFontSizeBySlider(_ sender: NSSlider) {
        setTextViewFontSize(fontSize: sender.floatValue)
    }
    
    /// This action is called from the change font style toolbar item, from the segmented control in the custom view.
    @IBAction func changeFontStyleBySegment(_ sender: NSSegmentedControl) {
       	setTextViewFont(index: sender.selectedSegment)
    }

    /**
        The NSToolbarPrintItem NSToolbarItem will send the -printDocument: message to its target.
        Since we wired its target to be ourselves in -toolbarWillAddItem:, we get called here when
        the user tries to print by clicking the toolbar item.
    */
    @objc
	func printDocument(_ sender: AnyObject) {
        let printOperation = NSPrintOperation(view: contentTextView())
        printOperation.runModal(for: window!, delegate: nil, didRun: nil, contextInfo: nil)
    }
    
    // Called when the user chooses a font style from the segmented control inside the NSTouchBar instance.
    @IBAction func touchBarFontStyleAction(_ sender: NSSegmentedControl) {
        setTextViewFont(index: sender.selectedSegment)
    }
    
    // MARK: - NSToolbarDelegate
    
    /**
        Factory method to create NSToolbarItems.

        All NSToolbarItems have a unique identifier associated with them, used to tell your delegate/controller
        what toolbar items to initialize and return at various points. Typically, for a given identifier,
        you need to generate a copy of your "master" toolbar item, and return. The function
        creates an NSToolbarItem with a bunch of NSToolbarItem parameters.

        It's easy to call this function repeatedly to generate lots of NSToolbarItems for your toolbar.
 
        The label, palettelabel, toolTip, action, and menu can all be nil, depending upon what you want
        the item to do.
    */
    func customToolbarItem(
		itemForItemIdentifier itemIdentifier: String,
		label: String,
		paletteLabel: String,
		toolTip: String,
		itemContent: AnyObject) -> NSToolbarItem? {

        let toolbarItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: itemIdentifier))
        
        toolbarItem.label = label
        toolbarItem.paletteLabel = paletteLabel
        toolbarItem.toolTip = toolTip
        toolbarItem.target = self
        
        // Set the right attribute, depending on if we were given an image or a view.
        if itemContent is NSImage {
			if let image = itemContent as? NSImage {
            	toolbarItem.image = image
			}
        } else if itemContent is NSView {
			if let view = itemContent as? NSView {
            	toolbarItem.view = view
			}
        } else {
            assertionFailure("Invalid itemContent: object")
        }
        
        /* If this NSToolbarItem is supposed to have a menu "form representation" associated with it
            (for text-only mode), we set it up here. Actually, you have to hand an NSMenuItem
            (not a complete NSMenu) to the toolbar item, so we create a dummy NSMenuItem that has our real
            menu as a submenu.
        */
        // We actually need an NSMenuItem here, so we construct one.
        let menuItem: NSMenuItem = NSMenuItem()
        menuItem.submenu = nil
        menuItem.title = label
        toolbarItem.menuFormRepresentation = menuItem
        
        return toolbarItem
    }
    
    /**
        This is an optional delegate function, called when a new item is about to be added to the toolbar.
        This is a good spot to set up initial state information for toolbar items, particularly items
        that you don't directly control yourself (like with NSToolbarPrintItemIdentifier here).
        The notification's object is the toolbar, and the "item" key in the userInfo is the toolbar item
        being added.
    */
    func toolbarWillAddItem(_ notification: Notification) {
        let userInfo = notification.userInfo!
		if let addedItem = userInfo["item"] as? NSToolbarItem {
			let itemIdentifier = addedItem.itemIdentifier
			if itemIdentifier.rawValue == "NSToolbarPrintItem" {
				addedItem.toolTip = "Print your document"
				addedItem.target = self
			}
		}
    }
    
    /**
        NSToolbar delegates require this function.
        It takes an identifier, and returns the matching NSToolbarItem. It also takes a parameter telling
        whether this toolbar item is going into an actual toolbar, or whether it's going to be displayed
        in a customization palette.
    */
    func toolbar(
		_ toolbar: NSToolbar,
		itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
		willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
		
        var toolbarItem: NSToolbarItem = NSToolbarItem()
        
        /* We create a new NSToolbarItem, and then go through the process of setting up its
            attributes from the master toolbar item matching that identifier in our dictionary of items.
        */
        if itemIdentifier.rawValue == fontStyleToolbarItemID {
            // 1) Font style toolbar item.
            toolbarItem =
				customToolbarItem(itemForItemIdentifier: fontStyleToolbarItemID,
								  label: "Font Style",
								  paletteLabel: "Font Style",
								  toolTip: "Change your font style",
								  itemContent: styleSegmentView)!
        } else if itemIdentifier.rawValue == fontSizeToolbarItemID {
            // 2) Font size toolbar item.
            toolbarItem =
				customToolbarItem(itemForItemIdentifier: fontSizeToolbarItemID,
								  label: "Font Size",
								  paletteLabel: "Font Size",
								  toolTip: "Grow or shrink the size of your font",
								  itemContent: fontSizeView)!
        }

        return toolbarItem
    }

    /**
        NSToolbar delegates require this function. It returns an array holding identifiers for the default
        set of toolbar items. It can also be called by the customization palette to display the default toolbar.
    */
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [NSToolbarItem.Identifier(rawValue: fontStyleToolbarItemID), NSToolbarItem.Identifier(rawValue: fontSizeToolbarItemID)]
        /*  Note:
            That since our toolbar is defined from Interface Builder, an additional separator and customize
            toolbar items will be automatically added to the "default" list of items.
        */
    }

    /**
        NSToolbar delegates require this function. It returns an array holding identifiers for all allowed
        toolbar items in this toolbar. Any not listed here will not be available in the customization palette.
    */
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [ NSToolbarItem.Identifier(rawValue: fontStyleToolbarItemID),
                 NSToolbarItem.Identifier(rawValue: fontSizeToolbarItemID),
                 NSToolbarItem.Identifier.space,
                 NSToolbarItem.Identifier.flexibleSpace,
                 NSToolbarItem.Identifier.print ]
    }
    
    // MARK: - NSTouchBar
    
    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .touchBar
        touchBar.defaultItemIdentifiers = [.fontStyle, .popover, NSTouchBarItem.Identifier.otherItemsProxy]
        touchBar.customizationAllowedItemIdentifiers = [.fontStyle, .popover]

        return touchBar
    }

}

extension WindowController: NSTouchBarDelegate {
    @available(OSX 10.12.2, *)
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        switch identifier {
		case NSTouchBarItem.Identifier.popover:
			
			let popoverItem = NSPopoverTouchBarItem(identifier: identifier)
			popoverItem.customizationLabel = "Font Size"
			popoverItem.collapsedRepresentationLabel = "Font Size"
			
			let secondaryTouchBar = NSTouchBar()
			secondaryTouchBar.delegate = self
			secondaryTouchBar.defaultItemIdentifiers = [.popoverSlider]
			
			/*	We can setup a different NSTouchBar instance for popoverTouchBar and pressAndHoldTouchBar
				property. Here we just use the same instance.
			*/
			popoverItem.pressAndHoldTouchBar = secondaryTouchBar
			popoverItem.popoverTouchBar = secondaryTouchBar
		
			return popoverItem
		
		case NSTouchBarItem.Identifier.fontStyle:
			let fontStyleItem = NSCustomTouchBarItem(identifier: identifier)
			fontStyleItem.customizationLabel = "Font Style"
			
			let fontStyleSegment =
				NSSegmentedControl(labels: ["Plain", "Bold", "Italic"],
								   trackingMode: .momentary,
								   target: self,
								   action: #selector(changeFontStyleBySegment))
			
			fontStyleItem.view = fontStyleSegment
			
			return fontStyleItem
		
		case NSTouchBarItem.Identifier.popoverSlider:
			let sliderItem = NSSliderTouchBarItem(identifier: identifier)
			sliderItem.label = "Size"
			sliderItem.customizationLabel = "Font Size"
			
			let slider = sliderItem.slider
			slider.minValue = 6.0
			slider.maxValue = 100.0
			slider.target = self
			slider.action = #selector(changeFontSizeBySlider)

			// Set the font size for the slider item to the same value as the stepper.
			slider.integerValue = defaultFontSize
			
			slider.bind(NSBindingName.value, to: self, withKeyPath: "currentFontSize", options: nil)

			return sliderItem
		
		default: return nil
        }
    }
    
}
