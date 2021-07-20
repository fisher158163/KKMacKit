//
//  KKSolidView.swift
//  LFSMacKit
//
//  Created by 李凯 on 2021/5/13.
//

import Foundation

public class KKSolidView: NSView {
    public var backgroundColor: NSColor? {
        didSet {
            layer?.backgroundColor = backgroundColor?.cgColor
        }
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
