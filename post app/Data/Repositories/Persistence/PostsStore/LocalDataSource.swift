//
//  LocalDataSource.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import Combine

public protocol LocalDataSource {
    associatedtype Request
    associatedtype Response
    
    func list(request: Request?) -> AnyPublisher<[Response], Error>
    func add(entity: Response) -> AnyPublisher<Bool, Error>
    func get(request: Request?) -> AnyPublisher<Response, Error>
}
