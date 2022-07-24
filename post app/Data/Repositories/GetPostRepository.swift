//
//  GetPostsRepository.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import Foundation
import Combine

public struct GetPostRepository<
    Local: LocalDataSource,
    DataMapper: Mapper>: Repository
where
Local.Request == String,
Local.Response == PostEntity,
DataMapper.Domain == PostModel,
DataMapper.Entity == PostEntity {
    
    public typealias Request = String
    public typealias Response = PostModel
    
    private let mapper: DataMapper
    private let local: Local
    
    public init(
        mapper: DataMapper,
        local: Local
    ) {
        self.mapper = mapper
        self.local = local
    }
    
    public func excecute(request: String) -> AnyPublisher<PostModel, Error> {
        return local.get(request: request)
            .map { localResult in
                return self.mapper.transformEntityToDomain(entity: localResult)
            }.eraseToAnyPublisher()
    }
    
}
