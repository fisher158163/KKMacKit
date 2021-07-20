//
//  LFCollectioinView.swift
//  LFSMacKit
//
//  Created by 李凯 on 2021/5/5.
//

import Foundation

public protocol KKCollectionViewDelegate: AnyObject {
    /// 返回是否允许选中
    func collectionView(_ view: KKCollectionView, tryToSelect index: Int) -> Bool
    func collectionView(_ view: KKCollectionView, didSelect index: Int)
    func numberOfItemsInCollectionView(_ view: KKCollectionView) -> Int
    func collectionView(_ view: KKCollectionView, renderCell cell: NSCollectionViewItem, at index: Int)
}

public class KKCollectionView: NSScrollView {
    public let collectionView = NSCollectionView()
    
    public weak var delegate: KKCollectionViewDelegate?
    
    /// 可以在 collectionView(_:tryToSelect:) 里通过这个属性拿到当前选中的 index
    public private(set) var selectedIndex: Int?
    
    /// 在 shouldSelect 方法里面，直接取 collectionView 自己的 selectionIndexPath 会是空的，所以应该用这个属性
    private var selectionIndexPaths: Set<IndexPath> {
        guard let selectedIndex = selectedIndex else {
            return Set()
        }
        let indexPath = IndexPath(item: selectedIndex, section: 0)
        return Set([indexPath])
    }
    
    private let cellClass: AnyClass
    
    public init(flowLayout: NSCollectionViewFlowLayout, cellClass: AnyClass) {
        self.cellClass = cellClass
        super.init(frame: .zero)
        collectionView.collectionViewLayout = flowLayout
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        drawsBackground = false
        
        collectionView.register(cellClass, forItemWithIdentifier: .init("cell"))
        collectionView.isSelectable = true
        collectionView.delegate = self
        collectionView.dataSource = self

        contentView.documentView = collectionView
        collectionView.snp.makeConstraints { m in
            m.left.right.top.equalToSuperview()
        }
    }
    
    public func reloadData() {
        collectionView.reloadData()
    }
    
    public func reloadCellAtIndex(_ index: Int) {
        let indexPaths = Set([IndexPath(item: index, section: 0)])
        collectionView.reloadItems(at: indexPaths)
    }
}

extension KKCollectionView: NSCollectionViewDelegate {
    public func collectionView(_ collectionView: NSCollectionView, shouldSelectItemsAt indexPaths: Set<IndexPath>) -> Set<IndexPath> {
        if let delegate = delegate,
           let index = indexPaths.first?.item,
           delegate.collectionView(self, tryToSelect: index) == true {
            return indexPaths
        } else {
            return selectionIndexPaths
        }
    }
    
    public func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let index = indexPaths.first?.item else {
            assertionFailure()
            return
        }
        self.selectedIndex = index
        delegate?.collectionView(self, didSelect: index)
    }
}

extension KKCollectionView: NSCollectionViewDataSource {
    public func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.numberOfItemsInCollectionView(self) ?? 0
    }
    
    public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let dequeuedView = collectionView.makeItem(withIdentifier: .init("cell"), for: indexPath)
        delegate?.collectionView(self, renderCell: dequeuedView, at: indexPath.item)
        return dequeuedView
    }
}
