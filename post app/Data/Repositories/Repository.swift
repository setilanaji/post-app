//
//  Repository.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import Foundation
import Combine

public protocol Repository {
    associatedtype Request
    associatedtype Response
    
    func excecute(request: Request) -> AnyPublisher<Response, Error>
}
