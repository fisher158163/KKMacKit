//
//  KKBox.swift
//  XTHelper
//
//  Created by likai123 on 2021/3/4.
//

import Cocoa

open class KKBox: NSBox {
    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.boxType = .custom
        self.titlePosition = .noTitle
        self.borderWidth = 0
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
