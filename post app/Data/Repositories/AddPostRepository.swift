//
//  AddPostRepository.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/23.
//

import Foundation
import Combine

public struct AddPostRepository<
    Local: LocalDataSource,
    DataMapper: Mapper>: Repository
where
Local.Request == String,
Local.Response == PostEntity,
DataMapper.Domain == PostModel,
DataMapper.Entity == PostEntity {
    
    public typealias Request = PostModel
    public typealias Response = Bool
    
    private let mapper: DataMapper
    private let local: Local
    
    public init(
        mapper: DataMapper,
        local: Local
    ) {
        self.mapper = mapper
        self.local = local
    }
    
    public func excecute(request: PostModel) -> AnyPublisher<Bool, Error> {
        return self.local.add(entity: {
            return self.mapper.transformDomainToEntity(domain: request)
        }())
        .eraseToAnyPublisher()
    }
}
