//
//  KKViewController.swift
//  LFSMacKit
//
//  Created by 李凯 on 2021/4/29.
//

import Foundation

open class KKViewController: NSViewController {
    open override func loadView() {
        // 不要调用 super，因为 super 的实现是去找 nib 进而报错
        self.view = NSView()
    }
}
