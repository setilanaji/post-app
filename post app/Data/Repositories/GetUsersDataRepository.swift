//
//  GetUsersDummiesRepository.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/23.
//

import Foundation
import Combine


public struct GetUsersDataRepository<
    Store: UserDataStore>: Repository
where
Store.Request == String,
Store.Response == [UserModel] {
    
    public typealias Request = String
    
    public typealias Response = [UserModel]
    
    private let store: Store
    
    public init(
        store: Store
    ) {
        self.store = store
    }
    
    public func excecute(request: String) -> AnyPublisher<[UserModel], Error> {
        return store.read(with: request)
            .eraseToAnyPublisher()
    }
    
}
