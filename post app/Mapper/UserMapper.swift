//
//  UserMapper.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import Foundation

public struct UserMapper: Mapper {
    public typealias Entity = UserEntity
    public typealias Domain = UserModel
    
    public func transformEntityToDomain(entity: UserEntity) -> UserModel {
        return UserModel(
            id: entity.id,
            name: entity.name,
            username: entity.username,
            avatar: entity.avatar)
    }
    
    public func transformDomainToEntity(domain: UserModel) -> UserEntity {
        
        let userEntity = UserEntity()
        
        userEntity.id = domain.id
        userEntity.name = domain.name
        userEntity.avatar = domain.avatar
        userEntity.username = domain.username
        
        return userEntity
    }
    
}
