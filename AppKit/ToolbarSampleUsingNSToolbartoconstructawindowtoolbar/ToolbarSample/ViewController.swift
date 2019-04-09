/*
 Copyright (C) 2018 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The primary view controller holding the toolbar and text view.
 */

import Cocoa

class ViewController: NSViewController, NSTextViewDelegate {

    @IBOutlet var textView: NSTextView!
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        if #available(OSX 10.12.2, *) {
            // Opt-out of text completion in this simplified version.
            textView?.isAutomaticTextCompletionEnabled = false
        }
        
        view.window?.makeFirstResponder(textView)
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    // MARK: - NSTextViewDelegate
    
	@available(OSX 10.12.2, *)
	func textView(_ textView: NSTextView, shouldUpdateTouchBarItemIdentifiers identifiers: [NSTouchBarItem.Identifier]) -> [NSTouchBarItem.Identifier] {
        return []   // We want to show only our NSTouchBarItem instances.
    }
    
}
