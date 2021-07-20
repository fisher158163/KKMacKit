//
//  Error+LFS.swift
//  LFSMacKit
//
//  Created by 李凯 on 2021/5/5.
//

import Foundation

public extension Error {
    func kk_alert() {
        guard let window = NSApplication.shared.keyWindow else {
            return
        }
        let alert = NSAlert.init(error: self)
        alert.beginSheetModal(for: window, completionHandler: nil)
    }
}
