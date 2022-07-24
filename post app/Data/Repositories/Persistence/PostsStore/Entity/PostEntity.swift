//
//  PostEntity.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import Foundation
import RealmSwift

public class PostEntity: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var text = ""
    @objc dynamic var image = ""
    @objc dynamic var date = ""
    @objc dynamic var photoID: Int = 0
    @objc dynamic var creator: UserEntity?
    
    public override static func primaryKey() -> String? {
        return "id"
    }
}
