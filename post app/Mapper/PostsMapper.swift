//
//  UsersMapper.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import Foundation

public struct PostsMapper<PostMapper: Mapper>: Mapper
where
PostMapper.Entity == PostEntity,
PostMapper.Domain == PostModel {
    
    public typealias Domain = [PostModel]
    public typealias Entity = [PostEntity]
    
    private let postMapper: PostMapper
    
    public init(postMapper: PostMapper) {
        self.postMapper = postMapper
    }
    
    public func transformEntityToDomain(entity: [PostEntity]) -> [PostModel] {
        return entity.map { result in
            self.postMapper.transformEntityToDomain(entity: result)
        }
    }
    
    public func transformDomainToEntity(domain: [PostModel]) -> [PostEntity] {
        return domain.map { result in
            self.postMapper.transformDomainToEntity(domain: result)
        }
    }
}
