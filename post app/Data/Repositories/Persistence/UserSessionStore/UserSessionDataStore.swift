//
//  AppDataStore.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/23.
//

import Foundation
import Combine

public protocol UserSessionDataStore {
    associatedtype Session

    func readUserSession() -> AnyPublisher<Session?, Error>
    func save(userSession: Session) -> AnyPublisher<(Session), Error>
    func delete(userSession: Session) -> AnyPublisher<(Session), Error>
}
