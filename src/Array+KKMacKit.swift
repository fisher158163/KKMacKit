//
//  Array+LFS.swift
//  LFSMacKit
//
//  Created by 李凯 on 2021/4/30.
//

import Foundation

public extension Array {
    public subscript(safe index: Index) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
    
    public mutating func enumerate(count: Int, add:((_ index: Int) -> Element), hide:((_ index: Int, _ object: Element) -> Void), process:((_ index: Int, _ object: Element) -> Void)) {
        for idx in 0..<count {
            if idx < self.count {
                let existedObj = self[idx]
                process(idx, existedObj)
            } else {
                let newObj = add(idx)
                self.append(newObj)
                process(idx, newObj)
            }
        }
        if self.count > count {
            for idx in count..<self.count {
                let existedObj = self[idx]
                hide(idx, existedObj)
            }
        }
    }
}
