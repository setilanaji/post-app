//
//  UserDataStore.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/23.
//

import Foundation
import Combine

public protocol UserDataStore {
    associatedtype Request
    associatedtype Response
    
    func read(with key: Request) -> AnyPublisher<Response, Error>
    func update(data: Response, with key: Request) -> AnyPublisher<Response, Error>
    func flush()
}
