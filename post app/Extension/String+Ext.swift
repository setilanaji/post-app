//
//  String+Ext.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/25.
//

import Foundation

extension String {
    var isNothing: Bool {
       return self.allSatisfy({ $0 == " " || $0 == "\n" }) || self.isEmpty
    }
}
