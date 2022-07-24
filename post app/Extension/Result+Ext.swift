//
//  Result+Ext.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import Foundation
import RealmSwift

extension Results {
    public func toArray<T>(offType: T.Type) -> [T] {
        var array = [T]()
        for index in 0 ..< count {
            if let result = self[index] as? T {
                array.append(result)
            }
        }
        return array
    }
}
