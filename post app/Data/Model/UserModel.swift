//
//  User.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import Foundation

public struct UserModel: Identifiable, Equatable, Codable {
    public let id: Int
    public let name: String
    public let username: String
    public let avatar: String
    
    public init(
        id: Int = 0,
        name: String = "",
        username: String = "",
        avatar: String = ""
    ) {
        self.id = id
        self.name = name
        self.username = username
        self.avatar = avatar
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case username
        case avatar
    }
    
    public static func ==(lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.id == rhs.id
        && lhs.username == rhs.username
        && lhs.avatar == rhs.avatar
        && lhs.name == rhs.name
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        username = try values.decode(String.self, forKey: .username)
        avatar = try values.decode(String.self, forKey: .avatar)
    }
}

extension UserModel {
    static func make(withEncodeDictionary dictionary: [String: Any]) -> UserModel {
        let id = dictionary["id"]! as! Int
        let name = dictionary["name"]! as! String
        let username = dictionary["username"]! as! String
        let avatar = dictionary["avatar"]! as! String
        
        return UserModel(
            id: id,
            name: name,
            username: username,
            avatar: avatar)
    }
    
    func asDictionary() -> [String: Any] {
        return ["id": id,
                "name": name,
                "username": username,
                "avatar": avatar]
    }
}
