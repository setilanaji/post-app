//
//  UserEntity.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import Foundation
import RealmSwift

public class UserEntity: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name = ""
    @objc dynamic var username = ""
    @objc dynamic var avatar = ""
    
    public override static func primaryKey() -> String? {
        return "id"
    }
}
