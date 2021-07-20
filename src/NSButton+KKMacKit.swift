//
//  NSButton+Extension.swift
//  XTHelper
//
//  Created by likai123 on 2021/3/26.
//

import AppKit

public extension NSButton {
    /// 鼠标按下的时候会变蓝
    public static func buttonWithTitle(_ title: String) -> NSButton {
        let button = NSButton()
        button.title = title
        button.isBordered = true
        button.setButtonType(.momentaryPushIn)
        // .rounded 蓝色，高度调节❌，字号❌（可以加大但是会文字溢出）
        // .texturedRounded 无背景色，高度调节❌
        // .recessed .roundRect 灰色，圆角，高度调节❌
        // .inline 灰色，圆角，高度调节✅，字号❌
        // .regularSquare 灰色，圆角（但没 inline 那么圆），高度调节✅
        button.bezelStyle = .rounded
        return button
    }
    
    func setkeyEquivalentToESC() {
        keyEquivalent = "\u{1b}"
    }
    
    /// 记得一定要让 window 的 style 包含 .titled 否则 keyEquivalent 无法生效
    func setkeyEquivalentToReturn() {
        keyEquivalent = "\r"
    }
}
