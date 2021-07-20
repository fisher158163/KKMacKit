//
//  CGSize+LFS.swift
//  LFSMacKit
//
//  Created by 李凯 on 2021/4/27.
//

import AppKit

public enum KKContentResizeMode {
    case aspectFit  // content 不会充满容器
    case aspectFill // content 的一部分可能被容器裁掉
}

public extension CGPoint {
    var kk_valid: Bool { !x.isNaN && !y.isNaN && !x.isInfinite && !y.isInfinite }
    
    func kk_distanceToPoint(_ targerPoint: CGPoint) -> CGFloat {
        return sqrt(pow(targerPoint.x - x, 2) + pow(targerPoint.y - y, 2))
    }
    
    /// 获取 self 这个向量在 right 这个向量上的投影
    func kk_dot(_ right: CGPoint) -> CGFloat {
        return x * right.x + y * right.y
    }
    
    static func +(aPoint: CGPoint, bPoint: CGPoint) -> CGPoint {
        return CGPoint.init(x: aPoint.x + bPoint.x, y: aPoint.y + bPoint.y)
    }
    
    static func -(aPoint: CGPoint, bPoint: CGPoint) -> CGPoint {
        return CGPoint.init(x: aPoint.x - bPoint.x, y: aPoint.y - bPoint.y)
    }
    
    static func +=(aPoint: inout CGPoint, bPoint: CGPoint) {
        aPoint.x += bPoint.x
        aPoint.y += bPoint.y
    }
    
    static func -=(aPoint: inout CGPoint, bPoint: CGPoint) {
        aPoint.x -= bPoint.x
        aPoint.y -= bPoint.y
    }
    
    func kk_distance() -> CGFloat {
        return sqrt(x * x + y * y)
    }
}

public extension CGSize {
    var kk_valid: Bool { !width.isNaN && !height.isNaN && !width.isInfinite && !height.isInfinite && width >= 0 && height >= 0 }
    var kk_visible: Bool { kk_valid && width > 0 && height > 0 }
    
    /// 把大小为 contentSize 的内容放到 self 这个 rect 里面，在 inset 和 contentMode 的限制下，返回 content 的新大小
    func kk_sizeWithContent(_ contentSize: CGSize, inset: NSEdgeInsets, contentMode: KKContentResizeMode) -> CGSize {
        let boxSize = CGSize(width: width - inset.left - inset.right, height: height - inset.top - inset.bottom)
        guard boxSize.kk_visible, contentSize.kk_visible else {
            return .zero
        }
        let boxRatio = boxSize.height / boxSize.width
        let contentRatio = contentSize.height / contentSize.width
        
        switch contentMode {
        case .aspectFit:
            if boxRatio == contentRatio {
                return boxSize
            }
            else if boxRatio > contentRatio {
                let resultWidth = boxSize.width
                let resultHeight = resultWidth * contentRatio
                return CGSize(width: resultWidth, height: resultHeight)
            }
            else {
                let resultHeight = boxSize.height
                let resultWidth = resultHeight / contentRatio
                return CGSize(width: resultWidth, height: resultHeight)
            }
        case .aspectFill:
            if boxRatio == contentRatio {
                return boxSize
            }
            else if boxRatio > contentRatio {
                let resultHeight = boxSize.height
                let resultWidth = resultHeight / contentRatio
                return CGSize(width: resultWidth, height: resultHeight)
            }
            else {
                let resultWidth = boxSize.width
                let resultHeight = resultWidth * contentRatio
                return CGSize(width: resultWidth, height: resultHeight)
            }
        }
    }
}

public extension CGRect {
    var kk_valid: Bool { origin.kk_valid && size.kk_valid }
    var kk_visible: Bool { kk_valid && size.kk_visible }
    
    var kk_center: CGPoint { CGPoint(x: width / 2, y: height / 2) }
    
    /// origin 位于左上角
    func kk_rectByInsets(_ insets: NSEdgeInsets) -> CGRect {
        let x = origin.x + insets.left
        // 别忘了 macOS 方向是倒过来的
        let y = origin.y + insets.bottom
        let width = size.width - insets.left - insets.right
        let height = size.height - insets.top - insets.bottom
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    init(center: CGPoint, size: CGSize) {
        let origin = CGPoint(x: center.x - size.width / 2, y: center.y - size.height / 2)
        self.init(origin: origin, size: size)
    }
    
    public mutating func kk_setHeight(_ height: CGFloat) {
        size = CGSize(width: size.width, height: height)
    }
}
