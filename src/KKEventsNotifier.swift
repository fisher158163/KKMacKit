//
//  KKEventsNotifier.swift
//  LFSMacKit
//
//  Created by 李凯 on 2021/4/30.
//

import Foundation

open class KKEventsNotifier<SubscriberProtocol> {
    private var subscribers: [KKWeakContainer<SubscriberProtocol>] = []
    
    public init() {}
    
    public func subscribe(_ subscriber: SubscriberProtocol) {
        let container = KKWeakContainer<SubscriberProtocol>.init(element: subscriber)
        subscribers.append(container)
    }

    public func notify(_ closure: (SubscriberProtocol)->()) {
        for sub in filterSubscribers() {
            closure(sub)
        }
    }

    private func filterSubscribers() -> [SubscriberProtocol] {
        subscribers.removeAll { $0.element == nil }
        return subscribers.compactMap { $0.element }
    }
}
