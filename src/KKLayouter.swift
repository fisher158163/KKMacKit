//
//  LFLayouter.swift
//  XTHelper
//
//  Created by 李凯 on 2021/3/27.
//

import AppKit

extension Array where Element: NSView {
    @discardableResult public func kk_layout(_ layout: ((_ currView: NSView, _ prevView: NSView?)->Void)) -> NSView? {
        for (idx, view) in self.enumerated() {
            if idx == 0 {
                layout(view, nil)
            } else {
                layout(view, self[idx - 1])
            }
        }
        return self.last
    }
    
    @discardableResult public func kk_layoutAfter(_ prevView: NSView, _ layout: ((_ currView: NSView, _ prevView: NSView)->Void)) -> NSView {
        if self.isEmpty {
            return prevView
        }
        for (idx, view) in self.enumerated() {
            if idx == 0 {
                layout(view, prevView)
            } else {
                layout(view, self[idx - 1])
            }
        }
        return self.last!
    }
}
