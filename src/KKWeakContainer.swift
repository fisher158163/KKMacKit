//
//  KKWeakContainer.swift
//  LFSMacKit
//
//  Created by 李凯 on 2021/4/30.
//

import Foundation

public struct KKWeakContainer<Element> {
    private weak var value: AnyObject?

    public var element: Element? { value as? Element }

    public init(element: Element) {
        self.value = element as AnyObject
    }
}
