//
//  PostMapper.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import Foundation

public struct PostMapper<UserMapper: Mapper>: Mapper
where
UserMapper.Entity == UserEntity,
UserMapper.Domain == UserModel{
    
    private let userMapper: UserMapper
    
    public init(userMapper: UserMapper){
        self.userMapper = userMapper
    }
    
    public typealias Domain = PostModel
    public typealias Entity = PostEntity
    
    public func transformDomainToEntity(domain: PostModel) -> PostEntity {
        
        let postEntity = PostEntity()
        
        postEntity.id = domain.id
        postEntity.text = domain.text
        postEntity.image = domain.image
        postEntity.date = domain.date
        postEntity.photoID = domain.photoID ?? 0
        postEntity.creator = self.userMapper.transformDomainToEntity(domain: domain.creator)
        
        return postEntity
    }
    
    public func transformEntityToDomain(entity: PostEntity) -> PostModel {
        
        return PostModel(
            id: entity.id,
            text: entity.text,
            image: entity.image,
            date: entity.date,
            creator:
                {
                    guard let creator = entity.creator else {
                        return UserModel()
                    }
                    
                    return self.userMapper.transformEntityToDomain(entity: creator)
                }(),
            photoID: entity.photoID == 0 ? nil : entity.photoID
        )
    }
}
