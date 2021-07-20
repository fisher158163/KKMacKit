//
//  LFSColors.swift
//  LFSMacKit
//
//  Created by 李凯 on 2021/4/28.
//

import Foundation

public extension NSColor {
    static var kk_sidePanelBackground: NSColor {
        if #available(OSX 10.15, *) {
            return NSColor.init(name: nil) { (appearance) -> NSColor in
                if appearance.name == .darkAqua {
                    return NSColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
                } else {
                    return NSColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
                }
            }
        } else {
            return NSColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        }
    }
    
    static var kk_canvasBackground: NSColor {
        if #available(OSX 10.15, *) {
            return NSColor.init(name: nil) { (appearance) -> NSColor in
                if appearance.name == .darkAqua {
                    return NSColor(red: 19/255, green: 20/255, blue: 21/255, alpha: 1)
                } else {
                    return NSColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                }
            }
        } else {
            return NSColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        }
    }
}
