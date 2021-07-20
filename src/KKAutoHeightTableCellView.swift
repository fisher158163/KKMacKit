//
//  KKAutoHeightTableCellView.swift
//  XTHelper
//
//  Created by 李凯 on 2021/3/4.
//

import Cocoa
import SnapKit

open class KKAutoHeightTableCellView: NSTableCellView {
    public let iconView = NSImageView()
    public let label = NSTextField.init(labelWithString: "")
    
    public var insets: NSEdgeInsets {
        didSet {
            setupLayout()
        }
    }
    private let interspace: CGFloat
    
    /// cell 的高度由 label 的高度和 insets.top + insets.bottom 决定，和 iconView 无关
    public init(insets: NSEdgeInsets, interspace: CGFloat) {
        self.insets = insets
        self.interspace = interspace
        
        super.init(frame: .zero)
        
        addSubview(iconView)
        
        label.lineBreakMode = .byTruncatingTail
        addSubview(label)
        
        setupLayout()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        iconView.snp.remakeConstraints { (m) in
            m.centerY.equalToSuperview()
            m.left.equalToSuperview().inset(insets.left)
        }
        // 至少在 macOS 11 的 .sourceList 中，cellView 的系统宽度优先级是 500，因此这里要改成比 500 低
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.snp.remakeConstraints { (m) in
            m.left.equalTo(iconView.snp.right).offset(interspace)
            m.right.lessThanOrEqualToSuperview().inset(insets.right)
            m.top.equalToSuperview().inset(insets.top)
            m.bottom.equalToSuperview().inset(insets.bottom)
        }
    }
}
