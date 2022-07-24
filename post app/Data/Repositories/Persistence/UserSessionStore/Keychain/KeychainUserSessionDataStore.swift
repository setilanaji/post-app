//
//  KeychainUserSessionDataStore.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/23.
//

import Foundation
import Combine

public class KeychainUserSessionDataStore: UserSessionDataStore {
    public typealias Session = UserSessionModel
    
    // MARK: - Properties
    let userSessionCoder: UserSessionCoding
    
    // MARK: - Methods
    public init(userSessionCoder: UserSessionCoding) {
        self.userSessionCoder = userSessionCoder
    }
    
    public func readUserSession() -> AnyPublisher<UserSessionModel?, Error> {
        return Future<UserSessionModel?, Error> { completion in
            DispatchQueue.global().async {
                do {
                    let query = KeychainItemQuery()
                    if let data = try Keychain.findItem(query: query) {
                        let userSession = self.userSessionCoder.decode(data: data)
                        completion(.success(userSession))
                    } else {
                        completion(.success(nil))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func save(userSession: UserSessionModel) -> AnyPublisher<(UserSessionModel), Error> {
        let data = userSessionCoder.encode(userSession: userSession)
        let item = KeychainItemWithData(data: data)
        return self.readUserSession()
            .flatMap { userSessionFromKeychain -> AnyPublisher<(UserSessionModel), Error> in
                if userSessionFromKeychain == nil {
                    return Future<(UserSessionModel), Error> { completion in
                        do {
                            try Keychain.save(item: item)
                            completion(.success(userSession))
                        } catch {
                            completion(.failure(error))
                        }
                    }.eraseToAnyPublisher()
                } else {
                    return Future<(UserSessionModel), Error> { completion in
                        do {
                            try Keychain.update(item: item)
                            completion(.success(userSession))
                        } catch {
                            completion(.failure(error))
                        }
                    }.eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
    
    public func delete(userSession: UserSessionModel) -> AnyPublisher<(UserSessionModel), Error> {
        return Future<UserSessionModel, Error> { completion in
            DispatchQueue.global().async {
                do {
                    let item = KeychainItem()
                    try Keychain.delete(item: item)
                    completion(.success(userSession))
                } catch {
                    completion(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}

enum KeychainUserSessionDataStoreError: Error {
    
    case typeCast
    case unknown
}
