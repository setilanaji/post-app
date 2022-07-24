//
//  UserSessionPropertyListCoder.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/23.
//

import Foundation

public class UserSessionPropertyListCoder: UserSessionCoding {

  public init() {}

  public func encode(userSession: UserSessionModel) -> Data {
    return try! PropertyListEncoder().encode(userSession)
  }

  public func decode(data: Data) -> UserSessionModel {
    return try! PropertyListDecoder().decode(UserSessionModel.self, from: data)
  }
}
