//
//  DeleteUserSessionRepository.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/23.
//

import Foundation
import Combine

public struct DeleteUserSessionRepository<
    Store: UserSessionDataStore>: Repository
where
Store.Session == UserSessionModel {
    
    public typealias Request = UserSessionModel
    
    public typealias Response = UserSessionModel
    
    private let store: Store
    
    public init(
        store: Store
    ) {
        self.store = store
    }
    
    public func excecute(request: UserSessionModel) -> AnyPublisher<UserSessionModel, Error> {
            return store.delete(userSession: request)
                .eraseToAnyPublisher()
    }
    
}

