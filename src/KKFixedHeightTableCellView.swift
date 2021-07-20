//
//  KKFixedHeightTableCellView.swift
//  LFSMacKit
//
//  Created by 李凯 on 2021/5/5.
//

import Foundation

open class KKFixedHeightTableCellView: NSTableCellView {
    public let iconView = NSImageView()
    public let label = NSTextField.init(labelWithString: "")

    public var iconCornerRadius: CGFloat = 0 {
        didSet {
            iconView.wantsLayer = true
            iconView.layer?.cornerRadius = iconCornerRadius
            iconView.layer?.masksToBounds = true
        }
    }
    
    public init(imageSize: CGSize, horInset: CGFloat, interspace: CGFloat) {
        super.init(frame: .zero)
        addSubview(iconView)
        
        label.lineBreakMode = .byTruncatingTail
        addSubview(label)
    
        iconView.snp.makeConstraints { m in
            m.size.equalTo(imageSize)
            m.centerY.equalToSuperview()
            m.left.equalToSuperview().inset(horInset)
        }
        
        // 至少在 macOS 11 的 .sourceList 中，cellView 的系统宽度优先级是 500，因此这里要改成比 500 低
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.snp.makeConstraints { m in
            m.left.equalTo(iconView.snp.right).offset(interspace)
            m.right.lessThanOrEqualToSuperview().inset(horInset)
            m.centerY.equalToSuperview()
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
