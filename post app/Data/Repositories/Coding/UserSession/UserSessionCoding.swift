//
//  UserSessionCoding.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/23.
//

import Foundation

public protocol UserSessionCoding {
  
  func encode(userSession: UserSessionModel) -> Data
  func decode(data: Data) -> UserSessionModel
}
