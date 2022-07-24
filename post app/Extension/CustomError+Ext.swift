//
//  CustomError+Ext.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import Foundation

public enum DatabaseError: LocalizedError {
    case invalidInstance
    case requestFailed
    
    public var errorDescription: String? {
        switch self {
        case .invalidInstance: return "Database can't instance"
        case .requestFailed: return "Your request is failed"
        }
    }
}

public enum PrefsError: LocalizedError {
    case keyNotFound(key: String)
    
    public var errorDescription: String? {
        switch self {
        case .keyNotFound(let key): return "Data with key:\(key) is not found"
        }
    }
}
