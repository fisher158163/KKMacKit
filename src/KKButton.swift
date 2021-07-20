//
//  KKButton.swift
//  LFSMacKit
//
//  Created by 李凯 on 2021/5/2.
//

import AppKit

public class KKButton: NSControl {
    public enum Position {
        case leftToRight    // 图片在左，文字在右
        case topToBottom    // 图片在上，文字在下
    }
    /// 设置布局
    public var position: Position = .leftToRight {
        didSet {
            remakeLayout()
        }
    }
    /// 控制文字和图片之间的间距
    public var spaceBetweenImageAndLabel: CGFloat = 6 {
        didSet {
            remakeLayout()
        }
    }
    /// 设置图片
    public let imageView = NSImageView()
    /// 设置文字
    public let label = NSTextField(labelWithString: "")
    
    private let selectionBox = KKBox()
    
    public var isSelected = false {
        didSet {
            selectionBox.isHidden = !isSelected
        }
    }
    
    private let wrapperView = NSView()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        selectionBox.fillColor = NSColor.unemphasizedSelectedContentBackgroundColor
        selectionBox.isHidden = true
        addSubview(selectionBox)
        
        wrapperView.addSubview(imageView)
        wrapperView.addSubview(label)
        addSubview(wrapperView)
        
        remakeLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var acceptsFirstResponder: Bool {
        return true
    }

    public override func becomeFirstResponder() -> Bool {
        return true
    }

    public override func mouseDown(with event: NSEvent) {
        window?.makeFirstResponder(self)
    }

    public override func mouseUp(with event: NSEvent) {
        if let action = action {
            NSApp.sendAction(action, to: target, from: self)
        }
    }
    
    private func remakeLayout() {
        switch position {
        case .leftToRight:
            remakeLeftToRightLayout()
        case .topToBottom:
            remakeTopToBottomLayout()
        }
        
        selectionBox.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
    }
    
    private func remakeLeftToRightLayout() {
        imageView.snp.remakeConstraints { (m) in
            m.left.equalToSuperview()
            m.centerY.equalToSuperview()
            m.height.equalToSuperview().priorityLow()
            m.height.lessThanOrEqualToSuperview()
        }
        label.snp.remakeConstraints { (m) in
            m.left.equalTo(imageView.snp.right).offset(spaceBetweenImageAndLabel)
            m.right.equalToSuperview()
            m.centerY.equalToSuperview()
            m.height.equalToSuperview().priorityLow()
            m.height.lessThanOrEqualToSuperview()
        }
        wrapperView.snp.remakeConstraints { (m) in
            m.center.equalToSuperview()
            m.edges.equalToSuperview().priorityLow()
        }
    }
    
    private func remakeTopToBottomLayout() {
        imageView.snp.remakeConstraints { (m) in
            m.top.equalToSuperview()
            m.centerX.equalToSuperview()
            m.width.equalToSuperview().priorityLow()
            m.width.lessThanOrEqualToSuperview()
        }
        label.snp.remakeConstraints { (m) in
            m.top.equalTo(imageView.snp.bottom).offset(spaceBetweenImageAndLabel)
            m.bottom.equalToSuperview()
            m.centerX.equalToSuperview()
            m.width.equalToSuperview().priorityLow()
            m.width.lessThanOrEqualToSuperview()
        }
        wrapperView.snp.remakeConstraints { (m) in
            m.center.equalToSuperview()
            m.edges.equalToSuperview().priorityLow()
        }
    }
}

