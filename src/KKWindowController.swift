//
//  KKWindowController.swift
//  LFSMacKit
//
//  Created by 李凯 on 2021/4/29.
//

import AppKit

open class KKWindowController: NSWindowController {
    open class func createViewController() -> NSViewController {
        return KKViewController()
    }
    
    open class func createWindow() -> NSWindow {
        let windowSize = initialWindowSize()
        let window = NSWindow.init(contentRect: NSRect(x: 0, y: 0, width:windowSize.width, height: windowSize.height), styleMask: [.titled, .closable, .resizable, .miniaturizable], backing: .buffered, defer: true)
        return window
    }
    
    open class func initialWindowSize() -> NSSize {
        return NSSize(width: 600, height: 480)
    }
    
    public init() {
        let window = Self.createWindow()
        super.init(window: window)
        
        let vc = Self.createViewController()
        window.contentView = vc.view
        contentViewController = vc
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
