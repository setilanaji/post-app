//
//  PostLocalDataSource.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import Foundation
import Combine
import RealmSwift

public struct PostLocalDataSource: LocalDataSource {
    public typealias Request = String
    public typealias Response = PostEntity
    
    private let realm: Realm?
    
    public init(realm: Realm?) {
        self.realm = realm
    }
    
    public func list(request: String?) -> AnyPublisher<[PostEntity], Error> {
        return Future<[PostEntity], Error> { completion in
            if let realm = realm {
                guard let _ = request else {
                    return completion(.failure(DatabaseError.requestFailed))
                }
                
                let posts: Results<PostEntity> = {
                    realm.objects(PostEntity.self)
                        .sorted(byKeyPath: "id", ascending: false)
                }()
                completion(.success(posts.toArray(offType: PostEntity.self)))
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
    
    public func add(entity: PostEntity) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if let realm = realm {
                do {
                    try realm.write {
                        realm.add(entity, update: .all)
                    }
                    completion(.success(true))
                } catch {
                    completion(.failure(DatabaseError.requestFailed))
                }
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
            
        }.eraseToAnyPublisher()
    }
    
    public func get(request: String?) -> AnyPublisher<PostEntity, Error> {
        return Future<PostEntity, Error> { completion in
            if let realm = realm {
                
                guard let id = request else {
                    return completion(.failure(DatabaseError.requestFailed))
                }
                
                let posts: Results<PostEntity> = {
                    realm.objects(PostEntity.self)
                        .filter("id = '\(id)'")
                }()
                
                guard let post = posts.first else {
                    completion(.failure(DatabaseError.requestFailed))
                    return
                }
                
                completion(.success(post))
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
}
