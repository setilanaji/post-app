//
//  UpdateUsersDataRepository.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/23.
//

import Foundation
import Combine

public struct UpdateUsersDataRepository<
    Store: UserDataStore>: Repository
where
Store.Request == String,
Store.Response == [UserModel] {
    
    public typealias Request = ([UserModel], String)
    
    public typealias Response = [UserModel]
    
    private let store: Store
    
    public init(
        store: Store
    ) {
        self.store = store
    }
    
    public func excecute(request: ([UserModel], String)) -> AnyPublisher<[UserModel], Error> {
        return store.update(data: request.0, with: request.1)
            .eraseToAnyPublisher()
    }
    
}

