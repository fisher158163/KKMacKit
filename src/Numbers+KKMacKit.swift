//
//  Numbers+LFS.swift
//  LFSMacKit
//
//  Created by 李凯 on 2021/5/13.
//

import Foundation

public extension CGFloat {
    public func kk_almostEqualTo(_ targetNumber: CGFloat) -> Bool {
        return abs(targetNumber - self) < 0.1
    }
}
