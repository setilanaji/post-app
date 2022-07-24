//
//  UserDataStoreDiskUserPrefs.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/23.
//

import Foundation
import Combine

public class UserDataStoreDiskUserPrefs: UserDataStore {
    public typealias Request = String
    public typealias Response = [UserModel]
    
    let accessQueque = DispatchQueue(label: "id.ydhstj.post-app.userdatastore.userprefs.access")
    static let dummiesKey = "userdummieskey"
    
    public init(){}
    
    public func update(data: [UserModel], with key: String) -> AnyPublisher<[UserModel], Error> {
        return Future<[UserModel], Error> { completion in
            self.accessQueque.async {
                let dictionaries = data.map{ model in
                     model.asDictionary()
                }
                UserDefaults.standard.set(dictionaries, forKey: key)
                completion(.success(data))
            }
        }.eraseToAnyPublisher()
    }
    
    public func read(with key: String) -> AnyPublisher<[UserModel], Error> {
        return Future<[UserModel], Error> { completion in
            self.accessQueque.async {
                guard let dictionaries = UserDefaults.standard.array(forKey: key) as? [[String: Any]] else {
                    completion(.success([]))
                    return
                }
                
                let users = dictionaries.map(UserModel.make(withEncodeDictionary:))
                completion(.success(users))
            }
        }.eraseToAnyPublisher()
    }
    
    public func flush() {
        self.accessQueque.async {
            self.flush(with: UserDataStoreDiskUserPrefs.dummiesKey)
        }
    }
    
    private func flush(with key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
}
