//
//  UserSessionModel.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/23.
//

import Foundation

public struct UserSessionModel: Equatable, Codable {
    public let user: UserModel
    
    public static func ==(lhs: UserSessionModel, rhs: UserSessionModel) -> Bool {
      return lhs.user == rhs.user
    }
}
