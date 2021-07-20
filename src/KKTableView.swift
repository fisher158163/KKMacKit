//
//  KKTableView.swift
//  XTHelper
//
//  Created by likai123 on 2021/3/3.
//

import Cocoa

public protocol KKTableViewDelegate: AnyObject {
    /// row 数量
    func numberOfRowsInTableView(_ tableView: KKTableView) -> Int
    /// 如果业务全部 cell 都是相同类型的则不用实现该方法
    func tableView(_ tableView: KKTableView, reuseIdAtRow row: Int) -> String
    /// 业务要创建并返回一个全新的 view 作为 cellView，业务不需要主动给返回的 cellView 设置 cell identiier
    /// 推荐使用 KKAutoHeightTableCellView / KKFixedHeightTableCellView
    func tableView(_ tableView: KKTableView, createCellWithReuseID id: String) -> NSView
    func tableView(_ tableView: KKTableView, renderCell cell: NSView, atRow row: Int)
    /// 当 selectionEnabled 为 true 时会发出该通知，业务可以不实现该方法。row 可能为 -1
    func tableView(_ tableView: KKTableView, didSelectRow newRow: Int, previousSelectedRow oldRow: Int)
    /// 当 hoverEnabled 为 true 时会发出该通知，业务可以不实现该方法
    func tableView(_ tableView: KKTableView, didHoverAtRow newRow: Int?, oldRow: Int?)
    /// 先调用 wantsScrollEventsDelegate，然后就可以通过该方法接收 didScroll 通知
    func tableViewDidScroll(_ tableView: KKTableView)
    func tableview(_ tableView: KKTableView, didScrollWheel event: NSEvent)
}

public extension KKTableViewDelegate {
    func tableView(_ tableView: KKTableView, reuseIdAtRow row: Int) -> String {
        return "cell"
    }
    func tableView(_ tableView: KKTableView, didHoverAtRow newRow: Int?, oldRow: Int?) {}
    func tableView(_ tableView: KKTableView, didSelectRow newRow: Int, previousSelectedRow oldRow: Int) {}
    func tableViewDidScroll(_ tableView: KKTableView) {}
    func tableview(_ tableView: KKTableView, didScrollWheel event: NSEvent) {}
}

/// 如果想改背景色，请设置 self.tableView 的 backgroundColor 而非 self.backgroundColor，否则 macOS 11.0 上似乎无效、强制变成磨砂，没细细研究为啥
open class KKTableView: NSScrollView {
    public let tableView: NSTableView
    public weak var delegate: KKTableViewDelegate? {
        didSet {
            tableView.reloadData()
        }
    }
    
    /// 是否监听每个 cell 的 hover 事件，如果置为 true 则会向 delegate 发送 hover 相关事件
    public var hoverEnabled = false
    public var hoveredRow: Int?
    
    /// 是否直接使用系统自带的 cell 选中样式
    public var useSystemSelectionStyle = true {
        didSet {
            tableView.selectionHighlightStyle = useSystemSelectionStyle ? .sourceList : .none
        }
    }
    public private(set) var selectedRow: Int = -1
    public private(set) var previousSelectedRow: Int = -1
    
    public var numberOfRows: Int { tableView.numberOfRows }
    
    public override init(frame frameRect: NSRect) {
        self.tableView = NSTableView()
        super.init(frame: frameRect)
        
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func updateTrackingAreas() {
        super.updateTrackingAreas()
        if !hoverEnabled {
            return
        }
        trackingAreas.forEach { (oldArea) in
            self.removeTrackingArea(oldArea)
        }
        
        let newArea = NSTrackingArea(rect: bounds, options: [.mouseEnteredAndExited, .mouseMoved, .activeInKeyWindow, .inVisibleRect], owner: self, userInfo: nil)
        addTrackingArea(newArea)
    }
    
    open override func mouseMoved(with event: NSEvent) {
        super.mouseMoved(with: event)
        updateHoveredRowWithMouseEvent(event)
    }
    
    /// 当鼠标离开 tableView 会调用这个方法
    /// 当鼠标离开了某一个 row 进入另一个 row 时，这一个方法也会被调用（系统行为）
    open override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        updateHoveredRowWithMouseEvent(event)
    }
    
    /// 不再使用可变高度的 cellView，而是写死高度，此时应该使用 KKFixedHeightTableCellView，不应该再用 KKAutoHeightTableCellView
    public func setFixedRowHeight(_ height: CGFloat) {
        tableView.usesAutomaticRowHeights = false
        tableView.rowHeight = height
    }
    
    private func updateHoveredRowWithMouseEvent(_ event: NSEvent) {
        let rawPoint = event.locationInWindow
        let point = tableView.convert(rawPoint, from: nil)
        // 如果是离开 tableView，则这里的 row 为 -1
        let rawHoveredRow = tableView.row(at: point)

        let newHoveredRow: Int?
        if rawHoveredRow >= 0 {
            newHoveredRow = rawHoveredRow
        } else {
            newHoveredRow = nil
        }
        
        if newHoveredRow != self.hoveredRow {
            let oldRow = self.hoveredRow
            self.hoveredRow = newHoveredRow
            delegate?.tableView(self, didHoverAtRow: newHoveredRow, oldRow: oldRow)
        }
    }
    
    public enum SelectionStrategy {
        /// 不选中任何
        case clearSelection
        /// 自动选中原本被选择的 row，但如果目标 row 已经不存在了则会尝试选中传入的 Int 这个 row，如果连 Int 这个 row 都不存在了则会取消所有选中态
        case keepingSelection(Int?)
        /// 尝试选中某一个 row，如果该 row 不存在则会清空选中态
        case selectRow(Int?)
    }
    
    public func reloadDataAndClearSelection() {
        tableView.reloadData()
        // 系统的 reloadData 会自动偷偷把 tableView.selectedRow 置为空，因此这里要追踪并同步这一变化
        notifySelectedRowDidChange(triggerDelegate: true)
    }
    
    /// selectionStrategy 是指 reloadData 完成之后的选中态策略
    public func reloadData(_ selectionStrategy: SelectionStrategy) {
        let selectedRowBeforeReload = selectedRow
        
        tableView.reloadData()
        // 系统的 reloadData 会自动偷偷把 tableView.selectedRow 置为空，因此这里要追踪并同步这一变化
        notifySelectedRowDidChange(triggerDelegate: false)
    
        if let willSelectRow = resolveSelectionAfterReload(selectedRowBeforeReload: selectedRowBeforeReload, strategy: selectionStrategy) {
            tableView.layoutSubtreeIfNeeded()
            selectRow(willSelectRow)
        } else {
            triggerSelectionDelegate()
        }
    }
    
    public func reloadAvailableRows() {
        var indexes: [Int] = []
        tableView.enumerateAvailableRowViews { (rowView, idx) in
            indexes.append(idx)
        }
        reloadRows(indexes)
    }
    
    public func reloadRow(_ row: Int) {
        reloadRows([row])
    }
    
    public func reloadRows(_ rows: [Int?]) {
        let validRows = rows.compactMap { $0 }
        tableView.reloadData(forRowIndexes: IndexSet(validRows), columnIndexes: IndexSet([0]))
    }
    
    /// 如果 row 小于 0 则表示取消选中
    public func selectRow(_ row: Int?) {
        if let row = row, row >= 0 {
            let indexes = IndexSet.init(integer: row)
            tableView.selectRowIndexes(indexes, byExtendingSelection: false)
        } else {
            tableView.deselectAll(self)
        }
    }
    
    /// 系统可能自动加一个磨砂不知道怎么去掉，这里强制隐藏
    /// https://stackoverflow.com/questions/58813759/how-to-prevent-macos-from-inserting-an-nsvisualeffectview-into-an-nsscrollview-a
    private var shouldHideVisualEffect = false
    public func hideVisualEffectView() {
        shouldHideVisualEffect = true
        
        for subview in subviews {
            if subview is NSVisualEffectView {
                subview.isHidden = true
            }
        }
    }
    
    open override func didAddSubview(_ subview: NSView) {
        super.didAddSubview(subview)

        if shouldHideVisualEffect {
            if subview is NSVisualEffectView {
                subview.isHidden = true
            }
        }
    }
    
    public func wantsScrollEventsDelegate() {
        contentView.postsBoundsChangedNotifications = true
        NotificationCenter.default.addObserver(self, selector: #selector(handleDidScrollNotification), name: NSView.boundsDidChangeNotification, object: contentView)
    }
    
    @objc public func handleDidScrollNotification() {
        delegate?.tableViewDidScroll(self)
    }
    
    open override func scrollWheel(with event: NSEvent) {
        super.scrollWheel(with: event)
        delegate?.tableview(self, didScrollWheel: event)
    }
}

extension KKTableView: NSTableViewDelegate, NSTableViewDataSource {
    public func numberOfRows(in tableView: NSTableView) -> Int {
        let result = delegate?.numberOfRowsInTableView(self) ?? 0
        return result
    }
    
    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let reuseID = delegate?.tableView(self, reuseIdAtRow: row),
              let view = dequeueCellViewWithID(reuseID) else {
            return nil
        }
        delegate?.tableView(self, renderCell: view, atRow: row)
        return view
    }
    
    /// mouseUp 时会调用，通过键盘切换 row 时会调用
    public func tableViewSelectionDidChange(_ notification: Notification) {
        notifySelectedRowDidChange()
    }
    
    /// mouseDown 时会调用，但通过键盘切换 row 不会被调用
    public func tableViewSelectionIsChanging(_ notification: Notification) {
        notifySelectedRowDidChange()
    }
}

extension KKTableView {
    private func notifySelectedRowDidChange(triggerDelegate: Bool = true) {
        let oldRow = selectedRow
        let newRow = tableView.selectedRow
        if oldRow == newRow {
            return
        }
        previousSelectedRow = selectedRow
        selectedRow = newRow
        if triggerDelegate {
            triggerSelectionDelegate()
        }
    }
    
    private func triggerSelectionDelegate() {
        delegate?.tableView(self, didSelectRow: selectedRow, previousSelectedRow: previousSelectedRow)
    }
    
    private func setupUI() {
        drawsBackground = false
        wantsLayer = true
        // 因为我们重写了 scrollWheel 方法，所以这里必须加这一句，否则无法滚动
        // https://stackoverflow.com/questions/31186430/scrolling-in-nsscrollview-stops-when-overwriting-scrollwheel-function
        hasVerticalScroller = true
        
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = .clear
        tableView.headerView = nil
        tableView.intercellSpacing = .zero
        tableView.usesAutomaticRowHeights = true
        if #available(OSX 11.0, *) {
            // sourceList: macOS 11 新出的左右都有 inset 的样式
            // fullWidth: 旧 macOS 的样式，宽度撑满
            tableView.style = .sourceList
        }
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "col"))
        column.isEditable = false
        tableView.addTableColumn(column)
        contentView.documentView = tableView
        tableView.snp.remakeConstraints { (m) in
            m.left.right.top.equalToSuperview()
        }
    }
    
    private func dequeueCellViewWithID(_ id: String) -> NSView? {
        let identifier = NSUserInterfaceItemIdentifier(rawValue: id)
        if let view = tableView.makeView(withIdentifier: identifier, owner: nil) {
            return view
        }
        let view = delegate?.tableView(self, createCellWithReuseID: id)
        view?.identifier = identifier
        return view
    }
    
    private func resolveSelectionAfterReload(selectedRowBeforeReload: Int, keepingSelection: Bool, fallbackSelectedRow: Int?) -> Int? {
        if keepingSelection, isRowValid(selectedRowBeforeReload) {
            return selectedRowBeforeReload
        }
        if let fallbackSelectedRow = fallbackSelectedRow, isRowValid(fallbackSelectedRow) {
            return fallbackSelectedRow
        }
        return nil
    }
    
    private func resolveSelectionAfterReload(selectedRowBeforeReload: Int, strategy: SelectionStrategy) -> Int? {
        switch strategy {
        case .clearSelection:
            return nil
            
        case .keepingSelection(let fallbackRow):
            if isRowValid(selectedRowBeforeReload) {
                return selectedRowBeforeReload
            }
            if let fallbackRow = fallbackRow, isRowValid(fallbackRow) {
                return fallbackRow
            }
            return nil

        case .selectRow(let targetRow):
            if let targetRow = targetRow, isRowValid(targetRow) {
                return targetRow
            }
            return nil
        }
    }
    
    private func isRowValid(_ row: Int) -> Bool {
        if row >= 0, row < tableView.numberOfRows {
            return true
        } else {
            return false
        }
    }
}
