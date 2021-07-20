//
//  KKCollectionViewCell.swift
//  LFSMacKit
//
//  Created by 李凯 on 2021/5/5.
//

import Foundation

open class KKCollectionViewCell: NSCollectionViewItem {
    public let iconView = NSImageView()
    private var loadingIndicator: NSProgressIndicator?
    
    public var isLoading: Bool = false {
        didSet {
            if isLoading {
                createLoadingIndicatorIfNeeded().startAnimation(self)
            } else {
                loadingIndicator?.stopAnimation(self)
            }
        }
    }
    
    open override func loadView() {
        self.view = NSView()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    
        iconView.wantsLayer = true
        iconView.layer?.cornerRadius = 2.0;
        iconView.layer?.masksToBounds = true;
        view.addSubview(iconView)
    
        iconView.snp.makeConstraints { m in
            m.edges.equalToSuperview()
        }
    }
    
    private func createLoadingIndicatorIfNeeded() -> NSProgressIndicator {
        if let indicator = loadingIndicator {
            return indicator
        }
        let indicator = NSProgressIndicator()
        self.loadingIndicator = indicator
        indicator.controlSize = .small
        indicator.style = .spinning
        indicator.isIndeterminate = true
        indicator.isBezeled = false
        indicator.isDisplayedWhenStopped = false
        view.addSubview(indicator)
        indicator.snp.makeConstraints { m in
            m.center.equalTo(iconView)
        }
        return indicator
    }
}
