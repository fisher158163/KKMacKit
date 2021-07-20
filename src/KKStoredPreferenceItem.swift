//
//  KKStoredPreferenceItem.swift
//  LFSMacKit
//
//  Created by 李凯 on 2021/5/13.
//

import Foundation

public class KKStoredPreferenceItem<T> {
    private let dbKey: String
    public var value: T {
        didSet {
            UserDefaults.standard.setValue(value, forKey: dbKey)
            didChange?(value)
        }
    }
    public var didChange: ((T) -> Void)? {
        didSet {
            didChange?(value)
        }
    }

    public init(dbKey: String, defaultValue: T) {
        self.dbKey = dbKey
        if let storedValue = UserDefaults.standard.value(forKey: dbKey) as? T {
            self.value = storedValue
        } else {
            self.value = defaultValue
        }
    }
}
