//
//  Post.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import Foundation

public struct PostModel {
    public var id: Int
    public var text: String
    public var image: String
    public var date: String
    public var creator: UserModel
    public var photoID: Int?
}
